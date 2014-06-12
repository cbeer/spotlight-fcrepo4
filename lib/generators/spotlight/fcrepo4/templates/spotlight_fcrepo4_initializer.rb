Spotlight::Fcrepo4.site = ENV['LDP_URL']
Spotlight::Engine.routes.default_url_options[:host] ||= Rails.application.routes.default_url_options[:host]

Rails.application.config.after_initialize do
  Spotlight::Exhibit.send(:include, Spotlight::Fcrepo4::ExhibitLdpath)
end
