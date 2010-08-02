require 'spec_helper'

describe Install do
  before do
    @install = Install.new
  end

  it "run directory with templates and current working directory" do
    Dir.stub!(:pwd).and_return('pwd')
    @install.should_receive(:directory).with('templates', 'pwd')
    @install.install
  end
end
