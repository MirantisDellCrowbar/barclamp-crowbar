require 'socket'
module RemoteNode
  # hosts for allowing run ssh commands
  # @param host [string] hostname or IP
  # @param timeout [integer] timeout in seconds
  def self.ready? host, timeout=60
    sleep(10)
    nobj = NodeObject.find_node_by_name(host)
    start = Time.now.to_i
    puts "starting main loop"
    while (Time.now.to_i - start) < timeout do
      begin
        puts "checking socket"
        TCPSocket.new(host, 22)
        if %w(redhat centos).include?(nobj[:platform])
          puts "checking ssh for rhel"
          raise "next" unless system("sudo -i -u root -- ssh root@#{host} 'runlevel | grep \"N 3\"'")
        else
          puts "checking ssh non-rhel"
          raise "next" unless system("sudo -i -u root -- ssh root@#{host} 'last | head -n1 | grep -vq down'")
        end
        return true
      rescue
        puts "sleeping until next cycle"
        sleep(10)
        next
      end
    end
    return false
  end
end

