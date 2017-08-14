


-- roll off summary
select loc.completename, model.name, count(*) as quantity
  from glpi_computers as cmp
  left join glpi_locations as loc on cmp.locations_id = loc.id
  left join glpi_computermodels as model on cmp.computermodels_id = model.id
  where
    (loc.completename like '%ROLL-OFF%' and loc.name like '%FY%')
    -- cmp.locations_id in (126, 127, 128, 129, 130, 198, 199, 204, 206, 207, 209, 210, 211, 212)
  group by loc.completename, model.name
