require 'spec_helper'
describe 'pam::service', :type => :define do
  context 'on a RedHat OS' do
    let(:facts) { platforms['el5'][:facts_hash] }
    let(:title) { 'test' }

    context 'with no parameters' do
      it { should contain_class('pam') }

      it {
        should contain_file('pam.d-service-test').with({
          'ensure'  => 'file',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0644',
          'content' => nil,
        })
      }
    end

    context 'when absent' do
      let(:params) { { :ensure => 'absent' } }

      it {
        should contain_file('pam.d-service-test').with({
          'ensure'  => 'absent',
        })
      }
    end

    context 'when given content' do
      let(:params) { { :content => 'session required pam_permit.so' } }

      it { should contain_file('pam.d-service-test').with_content(
        %{session required pam_permit.so}
      ) }
    end

    context 'when given an array of lines' do
      let(:params) do
        {
          :lines  => [
            '@include common-auth',
            '@include common-account',
            'session required pam_permit.so',
            'session required pam_limits.so',
          ],
        }
      end

      content = <<-END.gsub(/^\s+\|/, '')
        |# This file is being maintained by Puppet.
        |# DO NOT EDIT
        |@include common-auth
        |@include common-account
        |session required pam_permit.so
        |session required pam_limits.so
      END

      it { should contain_file('pam.d-service-test').with_content(content) }
    end
  end
end
