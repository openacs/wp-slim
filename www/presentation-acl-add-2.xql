<?xml version="1.0"?>
<queryset>

<fullquery name="privilege_check">      
      <querytext>
      
    select 1
    from acs_permissions
    where object_id = :pres_item_id
    and   grantee_id = :user_id_from_search
    and   privilege = :privilege

      </querytext>
</fullquery>

 
</queryset>
