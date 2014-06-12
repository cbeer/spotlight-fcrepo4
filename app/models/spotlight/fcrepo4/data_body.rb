class Spotlight::Fcrepo4::JsonBody < ActiveResource::Ldp::Base
  self.site = Spotlight::Fcrepo4.site
  
  schema do
    attribute :rdf_type, :uri, predicate: RDF.type
    attribute :data_chars, :string, predicate: RDF::URI('http://www.w3.org/2011/content#chars')
    attribute :format, :string, predicate: RDF::URI('http://purl.org/dc/elements/1.1/format')
  end

  before_save do
    self.rdf_type ||= []
    self.rdf_type << RDF::URI("http://purl.org/dc/dcmitype/Text")
    self.rdf_type << RDF::URI('http://www.w3.org/2011/content#ContentAsText')
  end
end
