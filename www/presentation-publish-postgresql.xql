<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="live_revision_set">      
      <querytext>
declare
 v_revision_id integer;

      select content_item.set_live_revision(:revision_id);

      select id into v_revision_id
      from cr_wp_presentations_aud
      where presentation_id = :revision_id;
      
      select content_item.set_live_revision(:v_revision_id);

      select id into v_revision_id
      from cr_wp_presentations_back
      where presentation_id = :revision_id;

      select content_item.set_live_revision(:v_revision_id);

      </querytext>
</fullquery>

 
</queryset>
