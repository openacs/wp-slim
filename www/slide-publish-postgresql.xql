<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="live_revision_set">      
      <querytext>
      select content_item__set_live_revision(:revision_id);

      select id into v_revision_id
      from cr_wp_slides_preamble
      where slide_id = :revision_id;
      content_item__set_live_revision(v_revision_id);

      select id into v_revision_id
      from cr_wp_slides_postamble
      where slide_id = :revision_id;
      content_item__set_live_revision(v_revision_id);

      select id into v_revision_id
      from cr_wp_slides_bullet_items
      where slide_id = :revision_id;
      content_item__set_live_revision(v_revision_id);

      </querytext>
</fullquery>

 
</queryset>
