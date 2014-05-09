require 'spec_helper'

describe 'couchdb' do
  let(:facts) {{
    :lsbdistcodename => 'wheezy',
    :osfamily        => 'Debian',
  }}
  it { should compile.with_all_deps }
end
