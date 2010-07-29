module CIJoePassenger
  module Sh
    def self.exec(command, dir = '.')
      Dir.chdir(dir) { `#{command}` }
    end
  end
end