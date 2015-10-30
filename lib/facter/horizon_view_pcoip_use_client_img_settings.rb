#!/usr/bin/ruby
#
# author: Andreas Wilke
#
# Written to send the current Horizon View PCOIP use client img settings as fact.
#
Facter.add('horizon_view_pcoip_use_client_img_settings') do
  confine :kernel => :windows

  horizon_view_pcoip_use_client_img_settings = 'unknown'
  begin

    if RUBY_PLATFORM.downcase.include?('mswin') or RUBY_PLATFORM.downcase.include?('mingw32')
      require 'win32/registry'

      Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\Policies\Teradici\PCoIP\pcoip_admin') do |reg|
        reg.each_value do |name,type,data|
		    if name == 'pcoip.use_client_img_settings'
            horizon_view_pcoip_use_client_img_settings = data
          end
        end
      end
    end
  rescue

  end

  setcode do
    horizon_view_pcoip_use_client_img_settings
  end
end
