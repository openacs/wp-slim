<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_presentation_data">      
      <querytext>
      
    select p.pres_title,
           p.page_signature,
           p.copyright_notice,
           p.public_p,
           p.show_modified_p, 
           wp_presentation.get_audience_revision(:pres_revision_id) as audience,
           wp_presentation.get_background_revision(:pres_revision_id) as background
    from cr_wp_presentations p, cr_items i
    where i.item_id = :pres_item_id
    and   p.presentation_id = :pres_revision_id

      </querytext>
</fullquery>

 
</queryset>
