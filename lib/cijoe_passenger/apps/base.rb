module CIJoePassenger
  module Apps
    class Base < CIJoe::Server
      before { joe.restore_last_build }
    end
  end
end