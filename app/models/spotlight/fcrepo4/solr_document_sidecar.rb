module Spotlight::Fcrepo4
  class SolrDocumentSidecar < ActiveResource::Ldp::Base
    self.site = Spotlight::Fcrepo4::Engine.config.site
    belongs_to :exhibit
    belongs_to :solr_document

    delegate :has_key?, to: :attributes

    alias_method :ar_update, :update
    
    schema do
      attribute :tags, :string, predicate: RDF::URL(":exhibit_url#tags")
    end
    
    before_save do
      schema[:tags][:predicate] = RDF::URL(Spotlight::Engine.routes.url_helpers.exhibit_url(exhibit) +"#tags")
    end

    def update attributes = {}
      if attributes.empty?
        ar_update
      else
        schema do
          (attributes.keys - known_attributes).each do |k|
            attribute k, :string, predicate: RDF::URI(Spotlight::Engine.routes.url_helpers.exhibit_url(exhibit) + "#" + k)
          end
        end
        update_attributes attributes
      end
    end

    def private!
      update public: false
    end

    def public!
      update public: true
    end

    protected

    def visibility_field
      Spotlight::SolrDocument.visibility_field(exhibit)
    end
  end
end

ActsAsTaggableOn::Tagging.after_save do |obj|
  sidecar = Spotlight::Fcrepo4::SolrDocumentSidecar.find_or_initialize_by solr_document: obj.taggable, exhibit: obj.tagger
  sidecar.tags += obj.tag.name
  sidecar.save
end
