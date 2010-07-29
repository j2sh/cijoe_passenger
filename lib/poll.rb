class Poll
  def self.dirs
    # cd into dir
    `git ls-remote origin master`
  end
end