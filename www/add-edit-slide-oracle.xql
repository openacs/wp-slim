<?xml version="1.0"?>
<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>
   
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
            begin
	    	:1 := wp_slide.new(
      		pres_item_id      => :pres_item_id,
      		creation_user     => :user_id,
      		creation_ip       => :creation_ip,
      		creation_date     => sysdate,
      		slide_title       => :slide_title,
      		original_slide_id => -100,
      		sort_key          => :sort_key,
      		preamble          => :preamble,
      		postamble         => :postamble,
      		bullet_items      => :bullet_list,
		package_id        => :package_id
      		);
    	    end;             
        </querytext>
    </fullquery>

    <fullquery name="update_slide">      
        <querytext>
	    begin
  	    	wp_slide.new_revision (
  	   	creation_user     => :user_id,
  	    	creation_ip       => :creation_ip,
  	    	creation_date     => sysdate,
  	    	slide_item_id     => :slide_item_id,
  	    	slide_title       => :slide_title,
  	    	preamble          => :preamble,
  	    	postamble         => :postamble,
  	    	bullet_items      => :bullet_items,
  	    	original_slide_id => :original_slide_id,
  	    	sort_key          => :sort_key
       	    	);
    	    end;
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
