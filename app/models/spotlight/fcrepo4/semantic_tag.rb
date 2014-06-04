module Spotlight::Fcrepo4
  class SemanticTag < ActiveResource::Ldp::Base
    self.site = Spotlight::Fcrepo4.site

    schema do
      attribute :data, :string, predicate: RDFS.label
    end
    
  end
end
