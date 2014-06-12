class Spotlight::Fcrepo4::JsonBody < Spotlight::Fcrepo4::DataBody
  self.site = Spotlight::Fcrepo4.site

  has_one :annotation

  delegate :has_key?, to: :data
  
  schema do
    attribute :rdf_type, :uri, predicate: RDF.type
    attribute :data_chars, :string, predicate: RDF::URI('http://www.w3.org/2011/content#chars')
    attribute :format, :string, predicate: RDF::URI('http://purl.org/dc/elements/1.1/format')
  end

  before_save do
    self.data_chars = data.to_json
    self.format ||= "application/json"
  end
  
  def changed?
    super || data_chars != data.to_json
  end

  def data
    @data_attributes ||= if data_chars.present?
      JSON.parse(data_chars)
    else
      {}
    end
  end
end
