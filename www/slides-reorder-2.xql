<?xml version="1.0"?>
<queryset>

<fullquery name="wp_slide_order_update">      
      <querytext>
      
	update cr_wp_slides
        set    sort_key = :counter
        where  exists (select 1 from cr_revisions where cr_wp_slides.slide_id = cr_revisions.revision_id and cr_revisions.item_id = :id)
    
      </querytext>
</fullquery>

 
</queryset>
