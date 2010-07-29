require 'spec_helper'

describe Watcher, "the class" do
  it "does a select across all entries in root" do
    dirs = ['dir']
    File.stub!(:directory?).with('dir').and_return(true)
    Dir.should_receive(:[]).with('*').and_return(dirs)
    Watcher.dirs.should == dirs
  end

  it "selects only directories in root" do
    dirs = ['dir', 'file']
    File.should_receive(:directory?).with('dir').and_return(true)
    File.should_receive(:directory?).with('file').and_return(false)
    Dir.stub!(:[]).and_return(dirs)
    Watcher.dirs.should == ['dir']
  end

  it "generates a path to git based on dir" do
    File.stub!(:join).with('dir', '.git').and_return('dir/.git')
    Watcher.git_path('dir').should == 'dir/.git'
  end

  it "checks to see if git_path exists in order to determine if repo exists" do
    Watcher.stub!(:git_path).with('dir').and_return('dir/.git')
    File.should_receive(:exist?).with('dir/.git').and_return(true)
    Watcher.repo?('dir').should == true
  end

  it "selects all the dirs that are repos" do
    dirs = ['dir1', 'dir2']
    Watcher.stub!(:repo?).with('dir1').and_return(true)
    Watcher.stub!(:repo?).with('dir2').and_return(false)
    Watcher.stub!(:dirs).and_return(dirs)
    Watcher.repos.should == ['dir1']
  end

  describe "with repos" do
    before do
      @repo = stub
      @repo.stub!(:scan)
      @repos = [@repo]
      Watcher.stub!(:repos).and_return(@repos)
    end

    it "creates a new watcher for each repo" do
      Watcher.should_receive(:new).with(@repo).and_return(@repo)
      Watcher.scan
    end

    it "calls scan on each new watcher" do
      @repo.should_receive(:scan)
      Watcher.stub(:new).and_return(@repo)
      Watcher.scan
    end
  end

  describe Watcher, "the instance" do
    before do
      @watcher = Watcher.new('repo')
    end
    
    it "has a repo reader" do
      @watcher.repo.should == 'repo'
    end

    it "executes a shell command in the repo dir" do
      Dir.should_receive(:chdir).with('repo').and_yield
      @watcher.sh("echo hi").should == "hi\n"
    end

    it "uses git to ls-remote origin/master" do
      @watcher.should_receive(:sh).with("git ls-remote origin master").and_return('head')
      @watcher.ls_remote_origin_master.should == 'head'
    end

    it "splits on space and gets the first entry as origin master head sha" do
      @watcher.should_receive(:ls_remote_origin_master).and_return('sha path')
      @watcher.origin_master_head.should == 'sha'
    end
  end
end