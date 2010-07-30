require 'spec_helper'

describe Installer, "the class" do
  before do
    @installer = Installer.new('name', 'repo')
  end

  it "should have a name reader" do
    @installer.name.should == 'name'
  end

  it "should have a repo reader" do
    @installer.repo.should == 'repo'
  end

  it "installs the bundle for the project" do
    Sh.should_receive(:exec).with("[[ -f Gemfile ]] && bundle install", 'name')
    @installer.bundle_install
  end

  it "links to the template rack config" do
    Sh.should_receive(:exec).with("ln -s config/config.ru name/public/config.ru")
    @installer.link_rack_config
  end

  it "configures cijoe runner in git config" do
    CIJoePassenger::Config.stub!(:runner).and_return('runner')
    Git.should_receive(:add_config_to_repo).with("cijoe.runner", "runner", 'name')
    @installer.configure_cijoe_runner
  end

  it "updates the apache config by adding a base uri and saving" do
    @installer.should_receive(:add_rack_base_uri_to_apache_config)
    @installer.should_receive(:save_apache_config)
    @installer.update_apache_config
  end

  it "insert a new rackbaserui into apache config array" do
    apache_config = mock
    apache_config.should_receive(:insert).with(1, "\tRackBaseURI /name/public\n")
    @installer.stub!(:apache_config).and_return(apache_config)
    @installer.add_rack_base_uri_to_apache_config
  end

  it "installs a new repo" do
    Git.should_receive(:clone).with('repo')
    @installer.should_receive(:bundle_install)
    @installer.should_receive(:link_rack_config)
    @installer.should_receive(:update_apache_config)
    @installer.should_receive(:configure_cijoe_runner)
    @installer.should_receive(:configure_campfire)
    @installer.should_receive(:puts).with("Don't forget to setup a config/database.yml")
    @installer.add
  end

  describe "with an apache config" do
    before do
      CIJoePassenger::Config.stub!(:apache_config_path).and_return('apache_config_path')
      @lines = ["apache\n", "config\n"]
      @f = mock
    end

    it "returns the apache config lines in an array" do
      @f.should_receive(:readlines).and_return(@lines)
      File.should_receive(:open).with('apache_config_path', 'r').and_yield(@f)
      @installer.apache_config.should == @lines
    end

    it "save the current apache config to the actual config file" do
      @installer.stub!(:apache_config).and_return(@lines)
      @f.should_receive(:writes).with("apache\nconfig\n")
      File.should_receive(:open).with('apache_config_path', 'w').and_yield(@f)
      @installer.save_apache_config
    end
  end
end
