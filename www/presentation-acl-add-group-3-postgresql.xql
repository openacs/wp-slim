<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="permission_grant">      
      <querytext>
	begin
		perform acs_permission__grant_permission(:pres_item_id, :member_id, :permission);
		return 0;
	end;
      </querytext>
</fullquery>

 
</queryset>
