<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_slide_info">      
      <querytext>
    select s.slide_title as title ,
     	i.item_id as slide_id , 
	s.sort_key,wp_slide.get_preamble(i.item_id) as preamble,
    	wp_slide.get_postamble(i.item_id) as postamble,
    	wp_slide.get_bullet_items(i.item_id) as bullet_list
    from cr_wp_slides s, cr_items i
    where i.parent_id = :pres_item_id
   	and   i.live_revision = s.slide_id
    order by s.sort_key
      </querytext>
</fullquery>

 
</queryset>
