<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="revoke_privilege">      
      <querytext>
      
    declare
      owner_id  acs_objects.creation_user%TYPE;
    begin
      select creation_user into owner_id
      from acs_objects
      where object_id = :pres_item_id;
 
      if (owner_id <> :user_id) then
        acs_permission.revoke_permission(:pres_item_id, :user_id, :privilege);
      end if;
    end;

      </querytext>
</fullquery>

 
</queryset>
