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

set context "[list "All Authors"]"

db_multirow users get_wp_users {
    select p.person_id, p.first_names, p.last_name, parties.email, count(i.item_id) as num_presentations
    from persons p, cr_items i, acs_objects o, parties
    where i.content_type = 'cr_wp_presentation'
    and   o.object_id = i.item_id
    and   p.person_id = o.creation_user
    and   parties.party_id = p.person_id
    and   o.context_id = :package_id
    group by p.person_id, p.first_names, p.last_name, parties.email
}

set footer "Note: this is not a complete list of the users.
Users who are collaborators on
presentations owned by others are excluded.  Users who have created
only private presentations are excluded.
[ad_footer]"

ad_return_template

