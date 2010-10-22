require 'dkbrpc/server'
require 'dkbrpc/connection'
require 'socket'

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Server Failures" do

  it "should handle the loss of a client" do
    EM.run do
      @server = Dkbrpc::Server.new("127.0.0.1", 9441, mock("server"))
      @connection = Dkbrpc::Connection.new("127.0.0.1", 9441, mock("client"))
      @connection2 = Dkbrpc::Connection.new("127.0.0.1", 9441, mock("client"))


      @cons = 0
      @server.start do |client|
        @cons += 1
        if (@cons == 2)
          @connection.stop
        end
        client.errback do
          @cons -= 1
          if @cons == 1
            EM.stop
          end
        end
      end

      @connection.start
      @connection2.start

      wait_for_connections(2, 10) do
        @connection.stop
        wait_for_connections(1, 10) do
          @cons.should == 1
          EM.stop
        end
      end

    end

  end

  it "should call errorback when port is already in use" do
    in_the_way = TCPServer.open(9441)
    @errback_called = false
    EM.run do
      @server = Dkbrpc::Server.new("127.0.0.1", 9441, mock("server"))
      @server.errback do
        @errback_called = true
      end
      @server.start
    end

    wait_for{@errback_called}
  end

  def wait_for_connections(n, ttl, &block)
    if ttl <= 0
      fail("TTL expired")
    end

    if @cons != n
      EventMachine.add_periodic_timer(0.1) do
        wait_for_connections(n, ttl -1, &block )
      end
    else
      yield
    end
  end

end
