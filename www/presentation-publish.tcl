# /packages/wp/www/presentation-publish.tcl

ad_page_contract {

    # This file sets live a revision of a presentation

     @author Haolan Qin (hqin@arsdigita.com)
     @creation-date 01/19/2001
     @cvs-id $Id$
} {
    revision_id:naturalnum,notnull
    return_url:notnull
}

db_exec_plsql live_revision_set {
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
}

ad_returnredirect $return_url
