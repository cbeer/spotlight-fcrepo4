Spotlight::Fcrepo4::Engine.routes.draw do
  get '/:exhibit_id/ldpath' => 'spotlight/fcrepo4/ldpath#show', as: :exhibit_ldpath
end
