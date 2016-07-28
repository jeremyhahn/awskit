require 'awskit/gen/cookbook/kitchen_template_binding'
require 'awskit/gen/cookbook/vagrantfile_template_binding'

module Awskit::Gen::Cookbook

  class Service

    attr_accessor :options
    attr_accessor :output_path

    def initialize(options)
      self.options = options
      self.output_path = options[:path] || "./#{cookbook_name}"
    end

    def gen
      gen_dirs
      gen_metadata_rb
      gen_kitchen_yml
      gen_vagrantfile
      gen_readme
      gen_recipes
      gen_attributes
      copy_static_files
    end

  private

    def cookbook_name
      options[:name].downcase
    end

    def gen_dirs
      FileUtils.mkdir_p "#{output_path}/test/integration/default/serverspec/localhost"
      attrs = "#{output_path}/attributes"
      recipes = "#{output_path}/recipes"
      Dir.mkdir attrs unless File.exist?(attrs)
      Dir.mkdir recipes unless File.exist?(recipes)
    end

    def gen_metadata_rb
      Awskit::Gen::TemplateWriter.new(
        :output_path => output_path,
        :template => template_path('metadata.rb'),
        :binding => kitchen_template_binding,
        :filename => 'metadata.rb'
      ).write!
    end

    def gen_kitchen_yml
      Awskit::Gen::TemplateWriter.new(
        :output_path => output_path,
        :template => template_path('.kitchen.yml'),
        :binding => kitchen_template_binding,
        :filename => '.kitchen.yml'
      ).write!
    end

    def gen_vagrantfile
      Awskit::Gen::TemplateWriter.new(
        :output_path => output_path,
        :template => template_path('Vagrantfile'),
        :binding => service_name_template_binding,
        :filename => 'Vagrantfile'
      ).write!
    end

    def gen_readme
      Awskit::Gen::TemplateWriter.new(
        :output_path => output_path,
        :template => template_path('README.md'),
        :binding => service_name_template_binding,
        :filename => 'README.md'
      ).write!
    end

    def gen_recipes
      FileUtils.touch("#{output_path}/recipes/setup.rb")
      FileUtils.touch("#{output_path}/recipes/configure.rb")
      FileUtils.touch("#{output_path}/recipes/deploy.rb")
      FileUtils.touch("#{output_path}/recipes/undeploy.rb")
      FileUtils.touch("#{output_path}/recipes/shutdown.rb")
      File.write("#{output_path}/recipes/setup.rb", "include_recipe 'common'\n")
    end

    def gen_attributes
      FileUtils.touch("#{output_path}/attributes/default.rb")
    end

    def copy_static_files
      FileUtils.cp(static_file('Berksfile'), "#{output_path}/Berksfile")
      FileUtils.cp(static_file('chefignore'), "#{output_path}/chefignore")
      FileUtils.cp(static_file('Gemfile'), "#{output_path}/Gemfile")
      FileUtils.cp(static_file('Thorfile'), "#{output_path}/Thorfile")
      FileUtils.cp(static_file('.gitignore'), "#{output_path}/.gitignore")
      FileUtils.cp(static_file('test/integration/default/serverspec/spec_helper.rb'), "#{output_path}/test/integration/default/serverspec/spec_helper.rb")
      FileUtils.cp(static_file('test/integration/default/serverspec/localhost/default_spec.rb'), "#{output_path}/test/integration/default/serverspec/localhost/default_spec.rb")
    end

    def static_file(file)
      "#{Awskit.home}/awskit/gen/cookbook/templates/#{file}"
    end

    def template_path(template)
      "#{Awskit.home}/awskit/gen/cookbook/templates/#{template}.erb"
    end

    def service_name_template_binding
      ServiceNameTemplateBinding.new(
        service_name: options[:name]
      ).get_binding
    end

    def kitchen_template_binding
      KitchenTemplateBinding.new(
        :aws_ssh_key => Awskit.environment,
        :security_group => '',
        :availability_zone => 'a',
        :subnet_id => '',
        :iam_profile_name => 'ALLOW_ALL',
        :instance_type => 't2.medium',
        :associate_public_ip => true,
        :transport_ssh_key => "#{ENV['HOME']}.ssh/#{Awskit.environment}.pem",
        :transport_username => 'ec2-user',
        :platform_ami => 'ami-60b6c60a',
        :platform_username => 'ec2-user',
        :service_name => options[:name]
      ).get_binding
    end

  end

end
