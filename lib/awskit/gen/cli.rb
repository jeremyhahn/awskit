require 'erb'
require 'awskit/gen/template_writer'
require 'awskit/gen/toolkit/service'
require 'awskit/gen/cookbook/service'

module Awskit::Gen

  class Cli < Stackit::BaseCli

    def initialize(*args)
    	super(*args)
    end

    def self.initialize_cli
      Thor.desc "gen", "AWS DevOps toolkit cookbook scaffolding"
      Thor.subcommand "gen", self
    end

    desc 'toolkit', 'Generate a new toolkit'
    method_option :name, aliases: '-n', desc: 'The toolkit name', :required => true
    method_option :path, aliases: '-p', desc: 'A file system path to output the generated toolkit'
    def toolkit
      Toolkit::Service.new(options).gen
    end

    desc 'cookbook', 'Chef cookbook scaffolding'
    method_option :name, aliases: '-n', desc: 'The cookbook name', :required => true
    method_option :path, aliases: '-p', desc: 'A file system path to output the generated cookbook'
    def cookbook
      Cookbook::Service.new(options).gen
    end

  end

end
