<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_slide_info">      
      <querytext>
      
    select s.slide_title,
    s.sort_key,
    wp_slide.get_preamble(:slide_item_id) as preamble,
    wp_slide.get_postamble(:slide_item_id) as postamble,
    wp_slide.get_bullet_items(:slide_item_id) as bullet_items,
    ao.creation_date as modified_date
    from cr_wp_slides s, cr_items i, acs_objects ao
    where i.item_id = :slide_item_id
    and   i.live_revision = s.slide_id
    and   ao.object_id = s.slide_id

      </querytext>
</fullquery>

<fullquery name="get_attachments">      
      <querytext>
          select i.live_revision as attach_id, a.display, i.name as file_name
          from cr_items i, cr_wp_image_attachments a
          where i.parent_id = :slide_item_id and
              i.content_type in ('cr_wp_image_attachment', 'cr_wp_file_attachment') and
              i.live_revision = a.attach_id(+)
      </querytext>
</fullquery>
 
</queryset>
