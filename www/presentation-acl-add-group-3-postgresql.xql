<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="group_add">      
      <querytext>


	select
          if :role = ''read'' then
            for record in select member_id
              from group_member_map
              where group_id = :group_id;
            loop
                 acs_permission__grant_permission(:pres_item_id, c.member_id,''wp_view_presentation'');
            end loop;
        else if (:role = ''write'') then
            for record in select member_id
              from group_member_map
              where group_id = :group_id;
              loop
                  acs_permission__grant_permission(:pres_item_id, c.member_id,  ''wp_view_presentation'');
                  acs_permission__grant_permission(:pres_item_id, c.member_id,
''wp_edit_presentation'');
            end loop;
        else
            for record in select member_id
              from group_member_map
              where group_id = :group_id;
             loop
          acs_permission__grant_permission(:pres_item_id, c.member_id,
''wp_view_presentation'');
          acs_permission__grant_permission(:pres_item_id, c.member_id,
''wp_edit_presentation'');
          acs_permission__grant_permission(:pres_item_id, c.member_id,
''wp_admin_presentation'');
            end loop;
        end if;

 
      </querytext>
</fullquery>

 
</queryset>
