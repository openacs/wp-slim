<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="live_revision_set">      
      <querytext>
      
    declare
      v_revision_id  cr_revisions.revision_id%TYPE;
    begin
      content_item.set_live_revision(:revision_id);

      select id into v_revision_id
      from cr_wp_presentations_audience
      where presentation_id = :revision_id;
      content_item.set_live_revision(v_revision_id);

      select id into v_revision_id
      from cr_wp_presentations_background
      where presentation_id = :revision_id;
      content_item.set_live_revision(v_revision_id);
    end;

      </querytext>
</fullquery>

 
</queryset>
