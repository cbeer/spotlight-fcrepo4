require 'rails/generators'

class Spotlight::Fcrepo4::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def inject_solr_document_behavior
    inject_into_class 'app/models/solr_document.rb', SolrDocument, "  include Spotlight::Fcrepo4::SolrDocument"
  end

  def inject_exhibit_indexing_behavior
    copy_file "spotlight_fcrepo4_initializer.rb", "config/initializers/spotlight_fcrepo4.rb"
  end
end
