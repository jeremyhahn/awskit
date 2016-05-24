require 'stackit'
require 'awskit/version'

module Awskit
  class << self

    attr_accessor :home
    attr_accessor :logger
    attr_accessor :aws

    def aws
      @aws ||= Stackit.aws
    end

    def home
      Pathname.new(File.expand_path('awskit.gemspec', __dir__)).dirname
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def environment
      @environment ||= Stackit.environment
    end

  end
end
