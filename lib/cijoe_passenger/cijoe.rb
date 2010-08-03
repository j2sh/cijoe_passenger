class CIJoe
  def restore_last_build
    @last_build = read_build('last')
  end
end