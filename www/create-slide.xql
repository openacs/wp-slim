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

 
<fullquery name="get_sort_key">      
      <querytext>
      
	select 1+max(sort_key)
        from cr_wp_slides s,
	     cr_items i,
             cr_revisions r
	where i.parent_id = :pres_item_id
	and   s.slide_id = i.live_revision
    
      </querytext>
</fullquery>

 
</queryset>
