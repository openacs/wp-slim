<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_slide_info">      
      <querytext>
      
    select s.slide_title,
    s.sort_key,
    wp_slide__get_preamble_revision(:slide_revision_id) as preamble,
    wp_slide__get_postamble_revision(:slide_revision_id) as postamble,
    wp_slide__get_bullet_items_revision(:slide_revision_id) as bullet_items,
    to_char(ao.creation_date, 'HH24:MI, Mon DD, YYYY') as modified_date
    from cr_wp_slides s,
         cr_items i,
         acs_objects ao
    where i.item_id    = :slide_item_id
    and   s.slide_id   = :slide_revision_id
    and   ao.object_id = s.slide_id

      </querytext>
</fullquery>

 
</queryset>
