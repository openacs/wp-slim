<?xml version="1.0"?>

<queryset>

<fullquery name="get_presentation_data">      
      <querytext>
    select p.pres_title,
           p.page_signature,
           p.public_p,
           p.show_modified_p ,
	   p.copyright_notice
    from cr_wp_presentations p, cr_items i
    where i.item_id = :pres_item_id
    and   p.presentation_id = :pres_revision_id
      </querytext>
</fullquery>

<fullquery name="get_audience_data">
      <querytext>
    select content as audience
    from cr_revisions r, cr_wp_presentations_aud pa
    where pa.presentation_id = :pres_revision_id
    and r.revision_id = pa.id
      </querytext>
</fullquery>

<fullquery name="get_background_data">
      <querytext>
    select content as background
    from cr_revisions r, cr_wp_presentations_back pb
    where pb.presentation_id = :pres_revision_id
    and r.revision_id = pb.id
      </querytext>
</fullquery>

</queryset>
