require 'spec_helper'

describe 'couchdb' do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :couchdb_bind_address => '0.0.0.0',
          :couchdb_port         => 5984,
          :couchdb_admin_password => '',
          :couchdb_require_valid_user => false,
          :couchdb_authentication_realm => '',
        })
      end

      it { should compile.with_all_deps }
    end
  end
end
