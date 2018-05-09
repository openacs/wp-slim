# /packages/wimpy-point/www/index.tcl
ad_page_contract {
     
    This file is meant to display all the presentations you own
    and give you some options...like creating a new presentation or
    editing an old one.
    
    @author Rocael Hernandez (roc@viaro.net) openacs package owner
    @author Paul Konigsberg (paul@arsdigita.com, original)
    @creation-date Wed Nov  8 17:33:21 2000
    @cvs-id $Id$
} {
    {show_age:integer "14"}
    {show_user "yours"}
}

set package_id [ad_conn package_id]

set context [list]

set user_id [ad_conn user_id]

set show_user_value "show_user=$show_user"
set show_age_value "show_age=$show_age"

if {$show_age != 0} {
    if {[db_type] eq "oracle"} {
        set extra_where_clauses "and ao.creation_date >= (sysdate - $show_age)"
    } else {
        set extra_where_clauses "and ao.creation_date >= (now() - interval '$show_age days')"
    }
} else {
    set extra_where_clauses ""
}

if {$user_id == 0} {
    db_multirow allpresentations get_all_public_presentations { *SQL* } {
	set creation_date [lc_time_fmt $creation_date "%Q"]
    }
    
    set return_url [ns_urlencode [ad_conn url]]
    ad_return_template index-unregistered
} else {
    db_multirow presentations get_my_presentations { *SQL* } {
	set creation_date [lc_time_fmt $creation_date "%Q"]
    }

    if {$show_user eq "all"} {
	db_multirow allpresentations get_all_visible_presentations { *SQL* } {
	    set creation_date [lc_time_fmt $creation_date "%Q"]
	}
    }

    ad_return_template index
}
