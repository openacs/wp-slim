# /packages/wp/www/slide-publish.tcl

ad_page_contract {

    # This file sets live a revision of a slide

     @author Haolan Qin (hqin@arsdigita.com)
     @creation-date 01/19/2001
     @cvs-id $Id$
} {
    revision_id:naturalnum,notnull
    return_url:notnull
    pres_item_id:notnull
}

#added permission checking  roc@
set user_id [ad_conn user_id]
permission::require_permission -party_id $user_id -object_id $pres_item_id -privilege wp_edit_presentation

db_exec_plsql live_revision_set {
    declare
      v_revision_id  cr_revisions.revision_id%TYPE;
    begin
      content_item.set_live_revision(:revision_id);

      select id into v_revision_id
      from cr_wp_slides_preamble
      where slide_id = :revision_id;
      content_item.set_live_revision(v_revision_id);

      select id into v_revision_id
      from cr_wp_slides_postamble
      where slide_id = :revision_id;
      content_item.set_live_revision(v_revision_id);

      select id into v_revision_id
      from cr_wp_slides_bullet_items
      where slide_id = :revision_id;
      content_item.set_live_revision(v_revision_id);
    end;
}

ad_returnredirect $return_url
