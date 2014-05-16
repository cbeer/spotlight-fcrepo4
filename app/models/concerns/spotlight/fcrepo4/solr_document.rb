module Spotlight::Fcrepo4
  module SolrDocument
    def sidecar exhibit
      Spotlight::Fcrepo4::SolrDocumentSidecar.find_or_initialize_by solr_document: self, exhibit: exhibit
    end
    
    def to_solr
      # TODO
    end

  end
end
