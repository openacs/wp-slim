# /packages/wimpy-point/www/presentation-create-2.tcl
ad_page_contract {

    # This file actually creates the presentation.
     @author Paul Konigsberg (paul@arsdigita.com)     
     @creation-date Thu Nov  9 20:44:46 2000
     @cvs-id $Id$
} {
    { page_signature:html "" }
    { copyright_notice:html "" }
    { audience:html "" }
    { background:html "" }
    pres_title:html,notnull
    { style:integer -1 }
    show_modified_p:notnull
    public_p:notnull
}

set package_id [ad_conn package_id]

ad_require_permission $package_id wp_create_presentation


set user_id [ad_verify_and_get_user_id]
set creation_ip [ad_conn peeraddr]

# We're inserting 
set pres_item_id [db_exec_plsql wp_presentation_insert {
    begin        
      :1 := wp_presentation.new(
      creation_user    => :user_id,
      creation_ip      => :creation_ip,
      creation_date    => sysdate,
      pres_title       => :pres_title,
      page_signature   => :page_signature,
      copyright_notice => :copyright_notice,
      style            => :style,
      public_p         => :public_p,
      show_modified_p  => :show_modified_p,
      audience         => :audience,
      background       => :background
      );
    end;
}]

db_exec_plsql grant_owner_access {
    begin
      acs_permission.grant_permission(:pres_item_id,:user_id,'wp_admin_presentation');
      acs_permission.grant_permission(:pres_item_id,:user_id,'wp_view_presentation');
      acs_permission.grant_permission(:pres_item_id,:user_id,'wp_edit_presentation');
      acs_permission.grant_permission(:pres_item_id,:user_id,'wp_delete_presentation');
    end;
}

if {[regexp {t} $public_p]} {
    # -1 is the party id for 'the public'.
    db_exec_plsql make_wp_presentation_public {
        begin
          acs_permission.grant_permission(:pres_item_id,acs.magic_object_id('the_public'),'wp_view_presentation');
        end;
    }
}

ad_returnredirect "presentation-top?[export_url_vars pres_item_id]"

