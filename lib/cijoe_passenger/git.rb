module CIJoePassenger
  class Git < Thor::Group
    include Thor::Actions

    namespace :git
    argument :name, :type => :string, :desc => "The project NAME"

    def repo_path
      File.join(name, 'work')
    end

    def git_path
      File.join(repo_path, '.git')
    end

    def repo?
      File.exist?(git_path)
    end

    def inside_repo(&block)
      inside(repo_path, &block)
    end

    def ls_remote_origin_master
      res = ''
      inside_repo do
        res = run("git ls-remote origin master")
      end
      res
    end

    def upstream_head
      ls_remote_origin_master.split(' ').first
    end

    def current_head
      res = ''
      inside(git_path) do
        res = run("cat #{File.join('refs', 'heads', 'master')}")
      end
      res.chop
    end

    def clone(url)
      run "git clone #{url} #{repo_path}"
    end

    def add_config_to_repo(key, value)
      inside_repo do
        run "git config --add \"#{key}\" \"#{value}\""
      end
    end
  end
end