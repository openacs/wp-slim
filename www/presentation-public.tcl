# /packages/wp/www/presentation-public.tcl

ad_page_contract {

    This page makes a presentation public or private

    @author Haolan Qin (hqin@arsdigita.com)
    @creation-date 01/21/2001
    @cvs-id $Id$
} {
    pres_item_id:naturalnum,notnull
    public_p:notnull
}

ad_require_permission $pres_item_id wp_admin_presentation

if {[regexp {t} $public_p]} {
    db_exec_plsql grant_public_read {
        begin
          acs_permission.grant_permission(:pres_item_id,acs.magic_object_id('the_public'),'wp_view_presentation');
        end;
    }
} else {
    db_exec_plsql grant_public_read {
        begin
          acs_permission.revoke_permission(:pres_item_id,acs.magic_object_id('the_public'),'wp_view_presentation');
        end;
    }
}

db_dml public_p_change {
    update cr_wp_presentations
    set public_p = :public_p
    where presentation_id = (select live_revision
                             from cr_items
                             where item_id = :pres_item_id)
}

ad_returnredirect presentation-acl?[export_url_vars pres_item_id]