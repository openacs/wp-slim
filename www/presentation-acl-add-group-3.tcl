# /packages/wp/www/presentation-acl-add-group-3.tcl

ad_page_contract {

    This file grants a group of users certain permission.

    @author Haolan Qin (hqin@arsdigita.com)
    @creation-date 01/22/2001
    @cvs-id $Id$
} {
    pres_item_id:naturalnum,notnull
    role:notnull
    group_id:integer,notnull
}

ad_require_permission $pres_item_id wp_admin_presentation

# adds a group of users
db_exec_plsql group_add {
    declare
        cursor v_cursor is
        select member_id
        from group_member_map
        where group_id = :group_id;
    begin
        if :role = 'read' then
            for c in v_cursor loop
                acs_permission.grant_permission(:pres_item_id, c.member_id, 'wp_view_presentation');
            end loop;
        elsif (:role = 'write') then
            for c in v_cursor loop
                acs_permission.grant_permission(:pres_item_id, c.member_id, 'wp_view_presentation');
                acs_permission.grant_permission(:pres_item_id, c.member_id, 'wp_edit_presentation');
            end loop;
        else
            for c in v_cursor loop
                acs_permission.grant_permission(:pres_item_id, c.member_id, 'wp_view_presentation');
                acs_permission.grant_permission(:pres_item_id, c.member_id, 'wp_edit_presentation');
                acs_permission.grant_permission(:pres_item_id, c.member_id, 'wp_admin_presentation');
            end loop;
        end if;
    end;
}

ad_returnredirect presentation-acl?[export_url_vars pres_item_id]