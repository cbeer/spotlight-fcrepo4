module Spotlight::Fcrepo4::ExhibitLdpath
  extend ActiveSupport::Concern

  included do
    after_touch do
      repository_object.ldpath_program ||= repository_object.build_ldpath_program
      repository_object.ldpath_program.data_chars = program
      repository_object.ldpath_program.save
    end  
  end

  def program
    program = File.read(File.join(Rails.root, "config", "ldpath_program"))
    program += "\n" + [ldpath_custom_fields, ldpath_tags, ldpath_visibility].flatten.join("\n")
  end
  
  def repository_object
    Spotlight::Fcrepo4::Exhibit.find_or_initialize_by exhibit_url: exhibit_url
  end

  private
  
  def ldpath_custom_fields
    custom_fields.map do |field|
      "#{field.field} = ^oa:hasTarget[oa:motivatedBy is oa:describing] / .[dc:isPartOf is <#{exhibit_url}>] / oa:hasBody / <http://www.w3.org/2011/content#chars> / fn:jsonpath(\"$.#{field.field}\") :: xsd:string ;"
    end
  end
  
  def ldpath_tags
    ["#{Spotlight::SolrDocument.solr_field_for_tagger(self)} = ^oa:hasTarget[oa:motivatedBy is oa:describing] / .[dc:isPartOf is <#{exhibit_url}>] / oa:hasBody / <http://www.w3.org/2011/content#chars> / fn:jsonpath(\"$.tags\") :: xsd:string ;"]
  end
  
  def ldpath_visibility
    ["#{Spotlight::SolrDocument.visibility_field(self)} = ^oa:hasTarget[oa:motivatedBy is oa:describing] / .[dc:isPartOf is <#{exhibit_url}>] / oa:hasBody / <http://www.w3.org/2011/content#chars> / fn:jsonpath(\"$.public\") :: xsd:string ;"]
  end

  def exhibit_url
    Spotlight::Engine.routes.url_helpers.exhibit_url self
  end

end
