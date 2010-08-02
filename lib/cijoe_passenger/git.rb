module CIJoePassenger
  class Git < Thor
    include Thor::Actions

    namespace :git

    def self.git_path(dir)
      File.join(dir, 'work', '.git')
    end

    def self.repo?(dir)

    desc "ls_remote_origin_master", "git ls-remote origin master"
    def ls_remote_origin_master(name)
      inside_work(name) do
        run "git ls-remote origin master"
      end
    end

    desc "origin_head_sha", "origin/master/HEAD sha"
    def origin_head_sha(name)
      ls_remote_origin_master(name).split(' ').first
    end

    desc "clone URL", "clone a git repository into the work directory"
    def clone(name, repo)
      run "git clone #{repo} #{work_path(name)}"
    end

    desc "add_config_to_repo NAME KEY VALUE", "add a config KEY VALUE entry to repo inside directory NAME"
    def add_config_to_repo(name, key, value)
      inside_work(name) do
        run "git config --add \"#{key}\" \"#{value}\""
      end
    end

    no_tasks do
      def work_path(name)
        File.join(name, 'work')
      end

      def inside_work(name, &block)
        inside(work_path(name), &block)
      end
    end
  end
end