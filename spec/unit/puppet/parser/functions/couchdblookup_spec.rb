#!/usr/bin/env rspec

require 'puppet'
require 'puppetlabs_spec_helper/module_spec_helper'

describe "the couchdblookup function" do

  let(:scope) do
    PuppetlabsSpec::PuppetInternals.scope
  end

  subject do
    function_name = Puppet::Parser::Functions.function(:couchdblookup)
    scope.method(function_name)
  end

  let(:openuri) do
    OpenURI
  end

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

  it "should raise a ParseError unless there is 2 or 3 arguments" do
    lambda {
      @scope.function_couchdblookup([])
    }.should      raise_error(Puppet::ParseError, /wrong number of arguments/)

    lambda {
      @scope.function_couchdblookup([1])
    }.should      raise_error(Puppet::ParseError, /wrong number of arguments/)

    lambda {
      @scope.function_couchdblookup([1,2])
   }.should_not   raise_error(Puppet::ParseError, /wrong number of arguments/)

    lambda {
      @scope.function_couchdblookup([1,2,3])
   }.should_not   raise_error(Puppet::ParseError, /wrong number of arguments/)

    lambda {
      @scope.function_couchdblookup([1,2,3,4])
   }.should       raise_error(Puppet::ParseError, /wrong number of arguments/)
  end

  it "should return the value of a key from a single couchdb document" do
    sample_json = File.open(@datapath + 'one-document.txt')
    openuri.stubs(:open_uri).returns(sample_json)

    result = @scope.function_couchdblookup(["http://fake/uri", "wiki"])
    result.should eq(true)
  end

  it "should return false if the value in the JSON doc is false" do
    sample_json = File.open(@datapath + 'one-document.txt')
    openuri.stubs(:open_uri).returns(sample_json)

    result = @scope.function_couchdblookup(["http://fake/uri", "rt"])
    result.should eq(false)
    result.should_not eq(nil)
    lambda { result }.should_not raise_error(Puppet::ParseError, /not found in JSON object/)
  end

  it "should raise a ParseError if a key can't be found in a couchdb document" do
    sample_json = File.open(@datapath + 'one-document.txt')
    openuri.stubs(:open_uri).returns(sample_json)

    result = lambda { @scope.function_couchdblookup(["http://fake/uri", "fake-key"]) }
    result.should raise_error(Puppet::ParseError, /not found in JSON object/)
  end

  it "should return the value passed as 3rd argument when the key is not found" do
    sample_json = File.open(@datapath + 'one-document.txt')
    openuri.stubs(:open_uri).returns(sample_json)

    result = @scope.function_couchdblookup(["http://fake/uri", "fake-key", "3rd arg"])
    result.should eq('3rd arg')
  end

  it "should not return the value passed as 3rd argument when the key is found" do
    sample_json = File.open(@datapath + 'one-document.txt')
    openuri.stubs(:open_uri).returns(sample_json)

    result = @scope.function_couchdblookup(["http://fake/uri", "wiki", "3rd arg"])
    result.should eq(true)
    result.should_not eq('3rd arg')
  end

  it "should return an array from the values of a couchdb view" do
    sample_json = File.open(@datapath + 'map.txt')
    openuri.stubs(:open_uri).returns(sample_json)

    result = @scope.function_couchdblookup(["http://fake/uri", "value"])
    result.should eq(["foo", "bar"])
  end

  it "should raise a ParseError if a key can't be found in the rows of a couchdb view" do
    sample_json = File.open(@datapath + 'map.txt')
    openuri.stubs(:open_uri).returns(sample_json)

    result = lambda { @scope.function_couchdblookup(["http://fake/uri", "fake-key"]) }
    result.should raise_error(Puppet::ParseError, /not found in JSON object/)
  end

  it "should return an array the values from a couchdb reduced view" do
    sample_json = File.open(@datapath + 'map+reduce.txt')
    openuri.stubs(:open_uri).returns(sample_json)

    result = @scope.function_couchdblookup(["http://fake/uri", "value"])
    result.should eq(["foo", "bar", "baz"])
  end

  it "should raise a ParseError if a key can't be found in the rows of a couchdb reduced view" do
    sample_json = File.open(@datapath + 'map+reduce.txt')
    openuri.stubs(:open_uri).returns(sample_json)

    result = lambda { @scope.function_couchdblookup(["http://fake/uri", "fake-key"]) }
    result.should raise_error(Puppet::ParseError, /not found in JSON object/)
  end

  it "should raise a ParseError if couchdb can't find the requested document" do
    sample_json = File.open(@datapath + 'missing.txt')
    openuri.stubs(:open_uri).returns(sample_json)

    result = lambda { @scope.function_couchdblookup(["http://fake/uri", "a-key"]) }
    result.should raise_error(Puppet::ParseError, /not found in JSON object/)
  end

  it "should raise a ParseError if input in not valid JSON" do
    sample_json = File.open(@datapath + 'proxy-failure.txt')
    openuri.stubs(:open_uri).returns(sample_json)

    result = lambda { @scope.function_couchdblookup(["http://fake/uri", "a-key"]) }
    result.should raise_error(Puppet::ParseError, /failed to parse JSON/)
  end

  it "should always return undef if 'vagrantbox' fact is defined" do
    scope.stubs(:lookupvar).with('vagrantbox').returns('true')

    subject.call(["http://fake/uri", "value"]).should eq(:undef)
  end

end
