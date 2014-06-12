require 'sparql/client'
module Spotlight::Fcrepo4
  class Exhibit < ActiveResource::Ldp::Base
    self.site = Spotlight::Fcrepo4.site
    belongs_to :ldpath_program, class_name: "Spotlight::Fcrepo4::DataBody"

    before_create do
      self.rdf_type ||= []
      self.rdf_type << RDF::URI("https://github.com/sul-dlss/spotlight#Exhibit") 
    end

    before_create do
      self.solr_url ||= Blacklight.solr.url
    end

    schema do
      attribute :rdf_type, :uri, predicate: RDF.type
      attribute :exhibit_url, :uri, predicate: RDF::OWL.sameAs
      attribute :solr_url, :uri, predicate: RDF::URI("http://library.stanford.edu/dlss/dor/indexer#isIndexedTo")
      attribute :ldpath_program_id, :uri, predicate: RDF::URI("http://library.stanford.edu/dlss/dor/indexer#hasService")
    end

    class << self
      def find_or_initialize_by opts = {}
        result = sparql.select("subject").where(
          [:subject, RDF.type, RDF::URI("https://github.com/sul-dlss/spotlight#Exhibit")],
          [:subject, RDF::OWL.sameAs, RDF::URI(opts[:exhibit_url])]
        ).each_solution.first

        if result && self.exists?(result[:subject])
          self.find(result[:subject])
        else
          exhibit = self.new
          exhibit.exhibit_url ||= RDF::URI(opts[:exhibit_url])
          exhibit
        end
      end
      
      private
      def sparql
        @sparql ||= SPARQL::Client.new(self.site + "./fcr:sparql", protocol: '1.1')
      end
    end
  end
end
