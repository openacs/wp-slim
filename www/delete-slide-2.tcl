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


db_exec_plsql delete_slide {
    begin
      wp_slide.delete(:slide_item_id);
    end;
}

ad_returnredirect presentation-top?[export_url_vars pres_item_id]
