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
      from cr_wp_presentations_aud
      where presentation_id = :revision_id;
      content_item.set_live_revision(v_revision_id);

      select id into v_revision_id
      from cr_wp_presentations_back
      where presentation_id = :revision_id;
      content_item.set_live_revision(v_revision_id);
    end;

      </querytext>
</fullquery>

 
</queryset>
