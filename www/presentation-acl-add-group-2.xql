<?xml version="1.0"?>
<queryset>

<fullquery name="users_get">      
      <querytext>
      
    select p.first_names,
           p.last_name
    from persons p,
         group_member_map m
    where m.group_id = :group_id
    and   m.member_id = p.person_id
    order by p.last_name

      </querytext>
</fullquery>

 
</queryset>
