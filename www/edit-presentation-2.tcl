# /packages/wp/www/edit-presentation-2.tcl
ad_page_contract {
     
     @author paulk@arsdigita.com [paulk@arsdigita.com]
     @creation-date Tue Nov 21 08:40:33 2000
     @cvs-id
} {
    pres_item_id
    pres_title
    page_signature
    copyright_notice
    show_modified_p
    public_p
    style
    audience
    background
}

ad_require_permission $pres_item_id wp_edit_presentation

set user_id [ad_verify_and_get_user_id]
set creation_ip [ad_conn peeraddr]

db_exec_plsql update_wp_presentation {
    begin
      wp_presentation.new_revision(
      creation_user    => :user_id,
      creation_ip      => :creation_ip,
      creation_date    => sysdate,
      pres_item_id     => :pres_item_id,
      pres_title       => :pres_title,
      page_signature   => :page_signature,
      copyright_notice => :copyright_notice,
      public_p         => :public_p,
      show_modified_p  => :show_modified_p,
      style            => :style,
      audience         => :audience,
      background       => :background
      );
    end;
}

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

ad_returnredirect "presentation-top?[export_url_vars pres_item_id]"