<?xml version="1.0"?>
<queryset>

<fullquery name="public_p_change">      
      <querytext>
      
    update cr_wp_presentations
    set public_p = :public_p
    where presentation_id = (select live_revision
                             from cr_items
                             where item_id = :pres_item_id)

      </querytext>
</fullquery>

 
</queryset>
