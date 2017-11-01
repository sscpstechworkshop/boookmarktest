


-- roll off summary
CREATE VIEW rolloff_summary AS
select loc.completename, model.name, count(*) as quantity
  from glpi_computers as cmp
  left join glpi_locations as loc on cmp.locations_id = loc.id
  left join glpi_computermodels as model on cmp.computermodels_id = model.id
  where
    (loc.completename like '%ROLL-OFF%' and loc.name like '%FY%')
    -- cmp.locations_id in (126, 127, 128, 129, 130, 198, 199, 204, 206, 207, 209, 210, 211, 212)
  group by loc.completename, model.name;


-- view to list ipaddresses and computer assigned
CREATE VIEW list_ipaddresses AS
select `ips`.`name` AS `ip_address`
    , `netports`.`mac` AS `mac`
    , `cmp`.`name` AS `comp_name`
    , `cmp`.`contact_num` AS `fqdn`
    , `cmp`.`comment` AS `comment_comp`
  from (((`glpiprod`.`glpi_ipaddresses` `ips` 
          join `glpiprod`.`glpi_computers` `cmp` on((`ips`.`mainitems_id` = `cmp`.`id`))) 
          join `glpiprod`.`glpi_networknames` `netnames` on((`ips`.`items_id` = `netnames`.`id`))) 
          join `glpiprod`.`glpi_networkports` `netports` on((`netnames`.`items_id` = `netports`.`id`))) 
  order by `ips`.`name`,`netports`.`mac`,`cmp`.`name`;
