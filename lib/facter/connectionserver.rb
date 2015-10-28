Facter.add(:connectionserver) do
  confine :kernel => 'windows'
  setcode do
    Facter::Core::Execution.exec('echo %VDM_StartSession_Broker_DNS_Name%')
  end
end
