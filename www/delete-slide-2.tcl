# /packages/wp/www/delete-slide-2.tcl

ad_page_contract {
     
    This page deletes a slide.

    @author Haolan Qin (hqin@arsdigita.com)
    @creation-date 01/22/2001
    @cvs-id $Id$
} {
    slide_item_id:naturalnum,notnull
    pres_item_id:naturalnum,notnull
}

#added permission checking  roc@
set user_id [ad_conn user_id]
permission::require_permission -party_id $user_id -object_id $pres_item_id -privilege wp_delete_presentation


db_exec_plsql delete_slide {
    begin
      wp_slide.del(:slide_item_id);
    end;
}

ad_returnredirect presentation-top?[export_url_vars pres_item_id]
