Facter.add(:powerstates) do
  confine :kernel => 'windows'
  setcode do
    Facter::Core::Execution.exec('echo %windir%')
  end
end
