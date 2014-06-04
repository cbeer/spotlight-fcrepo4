class Spoitght::Fcrepo4::BodyText < ActiveResource::Ldp::Base
  self.site = Spotlight::Fcrepo4.site

  has_one :annotation

  delegate :has_key?, to: :content_attributes
  
  schema do
    attribute :rdf_type, :uri, predicate: RDF.type
    attribute :content, :string, predicate: 'cnt:chars'
    attribute :format, :string, predicate: 'dc:format'
  end
  
  before_save do
    self.rdf_type ||= []
    self.rdf_type << "dctypes:Text"
    self.rdf_type << "cnt:ContentAsText"
  end
  
  before_validate do
    self.content = content_attributes.to_json
    self.format ||= "application/json"
  end

  def content_attributes
    @attributes ||= if content.present?
      JSON.parse(content)
    else
      {}
    end
  end
end
