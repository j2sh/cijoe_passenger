module CIJoePassenger
  class Project
    attr_reader :name

    def self.dirs
      Dir['*'].select do |f|
        Git.repo?(f)
      end
    end

    def self.all
      dirs.collect{|d| Project.new(d) }
    end

    def initialize(name)
      @name = name
    end

    def prev_head_path
      "tmp/#{name}"
    end

    def prev_head_file?
      File.exist?(prev_head_path)
    end

    def prev_head
      File.open(prev_head_path) do |f|
        f.readline.chop
      end if prev_head_file?
    end

    def current_head
      @current_head ||= Git.ls_remote_origin_master.split(' ').first
    end

    def refreshable?
      current_head != prev_head
    end

    def update_prev_head
      File.open(prev_head_path, "w") do |f|
        f << current_head
      end
    end
  end
end