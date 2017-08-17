#Get-ADGroupMember -Identity "HF_Employees_FREGLEY" | Select-Object -ExpandProperty SamAccountName
Foreach ($member in Get-ADGroupMember -Identity "HF_Employees_GREG" | Select-Object -ExpandProperty SamAccountName ) {
  $output = "GREG," + $member 
  Write-Host $output
  $output >> profile_server.txt
}
