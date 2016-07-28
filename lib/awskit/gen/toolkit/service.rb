require 'awskit/gen/toolkit/toolkit_template_binding'

module Awskit::Gen::Toolkit

  class Service

    attr_accessor :options
    attr_accessor :output_path

    def initialize(options)
      self.options = options
      self.output_path = "#{options[:path]}./#{toolkit_name}" || "./#{toolkit_name}"
    end

    def gen
      gen_gem_dirs
      copy_static_files
      gen_toolkit_spec
      gen_bin
      gen_toolkit_main
      gen_cli
      gen_version
      gen_spec
    end

  private

    def toolkit_name
      options[:name].downcase
    end

    def module_name
      toolkit_name.capitalize
    end

    def gen_gem_dirs
      bin = "#{output_path}/bin"
      lib = "#{output_path}/lib"
      spec = "#{output_path}/spec"
      lib_toolkit = "#{output_path}/lib/#{toolkit_name}"
      FileUtils.mkdir_p output_path
      Dir.mkdir bin unless File.exist?(bin)
      Dir.mkdir lib unless File.exist?(lib)
      Dir.mkdir spec unless File.exist?(spec)
      Dir.mkdir lib_toolkit unless File.exist?(lib_toolkit)
      FileUtils.mkdir_p "#{output_path}/test/integration/default/serverspec/localhost"
    end

    def copy_static_files
      FileUtils.cp(static_file('Gemfile'), "#{output_path}/Gemfile")
      FileUtils.cp(static_file('LICENSE.txt'), "#{output_path}/LICENSE.txt")
      FileUtils.cp(static_file('Rakefile'), "#{output_path}/Rakefile")
      FileUtils.cp(static_file('README.md'), "#{output_path}/README.md")
      FileUtils.cp(static_file('.gitignore'), "#{output_path}/.gitignore")
      FileUtils.cp(static_file('.rspec'), "#{output_path}/.rspec")
    end

    def gen_toolkit_spec
      Awskit::Gen::TemplateWriter.new(
        :output_path => output_path,
        :template => template_path('toolkit.gemspec'),
        :binding => template_binding,
        :filename => "#{toolkit_name}.gemspec"
      ).write!
    end

    def gen_bin
      Awskit::Gen::TemplateWriter.new(
        :output_path => "#{output_path}/bin",
        :template => template_path('bin'),
        :binding => template_binding,
        :filename => toolkit_name
      ).write!
      FileUtils.chmod 0775, "#{output_path}/bin/#{toolkit_name}"
    end

    def gen_toolkit_main
      Awskit::Gen::TemplateWriter.new(
        :output_path => "#{output_path}/lib",
        :template => template_path('toolkit'),
        :binding => template_binding,
        :filename => "#{toolkit_name}.rb"
      ).write!
    end    

    def gen_cli
      Awskit::Gen::TemplateWriter.new(
        :output_path => "#{output_path}/lib/#{toolkit_name}",
        :template => template_path('cli'),
        :binding => template_binding,
        :filename => 'cli.rb'
      ).write!
    end

    def gen_version
      Awskit::Gen::TemplateWriter.new(
        :output_path => "#{output_path}/lib/#{toolkit_name}",
        :template => template_path('version'),
        :binding => template_binding,
        :filename => 'version.rb'
      ).write!
    end

    def gen_spec
      Awskit::Gen::TemplateWriter.new(
        :output_path => "#{output_path}/spec",
        :template => template_path('spec_helper'),
        :binding => template_binding,
        :filename => 'spec_helper.rb'
      ).write!
      Awskit::Gen::TemplateWriter.new(
        :output_path => "#{output_path}/spec",
        :template => template_path('toolkit_spec'),
        :binding => template_binding,
        :filename => "#{toolkit_name}_spec.rb"
      ).write!
    end

    def static_file(file)
      "#{Awskit.home}/awskit/gen/toolkit/files/#{file}"
    end

    def template_path(template)
      "#{Awskit.home}/awskit/gen/toolkit/templates/#{template}.erb"
    end

    def template_binding
      ToolkitTemplateBinding.new(
        :toolkit_name => toolkit_name,
        :toolkit_module_name => module_name
      ).get_binding
    end

  end

end
