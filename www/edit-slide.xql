<?xml version="1.0"?>
<queryset>

<fullquery name="get_presentation">      
      <querytext>
      
select pres_title
from cr_wp_presentations p,
     cr_items i
where i.item_id = :pres_item_id
and   i.live_revision = p.presentation_id

      </querytext>
</fullquery>

</queryset>
