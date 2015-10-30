#!/usr/bin/ruby
#
# author: Andreas Wilke
#
# Written to send the current Horizon View PCOIP Audio Bandwidth limit setting as fact.
#
Facter.add('horizon_view_pcoip_audio_bandwidth_limit') do
  confine :kernel => :windows

  horizon_view_pcoip_audio_bandwidth_limit = 'unknown'
  begin

    if RUBY_PLATFORM.downcase.include?('mswin') or RUBY_PLATFORM.downcase.include?('mingw32')
      require 'win32/registry'

      Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\Policies\Teradici\PCoIP\pcoip_admin') do |reg|
        reg.each_value do |name,type,data|
		    if name == 'pcoip.audio_bandwidth_limit'
            horizon_view_pcoip_audio_bandwidth_limit = data
          end
        end
      end
    end
  rescue

  end

  setcode do
    horizon_view_pcoip_audio_bandwidth_limit
  end
end
