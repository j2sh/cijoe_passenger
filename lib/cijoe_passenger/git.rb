module CIJoePassenger
  class Git < Thor
    include Thor::Actions

    namespace :git

    def self.git_path(dir)
      File.join(dir, 'work', '.git')
    end

    def self.repo?(dir)
      File.exist?(git_path(dir))
    end

    desc "origin_head_sha NAME", "origin/master/HEAD sha"
    def origin_head_sha(name)
      ls_remote_origin_master(name).split(' ').first
    end

    desc "clone NAME URL", "clone a git repository into the work directory"
    def clone(name, url)
      run "git clone #{url} #{work_path(name)}"
    end

    desc "add_config_to_repo NAME KEY VALUE", "add a config KEY VALUE entry to repo inside work directory of NAME"
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

      def ls_remote_origin_master(name)
        res = ''
        inside_work(name) do
          res = run("git ls-remote origin master")
        end
        res
      end
    end
  end
end