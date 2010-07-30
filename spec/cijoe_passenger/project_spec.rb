require 'spec_helper'

describe Project, "the class" do
  it "selects all the dirs that are repos" do
    dirs = ['dir1', 'dir2']
    Git.stub!(:repo?).with('dir1').and_return(true)
    Git.stub!(:repo?).with('dir2').and_return(false)
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
end

describe Project, "the instance" do
  before do
    @project = Project.new('name')
  end
  
  it "has a name reader" do
    @project.name.should == 'name'
  end

  it "splits on space and gets the first entry as origin master head sha" do
    Git.should_receive(:ls_remote_origin_master).and_return('sha path')
    @project.current_head.should == 'sha'
  end

  it "has a path to the file with the previous head sha" do
    @project.prev_head_path.should == "tmp/name"
  end

  it "knows if a prev head file exists" do
    @project.stub!(:prev_head_path).and_return('prev_head_path')
    File.should_receive(:exist?).with('prev_head_path').and_return(true)
    @project.prev_head_file?.should be(true)
  end

  it "reads the sha from a prev_head file" do
    @project.stub!(:prev_head_file?).and_return(true)
    f = stub
    f.stub!(:readline).and_return("sha\n")
    @project.stub!(:prev_head_path).and_return('prev_head_path')
    File.stub!(:open).with('prev_head_path').and_yield(f)
    @project.prev_head.should == 'sha'
  end

  it "has ni previous head if no prev head file" do
    @project.stub!(:prev_head_file?).and_return(false)
    @project.prev_head.should be(nil)
  end

  it "not be refreshable is current_head matches prev_head" do
    @project.stub!(:current_head).and_return('a')
    @project.stub!(:prev_head).and_return('a')
    @project.refreshable?.should be(false)
  end

  it "be refreshable if current_head doesnt match prev_head" do
    @project.stub!(:current_head).and_return('a')
    @project.stub!(:prev_head).and_return('b')
    @project.refreshable?.should be(true)
  end

  it "updates the prev_head_file with current_head" do
    f = mock
    f.should_receive(:<<).with('current_head')
    File.stub!(:open).with('prev_head_path', 'w').and_yield(f)
    @project.stub!(:prev_head_path).and_return('prev_head_path')
    @project.stub!(:current_head).and_return('current_head')
    @project.update_prev_head
  end
end