<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="permission_grant">      
      <querytext>
	begin
		acs_permission.grant_permission(:pres_item_id, :member_id, :permission);
	end;
      </querytext>
</fullquery>
 
</queryset>
