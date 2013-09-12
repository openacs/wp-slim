# /packages/wp/www/attach.tcl
ad_page_contract {

    # This file is for users to upload attachments.

     @author Paul Konigsberg (paulk@arsdigita.com)
     @creation-date Fri Dec  1 10:17:49 2000
     @cvs-id $Id$
} {
    slide_item_id:naturalnum,notnull
    pres_item_id:naturalnum,notnull
    attachment:notnull
    inline_image_p:notnull
    display:notnull
}


set user_id [ad_conn user_id]
set creation_ip [ad_conn peeraddr]

set tmp_filename [ns_queryget attachment.tmpfile]
set mime_type [cr_filename_to_mime_type -create $attachment]
set tmp_size [file size $tmp_filename]

# strip off the C:\directories... crud and just get the file name
if ![regexp {([^/\\]+)$} $attachment match client_filename] {
    set client_filename $attachment
}

set exception_count 0
set exception_text ""

if { $tmp_size == 0 } {
    append exception_text "<li>[_ wp-slim.lt_You_havent_uploaded_a]\n"
    incr exception_count
}

if { ![empty_string_p [parameter::get -parameter MaxAttachmentSize -default "comments"]] && $tmp_size > [parameter::get -parameter MaxAttachmentSize -default "comments"] } {
    set system_name [ad_system_name]
    set bytes [util_commify_number [parameter::get -parameter MaxAttachmentSize -default "comments"]]
    append exception_text "<li>[_ wp-slim.lt_Your_file_is_too_larg]\n"
    incr exception_count
}

if { $exception_count > 0 } {
    ad_return_complaint $exception_count $exception_text
    ad_script_abort
}

if {[string equal $mime_type "*/*"]} {
    set mime_type "application/octet-stream"
}

db_transaction {
    if { $inline_image_p == "t" } {
        set revision_id [cr_import_content -image_type cr_wp_image_attachment -other_type cr_wp_file_attachment \
                                           -image_only $slide_item_id $tmp_filename $tmp_size $mime_type $client_filename]
    } else {
        set revision_id [cr_import_content -image_type cr_wp_image_attachment -other_type cr_wp_file_attachment \
                                           $slide_item_id $tmp_filename $tmp_size $mime_type $client_filename]
    }
    cr_set_imported_content_live -image_sql [db_map image_data] -other_sql [db_map file_data] $mime_type $revision_id
} on_error {
    # most likely a duplicate name, double click, or non-image file uploaded as an inline image.

    ad_return_complaint 1 "[_ wp-slim.lt_There_was_an_error_tr]<blockquote><pre>$errmsg</pre></blockquote>"

    ad_script_abort
}

set edit_slide 1
ad_returnredirect add-edit-slide?[export_vars -url {slide_item_id pres_item_id edit_slide}]
