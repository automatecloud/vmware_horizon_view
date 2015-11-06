# == Class: vmware_horizon_view
#
# Manage the VMware Horizon View PCoIP settings for internal and external connections

class vmware_horizon_view (
    $external_broker_dns_name = "myexternalbroker.test.com",
    $internal_broker_dns_name = "myinternalbroker.test.com",
    $external_stop_tpservices = true,
    $internal_stop_tpservices = false,
    $external_enable_build_to_lossless = true,
    $internal_enable_build_to_lossless = false,
    $external_minimum_image_quality = 30,
    $internal_minimum_image_quality = 40,
    $external_maximum_initial_image_quality = 70,
    $internal_maximum_initial_image_quality = 80,
    $external_maximum_frame_rate = 12,
    $internal_maximum_frame_rate = 20,
    $external_use_image_setting = true,
    $internal_use_image_setting = true,
    $external_enable_server_clipboard_state = false,
    $internal_enable_server_clipboard_state = true,
    $external_set_audio_bandwidth_limit = 80,
    $internal_set_audio_bandwidth_limit = 250,
    $external_exclude_all_usb_devices = true,
    $internal_exclude_all_usb_devices = false,
  ) {

    $script = 'C:\Program Files\VMware\VMware View\Agent\scripts\runpuppetagent.vbs'
    # Configure Script to trigger the Puppet Agent
    file { 'C:\Program Files\VMware\VMware View\Agent\scripts\runpuppetagent.vbs':
      content => template('vmware_horizon_view/runpuppetagent.vbs.erb'),
    }

    # Configure Registry Key to use the Script
    registry_key { 'HKLM\SOFTWARE\VMware, Inc.\VMware VDM\ScriptEvents\StartSession':
        ensure => present,
      }


    registry_value { 'HKLM\SOFTWARE\VMware, Inc.\VMware VDM\ScriptEvents\StartSession\Bullet1':
        ensure => present,
        type   => string,
        data   => "wscript \"${script}\"",
        require => Registry_key['HKLM\SOFTWARE\VMware, Inc.\VMware VDM\ScriptEvents\StartSession'],
    }

    registry_value { 'HKLM\SOFTWARE\VMware, Inc.\VMware VDM\Agent\Configuration\RunScriptsOnStartSession':
          ensure => present,
          type   => dword,
          data   => '1',
    }

    # Check if user is connecting from external vdm broker.
    if $vdmstartsessionbrokerdnsname == $external_broker_dns_name {
      notify { 'User is connecting from external VDM Broker': }
      if $external_stop_tpservices {
        service {'TPAutoConnSvc':
          ensure => 'stopped',
          enable => false,
        }
        service {'TPVCGateway':
          ensure => 'stopped',
          enable => false,
        }
      }
      else {
        service {'TPAutoConnSvc':
          ensure => 'running',
          enable => true,
        }
        service {'TPVCGateway':
          ensure => 'running',
          enable => true,
        }
      }
      if $external_enable_build_to_lossless {
        registry_value { 'HKLM\SOFTWARE\Policies\Teradici\PCoIP\pcoip_admin\pcoip.enable_build_to_lossless':
            ensure => present,
            type   => dword,
            data   => 1,
          }
      }
      else {
        registry_value { 'HKLM\SOFTWARE\Policies\Teradici\PCoIP\pcoip_admin\pcoip.enable_build_to_lossless':
            ensure => present,
            type   => dword,
            data   => 0,
          }
      }
      registry_value { 'HKLM\SOFTWARE\Policies\Teradici\PCoIP\pcoip_admin\pcoip.minimum_image_quality':
          ensure => present,
          type   => dword,
          data   => $external_minimum_image_quality,
      }
      registry_value { 'HKLM\SOFTWARE\Policies\Teradici\PCoIP\pcoip_admin\pcoip.maximum_initial_image_quality':
          ensure => present,
          type   => dword,
          data   => $external_maximum_initial_image_quality,
      }
      registry_value { 'HKLM\SOFTWARE\Policies\Teradici\PCoIP\pcoip_admin\pcoip.maximum_frame_rate':
          ensure => present,
          type   => dword,
          data   => $external_maximum_frame_rate ,
      }
      if $external_use_image_setting {
        registry_value { 'HKLM\SOFTWARE\Policies\Teradici\PCoIP\pcoip_admin\pcoip.use_client_img_settings':
            ensure => present,
            type   => dword,
            data   => 1,
          }
      }
      else {
        registry_value { 'HKLM\SOFTWARE\Policies\Teradici\PCoIP\pcoip_admin\pcoip.use_client_img_settings':
            ensure => present,
            type   => dword,
            data   => 0,
          }
      }
      if $external_enable_server_clipboard_state {
        registry_value { 'HKLM\SOFTWARE\Policies\Teradici\PCoIP\pcoip_admin\pcoip.server_clipboard_state':
            ensure => present,
            type   => dword,
            data   => 1,
          }
      }
      else {
        registry_value { 'HKLM\SOFTWARE\Policies\Teradici\PCoIP\pcoip_admin\pcoip.server_clipboard_state':
            ensure => present,
            type   => dword,
            data   => 0,
          }
      }
      registry_value { 'HKLM\SOFTWARE\Policies\Teradici\PCoIP\pcoip_admin\pcoip.audio_bandwidth_limit':
          ensure => present,
          type   => dword,
          data   => $external_set_audio_bandwidth_limit ,
      }
      if $external_exclude_all_usb_devices {
        registry_value { 'HKLM\SOFTWARE\Policies\VMware, Inc.\VMware VDM\Agent\USB\ExcludeAllDevices':
            ensure => present,
            type   => string,
            data   => 'true',
          }
      }
      else {
        registry_value { 'HKLM\SOFTWARE\Policies\VMware, Inc.\VMware VDM\Agent\USB\ExcludeAllDevices':
            ensure => present,
            type   => string,
            data   => 'false',
          }
      }
    }
    # Check if user is connecting from internal vdm broker.
    elsif $vdmstartsessionbrokerdnsname == $internal_broker_dns_name {
      notify { 'User is connecting from internal VDM Broker': }
      if $internal_stop_tpservices == true {
        service {'TPAutoConnSvc':
          ensure => 'stopped',
          enable => false,
        }
        service {'TPVCGateway':
          ensure => 'stopped',
          enable => false,
        }
      }
      else {
        service {'TPAutoConnSvc':
          ensure => 'running',
          enable => true,
        }
        service {'TPVCGateway':
          ensure => 'running',
          enable => true,
        }
      }
      if $internal_enable_build_to_lossless {
        registry_value { 'HKLM\SOFTWARE\Policies\Teradici\PCoIP\pcoip_admin\pcoip.enable_build_to_lossless':
            ensure => present,
            type   => dword,
            data   => 1,
          }
      }
      else {
        registry_value { 'HKLM\SOFTWARE\Policies\Teradici\PCoIP\pcoip_admin\pcoip.enable_build_to_lossless':
            ensure => present,
            type   => dword,
            data   => 0,
          }
      }
      registry_value { 'HKLM\SOFTWARE\Policies\Teradici\PCoIP\pcoip_admin\pcoip.minimum_image_quality':
          ensure => present,
          type   => dword,
          data   => $internal_minimum_image_quality,
      }
      registry_value { 'HKLM\SOFTWARE\Policies\Teradici\PCoIP\pcoip_admin\pcoip.maximum_initial_image_quality':
          ensure => present,
          type   => dword,
          data   => $internal_maximum_initial_image_quality,
      }
      registry_value { 'HKLM\SOFTWARE\Policies\Teradici\PCoIP\pcoip_admin\pcoip.maximum_frame_rate':
          ensure => present,
          type   => dword,
          data   => $internal_maximum_frame_rate ,
      }
      if $internal_use_image_setting {
        registry_value { 'HKLM\SOFTWARE\Policies\Teradici\PCoIP\pcoip_admin\pcoip.use_client_img_settings':
            ensure => present,
            type   => dword,
            data   => 1,
          }
      }
      else {
        registry_value { 'HKLM\SOFTWARE\Policies\Teradici\PCoIP\pcoip_admin\pcoip.use_client_img_settings':
            ensure => present,
            type   => dword,
            data   => 0,
          }
      }
      if $internal_enable_server_clipboard_state {
        registry_value { 'HKLM\SOFTWARE\Policies\Teradici\PCoIP\pcoip_admin\pcoip.server_clipboard_state':
            ensure => present,
            type   => dword,
            data   => 1,
          }
      }
      else {
        registry_value { 'HKLM\SOFTWARE\Policies\Teradici\PCoIP\pcoip_admin\pcoip.server_clipboard_state':
            ensure => present,
            type   => dword,
            data   => 0,
          }
      }
      registry_value { 'HKLM\SOFTWARE\Policies\Teradici\PCoIP\pcoip_admin\pcoip.audio_bandwidth_limit':
          ensure => present,
          type   => dword,
          data   => $internal_set_audio_bandwidth_limit ,
      }
      if $internal_exclude_all_usb_devices {
        registry_value { 'HKLM\SOFTWARE\Policies\VMware, Inc.\VMware VDM\Agent\USB\ExcludeAllDevices':
            ensure => present,
            type   => string,
            data   => 'true',
          }
      }
      else {
        registry_value { 'HKLM\SOFTWARE\Policies\VMware, Inc.\VMware VDM\Agent\USB\ExcludeAllDevices':
            ensure => present,
            type   => string,
            data   => 'false',
          }
      }
    }
    else {
      notify { 'No connection general puppet run.': }
      # user is not connecting. General puppet run.
    }
}
