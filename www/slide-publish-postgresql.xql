<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="live_revision_set">      
      <querytext>
      select content_item__set_live_revision(:revision_id);

      select content_item__set_live_revision(preamble.id)
      from cr_wp_slides_preamble preamble
      where preamble.slide_id = :revision_id;

      select content_item__set_live_revision(postamble.id)
      from cr_wp_slides_postamble postamble
      where postamble.slide_id = :revision_id;

      select content_item__set_live_revision(bullets.id)
      from cr_wp_slides_bullet_items bullets
      where bullets.slide_id = :revision_id;

      </querytext>
</fullquery>

 
</queryset>
