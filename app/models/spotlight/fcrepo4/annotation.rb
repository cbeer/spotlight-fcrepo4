require 'sparql/client'
module Spotlight::Fcrepo4
  class Annotation < ActiveResource::Ldp::Base
    self.site = Spotlight::Fcrepo4.site

    belongs_to :target
    belongs_to :body
    
    schema do
      attribute :rdf_type, :uri, predicate: RDF.type
      attribute :motivated_by, :uri, predicate: RDF::URI("http://www.w3.org/ns/oa#motivatedBy") 
      attribute :target_id, :uri, predicate: RDF::URI("http://www.w3.org/ns/oa#hasTarget") 
      attribute :body_id, :uri, predicate: RDF::URI("http://www.w3.org/ns/oa#hasBody")
      attribute :serialized_by, :uri, predicate: RDF::URI("http://www.w3.org/ns/oa#serializedBy")
    end

    before_create do
      self.rdf_type ||= []
      self.rdf_type << RDF::URI("http://www.w3.org/ns/oa#Annotation") 
    end
    
    class << self
      def find_or_initialize_by opts = {}
        result = sparql.select("subject").where(
          [:subject, RDF.type, RDF::URI("http://www.w3.org/ns/oa#Annotation")],
          [:subject, RDF::URI("http://www.w3.org/ns/oa#hasTarget"), RDF::URI(opts[:target_id])],
          [:subject, RDF::URI("http://www.w3.org/ns/oa#motivatedBy"), opts[:motivated_by] || :motivation],
          [:subject, RDF::DC.isPartOf, (RDF::URI(Spotlight::Engine.routes.url_helpers.exhibit_url(opts[:exhibit])) if opts[:exhibit]) || :exhibit ]
        ).each_solution.first

        if result && self.exists?(result[:subject])
          self.find(result[:subject])
        else
          anno = self.new
          anno.exhibit_id ||= RDF::URI(Spotlight::Engine.routes.url_helpers.exhibit_url(opts[:exhibit])) if opts[:exhibit]
          anno.target_id ||= opts[:target_id] if opts[:target_id]
          anno.body ||= anno.body.build(opts[:body]) if opts[:body]
          anno.motivated_by ||= opts[:motivated_by] if opts[:motivated_by]
          anno
        end
      end
      
      private
      def sparql
        @sparql ||= SPARQL::Client.new(self.site + "./fcr:sparql", protocol: '1.1')
      end
    end


  end
end
