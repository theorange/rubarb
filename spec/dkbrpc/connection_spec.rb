require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'dkbrpc/server'
require "dkbrpc/connection"
require "dkbrpc/remote_call"
require "dkbrpc/default"

describe Dkbrpc::Connection do
  CUSTOM_INSECURE_METHODS = [:==, :===, :=~]

  before(:all) do
    @reactor = start_reactor
  end

  after(:all) do
    stop_reactor(@reactor)
  end

  it "has an instance of Dkbrpc::Id" do
    @connection = Dkbrpc::Connection.new("host", "port", "api")
    @connection.msg_id_generator.class.should == Dkbrpc::Id
  end

  it "should stop" do
    @result = "blah"
    @connection = Dkbrpc::Connection.new("host", "port", "api")
    @connection.stop do |result|
      @result = result
    end

    wait_for { @result == false }
    @result.should == false
  end

  describe "with client and server connected" do
    before(:all) do
      @server = Dkbrpc::Server.new("127.0.0.1", 9441, mock("server"))
      @connection = Dkbrpc::Connection.new("127.0.0.1", 9441, mock("client"))
      @server.start
      @connected = false
      @connection.start do
        @connected = true
      end
      wait_for { @connected }
    end

    it "sets an instance of Dkbrpc::Id to remote_connection" do
      @connection.remote_connection.msg_id_generator.class.should == Dkbrpc::Id
    end

    it "sets an instance of insecure_methods to remote_connection" do
      @connection.remote_connection.insecure_methods.class.should == Array
    end

    it "has default insecure methods" do
      @connection.remote_connection.insecure_methods.should == Dkbrpc::Default::INSECURE_METHODS
    end

    it "can accept custom insecure methods" do
      connection = Dkbrpc::Connection.new("127.0.0.1", 9441, mock("client"), CUSTOM_INSECURE_METHODS)
      connected = false
      connection.start do
        connected = true
      end
      wait_for { connected }
      connection.remote_connection.insecure_methods.should == CUSTOM_INSECURE_METHODS
    end

    it "should stop after it's connected" do
      connection = Dkbrpc::Connection.new("127.0.0.1", 9441, mock("client"))
      connected = false
      connection.start do
        connected = true
      end
      wait_for { connected }

      @result = "boo"
      connection.stop do |result|
        @result = result
      end
      wait_for{@result == true}
      @result.should == true

    end


  end

end

describe Dkbrpc::OutgoingHandler do
  include Dkbrpc::OutgoingHandler
  include Dkbrpc::RemoteCall

  before(:each) do
    @sent_data = ""
    self.stub!(:send_data) do |data|
      @sent_data << data
    end
    post_init
  end

  it "should send type on start" do
    connection_completed
    @sent_data.should == "4"
  end

  it "should open an outgoing connection with connection id" do
    connection_completed
    @host = "1.2.3.4"
    @port = 2321
    EventMachine.should_receive(:connect).with("1.2.3.4", 2321, Dkbrpc::IncomingHandler)
    receive_data("0000")
    receive_data("0001")
  end

  it "should send marshaled calls" do
    @callback = {}
    @sent_msg = ""
    id_generator = mock("id")
    id_generator.stub!(:next).and_return("00000001")
    @msg_id_generator = id_generator
    self.stub!(:send_message) { |msg| @sent_msg << msg }
    remote_call(:foo, "bary")
    @sent_msg.should == marshal_call("00000001", :foo, "bary")
  end
end

describe Dkbrpc::IncomingHandler do
  include Dkbrpc::IncomingHandler

  before(:each) do
    @sent_data = ""
    self.stub!(:send_data) do |data|
      @sent_data << data
    end
    post_init
  end

  it "should send type and id on connection made" do
    @id = "00000001"
    connection_completed
    @sent_data.should == "500000001"
  end

  it "should call back when finished" do
    callback = false
    @on_connection = Proc.new { callback = true }
    @id = "00000001"

    connection_completed
    callback.should == false

    receive_message(@id)
    callback.should == true
  end

  it "should errback if ids do not match" do
    errback_msg = false
    @errbacks = [Proc.new { |error| errback_msg = error.message }]
    @id = "00000001"

    connection_completed
    receive_message("00000004")
    errback_msg.should == "Handshake Failure"
  end
end
