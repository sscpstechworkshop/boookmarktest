$gcos = "2029", "2030", "2031", "2032"
Foreach ($gco in $gcos) {
  #$gco = "2029"
  $gco_name = "gco-fy" + $gco
  $gco_desc = "Graduating Class of FY" + $gco
  $gco_email = "gco-fy" + $gco + "@student.sscps.org"
  Write-Host "creating group:  "$gco_name
  New-ADGroup -name $gco_name -GroupScope "Global" -GroupCategory "Security" -Description $gco_desc -Path "OU=Groups (GCDS),OU=Prod,OU=SSCPS,DC=ad,DC=sscps,DC=org" -Confirm:$FALSE
  Set-ADGroup $gco_name -Replace @{mail=$gco_email}
}
