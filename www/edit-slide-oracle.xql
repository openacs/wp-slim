<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_slide_info">      
      <querytext>
      
select s.slide_title,
       s.sort_key,
       s.original_slide_id,
       wp_slide.get_preamble(:slide_item_id) as preamble,
       wp_slide.get_postamble(:slide_item_id) as postamble,
       wp_slide.get_bullet_items(:slide_item_id) as bullet_items
from cr_wp_slides s, cr_items i
where i.item_id = :slide_item_id
and   i.live_revision = s.slide_id

      </querytext>
</fullquery>

 
</queryset>