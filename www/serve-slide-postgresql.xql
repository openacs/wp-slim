<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_slide_info">      
      <querytext>

    select s.slide_title,
    s.sort_key,
    wp_slide__get_preamble(:slide_item_id) as preamble,
    wp_slide__get_postamble(:slide_item_id) as postamble,
    wp_slide__get_bullet_items(:slide_item_id) as bullet_items,
    ao.creation_date as modified_date
    from cr_wp_slides s, cr_items i, acs_objects ao
    where i.item_id = :slide_item_id
    and   i.live_revision = s.slide_id
    and   ao.object_id = s.slide_id

      </querytext>
</fullquery>

<fullquery name="get_attachments">      
      <querytext>
          select live_revision as attach_id, display, name as file_name
          from (select live_revision, name
                from cr_items
                where parent_id = :slide_item_id and
                   content_type in ('cr_wp_image_attachment', 'cr_wp_file_attachment')) a
              left join cr_wp_image_attachments on (a.live_revision = attach_id)
      </querytext>
</fullquery>
</queryset>
