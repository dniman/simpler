require 'pathname'
require './lib/simpler/application'
require './lib/simpler/middleware/logger'

module Simpler

  class << self
    def application
      Application.instance
    end

    def root
      Pathname.new(File.expand_path('..', __dir__))
    end
  end

end
