$: << File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'rubygems'
require 'rubarb'

class ClientApi
  def initialize(name)
    @name = name
  end
  def name(responder)
    responder.reply(@name)
  end
end

EM::run do
  connection = Rubarb::Connection.new("127.0.0.1", 9447, ClientApi.new(ARGV[0]))
  connection.errback do |error|
    puts ("Connection Error:  #{error}")
  end

  connection.start do
    connection.time do |response|
      puts "Server Said it is:  #{response.strftime("%D")}"
    end

    connection.keep_alive_time=2

    EventMachine.add_timer(20) do
      puts "stopping"
      connection.stop
      EM::stop
    end
  end

end