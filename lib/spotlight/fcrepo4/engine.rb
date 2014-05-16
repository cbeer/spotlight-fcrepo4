require 'spotlight'

module Spotlight
  class Fcrepo4::Engine < ::Rails::Engine
    self.config.site ||= ""
  end
end
