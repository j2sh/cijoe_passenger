module CIJoePassenger
  class Git < Thor
    include Thor::Actions

    namespace :git

    def self.git_path(dir)
      File.join(dir, '.git')
    end

    def self.repo?(dir)
      File.exist?(git_path(dir))
    end

    desc "clone URL", "clone a git repository"
    def clone(repo)
      run "git clone #{repo}"
    end

    desc "ls_remote_origin_master", "git ls-remote origin master"
    def ls_remote_origin_master
      run "git ls-remote origin master"
    end

    desc "add_config_to_repo NAME KEY VALUE", "add a config KEY VALUE entry to repo inside directory NAME"
    def add_config_to_repo(name, key, value)
      inside(name) do
        run "git config --add \"#{key}\" \"#{value}\""
      end
    end

    desc "origin_head_sha", "origin/master/HEAD sha"
    def origin_head_sha
      ls_remote_origin_master.split(' ').first
    end
  end
end