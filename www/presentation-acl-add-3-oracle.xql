<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="grant_privilege">      
      <querytext>
      
	    begin
	        acs_permission.grant_permission(:pres_item_id, :user_id_from_search, :privilege);
	    end;
	
      </querytext>
</fullquery>
</queryset>
