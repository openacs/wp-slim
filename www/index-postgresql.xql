<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="extra_where_clauses">
      <querytext>

        and ao.creation_date >= (current_timestamp - cast('$show_age days' as interval))

      </querytext>
</fullquery>

<fullquery name="get_all_public_presentations">      
      <querytext>
       
	select i.item_id as pres_item_id,
	pres.pres_title,
	to_char(ao.creation_date, 'Month DD, YYYY') as creation_date,
	ao.creation_user,
	p.first_names || ' ' || p.last_name as full_name
	from cr_items i, cr_wp_presentations pres, persons p, acs_objects ao
	where i.live_revision = pres.presentation_id
	and   ao.object_id = i.item_id
	and   ao.creation_user = p.person_id
	and   pres.public_p = 't'
	and   ao.context_id = :package_id
        $extra_where_clauses
    
      </querytext>
</fullquery>

 
<fullquery name="get_my_presentations">      
      <querytext>
       
	select i.item_id as pres_item_id,
	p.pres_title,
	to_char(ao.creation_date, 'Month DD, YYYY') as creation_date
	from cr_items i, cr_wp_presentations p, acs_objects ao
	where i.live_revision = p.presentation_id
	and   ao.object_id = i.item_id
	and   ao.creation_user = :user_id
	and   ao.context_id = :package_id
        $extra_where_clauses
    
      </querytext>
</fullquery>

 
<fullquery name="get_all_visible_presentations">      
      <querytext>
       
        select i.item_id as pres_item_id,
        pres.pres_title,
        to_char(ao.creation_date, 'Month DD, YYYY') as creation_date,
        ao.creation_user,
        p.first_names || ' ' || p.last_name as full_name,
	acs_permission__permission_p(i.item_id, :user_id, 'wp_edit_presentation') as edit_p
        from cr_items i, cr_wp_presentations pres, persons p, acs_objects ao
        where i.live_revision = pres.presentation_id
        and   ao.object_id = i.item_id
        and   ao.creation_user <> :user_id
        and   ao.creation_user = p.person_id
        and   ao.context_id =  :package_id
        $extra_where_clauses
	and exists (select 1
        from acs_object_party_privilege_map m
        where m.object_id = i.item_id
        and m.party_id = :user_id
        and m.privilege = 'wp_view_presentation')
      </querytext>
</fullquery>
 
</queryset>
