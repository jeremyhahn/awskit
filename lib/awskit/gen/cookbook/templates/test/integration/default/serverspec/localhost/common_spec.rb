require 'spec_helper'

describe command('java -version') do
  its(:exit_status) { should eq(0) }
  its(:stdout) { should match(/.*1.8.*/) }
end
