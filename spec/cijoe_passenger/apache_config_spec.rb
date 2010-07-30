require 'spec_helper'

describe ApacheConfig do
  before do
    CIJoePassenger::Config.stub!(:apache_config_path).and_return('apache_config_path')
    @lines = ["apache\n", "config\n"]
    @f = mock
  end

  it "returns the apache config lines in an array" do
    @f.should_receive(:readlines).and_return(@lines)
    File.should_receive(:open).with('apache_config_path', 'r').and_yield(@f)
    ApacheConfig.read.should == @lines
  end

  it "save the current apache config to the actual config file" do
    config = ["apache\n", "config\n"]
    @f.should_receive(:writes).with("apache\nconfig\n")
    File.should_receive(:open).with('apache_config_path', 'w').and_yield(@f)
    ApacheConfig.write(config)
  end

  it "insert a new rackbaserui into apache config array" do
    read = mock
    read.should_receive(:insert).with(1, "\tRackBaseURI /name/public\n").and_return('new_config')
    ApacheConfig.stub!(:read).and_return(read)
    ApacheConfig.should_receive(:write).with('new_config')
    ApacheConfig.add_app('name')
  end
end