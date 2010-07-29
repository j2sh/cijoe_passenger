require 'grit'

class Poll < Thor
  map "omg you are a turd" => :deek

  desc "deek", "You suck"
  def deek
    puts 'deek'
  end
end