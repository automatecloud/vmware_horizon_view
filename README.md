# vmware_horizon_view

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with vmware_horizon_view](#setup)
    * [What vmware_horizon_view affects](#what-vmware_horizon_view-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with vmware_horizon_view](#beginning-with-vmware_horizon_view)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module manage the PCOIP settings within a VMware Horizon with View environment for internal and external connections. It is also known as the secret weapon.

## Module Description

This module allows to configure different PCOIP settings for internal and externe VMware Horizon with View connections. The following settings can be changed:
* Enable or Disable the ThinPrint Services (TPAutoConnSvc and TPVCGateway)
* Enable or Disable the PCOIP Build to Lossless configuration
* Configure the PCoIP minimum image quality
* Configure the PCoIP maximum initial image quality
* Configure the PCoIP maximum frame rate
* Configure the PCoIP use image setting
* Configure the PCoIP clipboard state
* Configure the PCoIP audio bandwidth limit
* Configure the Exclude all USB Devices setting.

It also automates the configuration necessary to enable the puppet run during each internal and external connection.

## Setup

### What vmware_horizon_view affects

For more details please check the Blog https://blogs.vmware.com/consulting/2015/10/vmware-horizon-view-secret-weapon.html

### Setup Requirements **OPTIONAL**

It will configure the following:
* Automates the Script creation at C:\Program Files\VMware\VMware View\Agent\scripts\runpuppetagent.vbs that will trigger a puppet agent -t run.
* Automates the necessary Registy keys:
**  HKLM\SOFTWARE\VMware, Inc.\VMware VDM\ScriptEvents\StartSession
**  HKLM\SOFTWARE\VMware, Inc.\VMware VDM\ScriptEvents\StartSession\Bullet1 and value "wscript C:\Program Files\VMware\VMware View\Agent\scripts\runpuppetagent.vbs" (string)
**  HKLM\SOFTWARE\VMware, Inc.\VMware VDM\Agent\Configuration\RunScriptsOnStartSession and value 1 (dword)
**  HKLM\SOFTWARE\VMware, Inc.\VMware VDM\ScriptEvents\TimeoutsInMinutes and value 0 (dword)
* enabling the Windows Script Host Service (WSSH)

### Beginning with vmware_horizon_view

You can use the init.pp module inside your VMware Horizon with View template to configure the setup requirements. It will configure the described configurations independent from the parameter configurations.

## Usage

First you need to specify the external broker DNS name parameter (external_broker_dns_name) and internal broker DNS name parameter (internal_broker_dns_name)

Beside that you can specify the following internal settings. If not specified the default values will be used.

You can specify the following settings for external connections:
* Enable (true) or disable (false) the ThinPrint Services: external_stop_tpservices (default = true)
* Enable (true) or disable (false) PCoIP  Build to Lossless: external_enable_build_to_lossless (default = true)
* Configuration of the PCoIP minimum image quality: external_minimum_image_quality (default = 30)
* Configuration of the PCoIP maximum initial image quality: external_maximum_initial_image_quality (default = 70)
* Configuration of the PCoIP maximum frame rate: external_maximum_frame_rate (default = 12)
* Configuration of the Use image setting enabled (true) or disabled (false): external_use_image_setting (default = true)
* Configuration of the PCoIP clipboard state: external_enable_server_clipboard_state (default = false)
* Configuration of the PCoIP audio bandwidth limit: external_set_audio_bandwidth_limit (default = 80)
* Configuration of to enable or disable exclude all usb devices: external_exclude_all_usb_devices (default = true),

You can specify the following settings for internal connections:
* Enable (true) or disable (false) the ThinPrint Services: internal_stop_tpservices (default = false)
* Enable (true) or disable (false) PCoIP  Build to Lossless: internal_enable_build_to_lossless (default = false)
* Configuration of the PCoIP minimum image quality: internal_minimum_image_quality (default = 40)
* Configuration of the PCoIP maximum initial image quality: internal_maximum_initial_image_quality (default = 80)
* Configuration of the PCoIP maximum frame rate: internal_maximum_frame_rate (default = 20)
* Configuration of the Use image setting enabled (true) or disabled (false): internal_use_image_setting (default = true)
* Configuration of the PCoIP clipboard state: internal_enable_server_clipboard_state (default = true)
* Configuration of the PCoIP audio bandwidth limit: internal_set_audio_bandwidth_limit (default = 250)
* Configuration of to enable or disable exclude all usb devices: internal_exclude_all_usb_devices (default = false)

The module also creates some custom facts for reporting:
* horizon_view_pcoip_audio_bandwidth_limit: Information about the PCoIP audio bandwidth limit configuration before the puppet agent run.
* horizon_view_pcoip_enable_build_to_lossless: Information about the PCoIP enable build to lossless configuration before the puppet agent run.
* horizon_view_pcoip_maximum_frame_rate: Information about the PCoIP maximum frame rate configuration before the puppet agent run.
* horizon_view_pcoip_maximum_initial_image_quality: Information about the PCoIP maximum initial image quality configuration before the puppet agent run.
* horizon_view_pcoip_minimum_image_quality: Information about the PCoIP minimum image quality configuration before the puppet agent run.
* horizon_view_pcoip_server_clipboard_state: Information about the PCoIP server clipboard state configuration before the puppet agent run.
* horizon_view_pcoip_use_client_img_setting: Information about the PCoIP client img setting before the puppet agent run.
* vdmstartsessionbrokerdnsname: Information about the vdmstartsessionbrokerdnsname before the puppet agent run.
* viewclient_broker_dns_name: Information about the View Client broker DNS name of all VDM Brokers available within your

## Limitations

- Only works right now with one external and one internal VMware Horizon with View Desktop broker but can be extended to an array of possible broker names in future.

## Development

For your ideas to extend the module please let me know your requests by creating issues at the github repository: https://github.com/Andulla/vmware_horizon_view/issues

## Release Notes/Contributors/Etc **Optional**

Version 0.0.1: Initial Release of the module
