<?xml version="1.0"?>
<queryset>

<fullquery name="get_slides">      
      <querytext>
      
select s.sort_key, s.slide_title, i.item_id as slide_item_id
from cr_wp_slides s,
     cr_items i
where i.parent_id = :pres_item_id
and   i.live_revision = s.slide_id
order by s.sort_key

      </querytext>
</fullquery>

 
</queryset>
