<?xml version="1.0"?>

<queryset>

<fullquery name="get_presentation_data">      
      <querytext>
      
    select p.pres_title, p.page_signature, p.copyright_notice, p.public_p, 
p.show_modified_p
    from cr_wp_presentations p, cr_items i
    where i.item_id = :pres_item_id
    and   i.live_revision = p.presentation_id

      </querytext>
</fullquery>

<fullquery name="get_aud_data">
      <querytext>
    select content as audience
    from cr_revisions, cr_items
    where cr_items.content_type = 'cr_wp_presentation_aud' 
    and cr_items.parent_id = :pres_item_id
    and cr_revisions.revision_id = cr_items.live_revision
      </querytext>
</fullquery>


<fullquery name="get_back_data">
      <querytext>
    select content as background   
    from cr_revisions r, cr_items i
    where i.content_type = 'cr_wp_presentation_back' 
    and i.parent_id = :pres_item_id
    and r.revision_id = i.live_revision 
      </querytext>
</fullquery>

 
</queryset>
