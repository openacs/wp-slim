# /packages/wp/www/attach-list.tcl

ad_page_contract {

    # This file sets live a revision

     @author Haolan Qin (hqin@arsdigita.com)
     @creation-date Fri Dec 8 13:17:49 2000
     @cvs-id $Id$
} {
    revision_id:naturalnum,notnull
    return_url:notnull
}

db_exec_plsql live_revision_set {
    begin
      content_item.set_live_revision(:revision_id);
    end;
}

ad_returnredirect $return_url