<?xml version="1.0"?>
<queryset>

<fullquery name="get_wp_users">      
      <querytext>
      
    select p.person_id, p.first_names, p.last_name, parties.email, count(i.item_id) as num_presentations
    from persons p, cr_items i, acs_objects o, parties
    where i.content_type = 'cr_wp_presentation'
    and   o.object_id = i.item_id
    and   p.person_id = o.creation_user
    and   parties.party_id = p.person_id
    group by p.person_id, p.first_names, p.last_name, parties.email

      </querytext>
</fullquery>

 
</queryset>
