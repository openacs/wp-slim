<?xml version="1.0"?>
<queryset>

<fullquery name="get_presentation_page_signature">      
      <querytext>
      
    select p.page_signature,
    p.show_modified_p
    from cr_wp_presentations p, cr_items i
    where i.item_id = :pres_item_id
    and   i.live_revision = p.presentation_id

      </querytext>
</fullquery>

 
</queryset>
