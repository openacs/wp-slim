<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="group_add">      
      <querytext>
      
    declare
        cursor v_cursor is
        select member_id
        from group_member_map
        where group_id = :group_id;
    begin
        if :role = 'read' then
            for c in v_cursor loop
                acs_permission.grant_permission(:pres_item_id, c.member_id, 'wp_view_presentation');
            end loop;
        elsif (:role = 'write') then
            for c in v_cursor loop
                acs_permission.grant_permission(:pres_item_id, c.member_id, 'wp_view_presentation');
                acs_permission.grant_permission(:pres_item_id, c.member_id, 'wp_edit_presentation');
            end loop;
        else
            for c in v_cursor loop
                acs_permission.grant_permission(:pres_item_id, c.member_id, 'wp_view_presentation');
                acs_permission.grant_permission(:pres_item_id, c.member_id, 'wp_edit_presentation');
                acs_permission.grant_permission(:pres_item_id, c.member_id, 'wp_admin_presentation');
            end loop;
        end if;
    end;

      </querytext>
</fullquery>

 
</queryset>
