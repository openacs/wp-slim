# /packages/wp/www/presentation-acl-delete.tcl

ad_page_contract {

    This page revokes certain privilege on a presentation from a user.

    @author Haolan Qin (hqin@arsdigita.com)
    @creation-date 01/22/2001
    @cvs-id $Id$
} {
    pres_item_id:naturalnum,notnull
    role:notnull
    user_id:naturalnum,notnull
}

ad_require_permission $pres_item_id wp_admin_presentation

set privilege [ad_decode $role "read" "wp_view_presentation" "write" "wp_edit_presentation" "admin" "wp_admin_presentation" ""]

db_exec_plsql revoke_privilege {
    declare
      owner_id  acs_objects.creation_user%TYPE;
    begin
      select creation_user into owner_id
      from acs_objects
      where object_id = :pres_item_id;
 
      if (owner_id <> :user_id) then
        acs_permission.revoke_permission(:pres_item_id, :user_id, :privilege);
      end if;
    end;
}

ad_returnredirect presentation-acl?[export_url_vars pres_item_id]