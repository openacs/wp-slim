<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="revoke_privilege">      
      <querytext>
      declare  
       owner_id  integer;

begin
      select creation_user into owner_id
      from acs_objects
      where object_id = :pres_item_id;
 
      if (owner_id != :user_id) then
         PERFORM acs_permission__revoke_permission(:pres_item_id, :user_id, :privilege);
      end if;

      return 0;
end;
      </querytext>
</fullquery>

 
</queryset>
 