# /packages/wimpy-point/www/add-edit-presentation.tcl
ad_page_contract {
     # This file displays the form for creating a new presentation.
     @author Paul Konigsberg (paul@arsdigita.com)
     @creation-date Thu Nov  9 10:04:22 2000
     @cvs-id $Id$
} {
   pres_item_id:naturalnum,optional
} -properties {
    title:onevalue
    context:onevalue
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
set creation_ip [ad_conn peeraddr]
set audience [_ wp-slim.Audience]
set background [_ wp-slim.Background]
set def ""

permission::require_permission -party_id $user_id -object_id $package_id -privilege wp_create_presentation

# Get the available styles

set items [db_list_of_lists wp_styles { *SQL* }]
lappend items [list none -1]

# Messages shown in help text

set give_this_pre [_ wp-slim.lt_Give_this_presentatio]
set if_you [_ wp-slim.lt_If_you_want_a_signatu]
append if_you [_ wp-slim.lt_Personally_I_like_to_]
set copyright [_ wp-slim.lt_If_you_want_a_copyrig]
set WimpyPoint [_ wp-slim.lt_WimpyPoint_keeps_trac]
set hide [_ wp-slim.lt_If_you_want_to_hide_t] 
append hide [_ wp-slim.lt_Suggestion_if_you_hav]
set finally [_ wp-slim.lt_Finally_if_youre_plan]

ad_form -name add-edit-presentation -form {
    pres_item_id:key
    {pres_title:text(text) 
	{label "<b>#wp-slim.Title#</b>"}
	{html { size 50 }}
	{help_text "$give_this_pre"}
    }
    {page_signature:text(text),optional
	{label "<b>#wp-slim.Page_Signature#</b>"}
	{html { size 50 }}
	{value $def}
	{help_text "$if_you"}
    }
    {copyright_notice:text(text),optional
	{label "<b>#wp-slim.Copyright_Notice#</b>"}
	{html { size 50 }}
	{value $def}
	{help_text "$copyright"}
    }
    {show_modified_p:text(radio)
	{label "<b>#wp-slim.lt_Show_Modification_Dat#</b>"}
	{options { {#wp-slim.Yes# t} {#wp-slim.No# f}}}
	{value t}
	{help_text "$WimpyPoint"}
    }
    {public_p:text(radio)
	{label "<b>#wp-slim.Available_to_Public#</b>"}
	{options {{#wp-slim.Yes# t} {#wp-slim.No# f}}}
	{value t}
	{help_text "$hide"}
    }
    {style:text(select)
	{label "<b>#wp-slim.Style#</b>"}
	{options $items}
    }
    {audience:text(textarea),optional
	{label "<b>#wp-slim.Audience#</b>"}
	{html {rows 4 cols 50}}
    }
    {background:text(textarea),optional
	{label "<b>#wp-slim.Background#</b>"}
	{html {rows 4 cols 50 }}
	{help_text "$finally"}
    }
} -new_data {
    set title "[_ wp-slim.Create_Presentation]"
    set context [list $title]
    set pres_item_id [db_exec_plsql wp_presentation_insert { *SQL* } ]
    db_exec_plsql grant_owner_access { *SQL* }
    if {$public_p == "t"} {
	db_exec_plsql make_wp_presentation_public { *SQL* }
    }
} -edit_data {
    set title "[_ wp-slim.Edit_Presentation]"
    set context [list [list [export_vars -base presentation-top {pres_item_id}]  "$pres_title"] "[_ wp-slim.Edit_Presentation]"]
    db_exec_plsql update_wp_presentation { *SQL* }
    if {$public_p == "t"} {
	db_exec_plsql grant_public_read { *SQL* }
    } else {
        db_exec_plsql revoke_public_read { *SQL* }
    }

} -new_request {
    set title "[_ wp-slim.Create_Presentation]"
    set context [list $title]

} -edit_request {
    db_1row get_presentation_data { *SQL* }
    db_1row get_aud_data { *SQL* } 
    db_1row get_back_data { *SQL* }
    set page_signature [ns_quotehtml $page_signature]
    set copyright_notice [ns_quotehtml $copyright_notice]
    set audience [ns_quotehtml $audience] 
    set background [ns_quotehtml $background]
    set title "[_ wp-slim.Edit_Presentation]"
    set context [list [list [export_vars -base presentation-top {pres_item_id}]  "$pres_title"] "[_ wp-slim.Edit_Presentation]"]
} -after_submit {
    ad_returnredirect [export_vars -base presentation-top {pres_item_id}]
    ad_script_abort
}





