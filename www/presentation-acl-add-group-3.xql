<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="group_grant">      
      <querytext>
	select member_id
        from group_member_map
        where group_id = :group_id
      </querytext>
</fullquery>
 
</queryset>
