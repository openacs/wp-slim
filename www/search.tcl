ad_page_contract {

    Reusable page for searching for a user by email or last_name.
    Returns to "target" with user_id_from_search, first_names_from_search,
    ast_name_from_search, and email_from_search, and passing along all
    form variables listed in "passthrough".
    
    @cvs-id $Id$

    @param email search string
    @param last_name search string
    @param keyword For looking through both email and last_name (optional)
    @param target URL to return to
    @param passthrough Form variables to pass along from caller
    @param limit_to_users_in_group_id Limits search to users in the specified group id.  This can be a comma separated list to allow searches within multiple groups. (optional)

    @author Jin Choi (jsc@arsdigita.com)
} {
    {email ""}
    {last_name ""}
    keyword:optional
    target
    {passthrough ""}
    {limit_users_in_group_id:naturalnum ""}
} -properties {
    group_name:onevalue
    search_type:onevalue
    keyword:onevalue
    email:onevalue
    last_name:onevalue
    export_authorize:onevalue
    passthrough_parameters:onevalue
}

# Check input.
set exception_count 0
set exception_text ""

if {[info exists keyword]} {
    # this is an administrator 
    if { $keyword eq "" } {
	incr exception_count
	append exception_text "<li>[_ wp-slim.lt_You_forgot_to_type_a_]\n"
    }
} else {
    # from one of the user pages
    if { (![info exists email] || $email eq "") && \
	    (![info exists last_name] || $last_name eq "") } {
	incr exception_count
	append exception_text "<li>[_ wp-slim.lt_You_must_specify_eith]\n"
    }

    if { [info exists email] && [info exists last_name] && \
	    $email ne "" && $last_name ne "" } {
	incr exception_count
	append exception_text "<li>[_ wp-slim.lt_You_can_only_specify_]\n"
    }

    if { ![info exists target] || $target eq "" } {
	incr exception_count
	set host_administrator [ad_host_administrator]
	append exception_text "<li>[_ wp-slim.lt_Target_was_not_specif]\n"
    }
}

if { $exception_count != 00 } {
    ad_return_complaint $exception_count $exception_text
    return
}

####
# Input okay. Now start building the SQL

set where_clause [list]
if { [info exists keyword] } {
    set search_type "keyword"
    set sql_keyword "%[string tolower $keyword]%"
    lappend where_clause "(email like :sql_keyword or lower(first_names || ' ' || last_name) like :sql_keyword)"
} elseif { [info exists email] && $email ne "" } {
    set search_type "email"    
    set sql_email "%[string tolower $email]%"
    lappend where_clause "email like :sql_email"
} else {
    set search_type "last"        
    set sql_last_name "%[string tolower $last_name]%"
    lappend where_clause "lower(last_name) like :sql_last_name"
}

lappend where_clause {member_state = 'approved'}

if { ![info exists passthrough] } {
    set passthrough_parameters ""
} else {
    set passthrough_parameters "[export_entire_form_as_url_vars $passthrough]"
}

if { ([info exists limit_to_users_in_group_id] && $limit_to_users_in_group_id ne "") } {
set query "select distinct first_names, last_name, email, member_state, email_verified_p, cu.user_id
from cc_users cu, group_member_map gm, membership_rels mr
where cu.user_id = gm.member_id
  and gm.rel_id = mr.rel_id
  and gm.group_id = :limit_to_users_in_group_id
  and [join $where_clause "\nand "]"

} else {
set query "select user_id, email_verified_p, first_names, last_name, email, member_state
from cc_users
where [join $where_clause "\nand "]"
}



set i 0

set user_items ""

set rowcount 0

db_foreach user_search_admin $query {
    incr rowcount

    set user_id_from_search $user_id
    set first_names_from_search $first_names
    set last_name_from_search $last_name
    set email_from_search $email
    
    set user_search:[set rowcount](user_id) $user_id
    set user_search:[set rowcount](first_names) $first_names
    set user_search:[set rowcount](last_name) $last_name
    set user_search:[set rowcount](email) $email
    set user_search:[set rowcount](export_vars) [export_vars {user_id_from_search first_names_from_search last_name_from_search email_from_search}]
    set user_search:[set rowcount](member_state) $member_state
}

set user_search:rowcount $rowcount

# We are limiting the search to one group - display that group's name
if { ([info exists limit_to_users_in_group_id] && $limit_to_users_in_group_id ne "") && ![regexp {[^0-9]} $limit_to_users_in_group_id] } {
    set group_name [db_string user_group_name_from_id "select group_name from user_groups where group_id = :limit_to_users_in_group_id"]
} else {
    set group_name ""
}

set export_authorize [export_ns_set_vars {url} {only_authorized_p}]


ad_return_template
