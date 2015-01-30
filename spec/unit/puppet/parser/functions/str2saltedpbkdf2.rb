require 'spec_helper'
require 'puppetlabs_spec_helper/puppetlabs_spec/puppet_internals'

describe 'the str2saltedpbkdf2 function' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope  }

  it "should exist" do
    Puppet::Parser::Functions.function("str2saltedpbkdf2").should == "function_str2saltedpbkdf2"
  end

  it "should encrypt a string" do

    salt = 'f3d45ae62e58af23fdbdbba0488ed622'
    OpenSSL::Random.should_receive(:random_bytes).and_return([salt].pack('H*'))
    password_hash = scope.function_str2saltedpbkdf2(['password', 20, 20, 10])

    password_hash.should(eq("-pbkdf2-958de1d2a2326f73e3b3d8527394a3c40736b4e7,#{salt},10"))
  end

  it "should check arguments length" do
    expect(scope.function_str2saltedpbkdf2(['password'])).to raise_error 
  end

end
