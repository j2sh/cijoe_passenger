require 'spec_helper'

describe Project, "the class" do
  it "selects all the dirs that are repos" do
    git1 = stub
    git1.stub!(:repo?).and_return(true)
    git2 = stub
    git2.stub!(:repo?).and_return(false)

    dirs = ['dir1', 'dir2']
    Git.stub!(:new).with(['dir1']).and_return(git1)
    Git.stub!(:new).with(['dir2']).and_return(git2)

    Dir.should_receive(:[]).with('*').and_return(dirs)
    Project.dirs.should == ['dir1']
  end

  it "creates a new project for each repo" do
    repo = stub
    repos = [repo]
    Project.stub!(:dirs).and_return(repos)
    Project.should_receive(:new).with(repo).and_return(repo)
    Project.all.should == repos
  end

  it "selects only stale projects" do
    p1 = stub
    p1.stub!(:stale?).and_return(true)
    p2 = stub
    p2.stub!(:stale?).and_return(false)
    Project.stub!(:all).and_return([p1, p2])
    Project.stale.should == [p1]
  end
end

describe Project, "the instance" do
  before do
    @git = stub
    Git.stub!(:new).with(['name']).and_return(@git)
    @project = Project.new('name')
  end
  
  it "has a name reader" do
    @project.name.should == 'name'
  end

  it "has a git instance by default" do
    @project.git.should == @git
  end

  it "is not stale if current_head matches upstream_head" do
    @git.stub!(:current_head).and_return('a')
    @git.stub!(:upstream_head).and_return('a')
    @project.stale?.should be(false)
  end
  
  it "is stale if current_head doesnt match upstream_head" do
    @git.stub!(:current_head).and_return('a')
    @git.stub!(:upstream_head).and_return('b')
    @project.stale?.should be(true)
  end

  it "send a request to cijoe to build the project" do
    CIJoePassenger::Config.stub!(:cijoe_url).and_return('cijoe_url')
    URI.should_receive(:parse).with("http://cijoe_url/name").and_return('uri')
    Net::HTTP.should_receive(:post_form).with('uri', {})
    @project.build
  end
end