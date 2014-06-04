module Spotlight::Fcrepo4
  module SolrDocument
    def sidecar exhibit
      Spotlight::Fcrepo4::SolrDocumentSidecar.find_or_initialize_by target_id: self[:url_ssi], exhibit: exhibit, motivated_by: RDF::URI("http://www.w3.org/ns/oa#describing")
    end
    
    def to_solr
      
    end

  end
end
