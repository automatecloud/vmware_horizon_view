#!/usr/bin/ruby
#
# author: Andreas Wilke
#
# Written to send the current View Client Broker DNS name to the master.
#
Facter.add('viewclient_broker_dns_name') do
  confine :kernel => :windows

  viewclient_broker_dns_name = 'unknown'
  begin

    if RUBY_PLATFORM.downcase.include?('mswin') or RUBY_PLATFORM.downcase.include?('mingw32')
      require 'win32/registry'

      Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\VMware, Inc.\VMware VDM\Agent\Configuration') do |reg|
        reg.each_value do |name,type,data|
		    if name =~ /Broker/
            viewclient_broker_dns_name = data
          end
        end
      end
    end
  rescue

  end

  setcode do
    viewclient_broker_dns_name
  end
end
