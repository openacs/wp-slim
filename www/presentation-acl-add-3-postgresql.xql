<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="grant_privilege">      
      <querytext>
	select acs_permission__grant_permission(:pres_item_id, :user_id_from_search, :privilege);
      </querytext>
</fullquery>
 
</queryset>
