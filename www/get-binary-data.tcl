# /packages/wp/www/get-binary-data.tcl
ad_page_contract {
     
    # This file retrieves attached data (spits back the blob.)
    @author Paul Konigsberg (paulk@arsdigita.com)   
    @creation-date Fri Dec  1 11:44:10 2000
    @cvs-id $Id$
} {
}

# Someday when attachments are in the content repository, you can use the 
# content repository's methods of spitting back blobs....that would be good 
# cause the content repository would automatically know what kind of mime type
# to put on...and it would get the latest version of an attachment.

# serve content. I wonder what is "the content repository's methods of spitting back blobs".
# Does it exist at all?

set url [ad_conn url]

if {![regexp {attach/([0-9]+)/(.*)} $url match attach_id file_name]} {
    ns_log notice "Could not get a pres_item_id and slide_item_id out of url=$url"
    ad_return_error "Wimpy Point" "Could not get a pres_item_id and slide_item_id out of url=$url"
}

ad_require_permission $attach_id wp_view_presentation

set mime_type [db_string get_mime_type {
select mime_type
from cr_revisions
where revision_id = :attach_id
}]

ReturnHeaders $mime_type
db_write_blob get_image "
select content
from cr_revisions
where revision_id = $attach_id
"
