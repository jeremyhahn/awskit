# awskit

DevOps toolkit and Chef cookbook generator for Amazon Web Services based on [StackIT](https://github.com/jeremyhahn/stackit).

## Usage

	./bin/awskit gen toolkit --name mytoolkit
	./bin/awskit gen cookbook --name mycookbook

## Plugins

The generated toolkit supports a plugin style architecture that makes it easy to add new commands to the CLI.

To create a new command named "mycommand":

1. Create directory %TOOLKIT_HOME%/lib/%TOOLKIT_NAME%/mycommand
2. Create cli.rb with the following content

```ruby
module MyToolkit::Mycommand

  class Cli < Stackit::BaseCli

    def initialize(*args)
      super(*args)
    end

    def self.initialize_cli
      Thor.desc "mycommand", "Runs mycommand"
      Thor.subcommand "mycommand", self
    end

  end
end
```

Now when the help command is run, "mycommand" is in the list of supported commands.
