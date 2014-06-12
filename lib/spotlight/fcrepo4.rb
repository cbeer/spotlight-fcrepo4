require 'spotlight'

module Spotlight
  module Fcrepo4
    require 'spotlight/fcrepo4/version'
    require 'spotlight/fcrepo4/engine'
    mattr_accessor :site
    self.site ||= ENV['LDP_URL']
  end
end
