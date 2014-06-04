module Spotlight::Fcrepo4
  class SolrDocumentSidecar < Annotation
    self.site = Spotlight::Fcrepo4.site

    delegate :has_key?, to: :body

    alias_method :ar_update, :update

    before_save do
      self.motivated_by ||= RDF::URI("http://www.w3.org/ns/oa#describing")
    end

    def update attributes = {}
      if attributes.empty?
        ar_update
      else
        self.body ||= self.body.build
        self.body.content_attributes.merge(attributes)
        self.body.save
      end
    end

    def private!
      update public: false
    end

    def public!
      update public: true
    end

  end
end

ActsAsTaggableOn::Tagging.after_save do |obj|
  # should be: ^oa:hasTarget[oa:motivatedBy is oa:tagging] / .[dcterms:isPartOf is <http://localhost:8081/exhibit>] / oa:hasBody / rdfs:label :: xsd:string ;

  tags = obj.taggable.sidecar(obj.tagger)
  tags.body ||= tags.body.build
  tags.body.content_attributes[:tags] ||= []
  tags.body.content_attributes[:tags] << obj.tags.name
  tags.save
end
