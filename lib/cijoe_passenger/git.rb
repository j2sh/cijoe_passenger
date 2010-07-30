module CIJoePassenger
  module Git
    def self.git_path(dir)
      File.join(dir, '.git')
    end

    def self.repo?(dir)
      File.exist?(git_path(dir))
    end

    def self.clone(repo)
      Sh.exec "git clone #{repo}"
    end

    def self.ls_remote_origin_master
      Sh.exec "git ls-remote origin master"
    end

    def self.add_config_to_repo(key, value, repo)
      Sh.exec "git config --add \"#{key}\" \"#{value}\"", repo
    end
  end
end