<?xml version="1.0"?>
<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="get_presentation">      
        <querytext>
	    select pres_title
	    from cr_wp_presentations p, cr_items i
	    where i.item_id = :pres_item_id
	    and i.live_revision = p.presentation_id
        </querytext>
    </fullquery>

    <fullquery name="get_sort_key">      
        <querytext>
            select 1+max(sort_key) 
	    from cr_wp_slides s,  cr_items i,  cr_revisions r
	    where i.parent_id = :pres_item_id 
	    and s.slide_id = i.live_revision
        </querytext>
    </fullquery>

    <fullquery name="get_bullets_stored">      
        <querytext>
            select wp_slide__get_bullet_items(:slide_item_id) as bullets_stored
            from cr_wp_slides s, cr_items i
            where i.item_id = :slide_item_id
            and i.live_revision = s.slide_id
        </querytext>
    </fullquery>
    
    <fullquery name="wp_slide_insert">      
        <querytext>
             select wp_slide__new(
    	         :pres_item_id,
	         now(),
	         :user_id,
      	         :creation_ip,
 	         :slide_title,
	         '-1',      	
	         '-100',
      	         :sort_key,
      	         :preamble,
	         :bullet_list,
	         :postamble,
	         't',
	         'f',
	         NULL,
		 :package_id
             );
        </querytext>
    </fullquery>
   
    <fullquery name="update_slide">      
        <querytext>
            select wp_slide__new_revision (
	    	now(),
	    	:user_id,
	    	:creation_ip,
	    	:slide_item_id,
	    	:slide_title,
      	    	:preamble,
	    	:bullet_items,
	    	:postamble,
	    	'-1',
	    	:osi,
	    	:sort_key,
	    	't',
	    	'f'
            );
        </querytext>
    </fullquery>

    <fullquery name="get_slide_info">      
        <querytext>
            select s.slide_title,
                s.sort_key,
                s.original_slide_id,
                wp_slide__get_preamble(:slide_item_id) as preamble,
                wp_slide__get_postamble(:slide_item_id) as postamble,
                wp_slide__get_bullet_items(:slide_item_id) as bullet_items
            from cr_wp_slides s, cr_items i
            where i.item_id = :slide_item_id
            and i.live_revision = s.slide_id
        </querytext>
    </fullquery>

    <fullquery name="get_slide_sort_key">      
        <querytext>
            select s.sort_key
            from cr_wp_slides s, cr_items i
            where i.item_id = :slide_item_id
            and i.live_revision = s.slide_id
        </querytext>
    </fullquery>

</queryset>
