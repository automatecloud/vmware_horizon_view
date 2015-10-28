require 'spec_helper'
describe 'vmware_horizon_view' do

  context 'with defaults for all parameters' do
    it { should contain_class('vmware_horizon_view') }
  end
end
