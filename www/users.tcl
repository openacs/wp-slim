# /packages/wimpy-point/www/users.tcl
ad_page_contract {

    # This file shows a list of all wimpy point users.
     @author Paul Konigsberg (paul@arsdigita.com)
     @creation-date Wed Nov  8 17:43:40 2000
     @cvs-id $Id$
} {
    starts_with:html,optional
    bulk_copy:naturalnum,optional
} -properties {
    context
    users:multirow
}

set package_id [ad_conn package_id]

# Right now this file is weak. It should link the username to a one-user page which shows 
# What presentations that users has created (but only if the current user has permission to see/view
# those presentations.)

set context "[list "[_ wp-slim.All_Authors]"]"

db_multirow users get_wp_users { *SQL* }


ad_return_template

