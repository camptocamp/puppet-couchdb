#!/usr/bin/env rspec

require 'puppet'

describe "the couchdblookup function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
    @datapath = File.dirname(__FILE__) + '/../../../data/'
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("couchdblookup").should == "function_couchdblookup"
  end

  it "should raise a ParseError unless there is exactly 2 arguments" do
    lambda { @scope.function_couchdblookup([]) }.should       raise_error(Puppet::ParseError)
    lambda { @scope.function_couchdblookup([1]) }.should      raise_error(Puppet::ParseError)
    lambda { @scope.function_couchdblookup([1,2,3]) }.should  raise_error(Puppet::ParseError)
  end

  it "should return the value of a key from a single couchdb document" do
    sample_json = File.open(@datapath + 'one-document.txt')
    OpenURI.stub!(:open_uri).and_return(sample_json)

    result = @scope.function_couchdblookup(["http://fake/uri", "wiki"])
    result.should eq(true)
  end

  it "should raise a ParseError if a key can't be found in a couchdb document" do
    sample_json = File.open(@datapath + 'one-document.txt')
    OpenURI.stub!(:open_uri).and_return(sample_json)

    result = lambda { @scope.function_couchdblookup(["http://fake/uri", "fake-key"]) }
    result.should raise_error(Puppet::ParseError)
  end

  it "should return an array from the values of a couchdb view" do
    sample_json = File.open(@datapath + 'map.txt')
    OpenURI.stub!(:open_uri).and_return(sample_json)

    result = @scope.function_couchdblookup(["http://fake/uri", "value"])
    result.should eq(["foo", "bar"])
  end

  it "should raise a ParseError if a key can't be found in the rows of a couchdb view" do
    sample_json = File.open(@datapath + 'map.txt')
    OpenURI.stub!(:open_uri).and_return(sample_json)

    result = lambda { @scope.function_couchdblookup(["http://fake/uri", "fake-key"]) }
    result.should raise_error(Puppet::ParseError)
  end

end
