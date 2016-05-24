require 'stackit/cli/stack_cli'
require 'awskit'

module Awskit
  class Cli < Stackit::BaseCli

    def initialize(*args)
      super(*args)
    end

    def self.require_clis
      Dir.glob("#{Awskit.home}/awskit/*") do |pkg|
        next if File.file?(pkg)
        pkg_name = pkg.split('/').last
        full_pkg_name = "Awskit::#{pkg_name.capitalize}::Cli"
        cli = "#{pkg}/cli.rb"
        if File.exist?(cli)
          require cli
          clazz = full_pkg_name.constantize
          clazz.initialize_cli if clazz.respond_to?('initialize_cli')
        end
      end
    end

    desc 'version', 'Displays awskit version'
    def version
puts <<-LOGO
    ___ _       _______ __ __ __________
   /   | |     / / ___// //_//  _/_  __/
  / /| | | /| / /\__ \/ ,<   / /  / /   
 / ___ | |/ |/ /___/ / /| |_/ /  / /    
/_/  |_|__/|__//____/_/ |_/___/ /_/     

Amazon Web Services Toolkit Generator v#{Awskit::VERSION}

LOGO
    end

  end
end
