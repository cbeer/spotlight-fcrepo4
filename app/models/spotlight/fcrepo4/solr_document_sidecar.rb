module Spotlight::Fcrepo4
  class SolrDocumentSidecar < Annotation
    self.site = Spotlight::Fcrepo4.site

    belongs_to :exhibit  
    belongs_to :body, class_name: "Spotlight::Fcrepo4::JsonBody"
    
    schema do
      attribute :exhibit_id, :uri, predicate: RDF::DC.isPartOf

      attribute :rdf_type, :uri, predicate: RDF.type
      attribute :motivated_by, :uri, predicate: RDF::URI("http://www.w3.org/ns/oa#motivatedBy") 
      attribute :target_id, :uri, predicate: RDF::URI("http://www.w3.org/ns/oa#hasTarget") 
      attribute :body_id, :uri, predicate: RDF::URI("http://www.w3.org/ns/oa#hasBody")
      attribute :serialized_by, :uri, predicate: RDF::URI("http://www.w3.org/ns/oa#serializedBy")
    end

    delegate :has_key?, to: :body
    delegate :data, to: :body

    alias_method :ar_update, :update

    before_save do
      self.motivated_by ||= RDF::URI("http://www.w3.org/ns/oa#describing")
    end

    def update attributes = {}
      if attributes.empty?
        ar_update
      else
        self.body ||= self.build_body
        self.body.data.merge!(attributes.except(*schema.keys))
        self.body.save

        self.attributes.merge! attributes.slice(*schema.keys)

        self.save
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
