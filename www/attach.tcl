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


set user_id [ad_verify_and_get_user_id]
set creation_ip [ad_conn peeraddr]

set tmp_filename [ns_queryget attachment.tmpfile]
set guessed_file_type [ns_guesstype $attachment]
set n_bytes [file size $tmp_filename]

# strip off the C:\directories... crud and just get the file name
if ![regexp {([^/\\]+)$} $attachment match client_filename] {
    set client_filename $attachment
}




set exception_count 0
set exception_text ""

if { $n_bytes == 0 } {
    append exception_text "<li>You haven't uploaded a file.\n"
    incr exception_count
}

if { ![empty_string_p [ad_parameter MaxAttachmentSize "comments"]] && $n_bytes > [ad_parameter MaxAttachmentSize "comments"] } {
    append exception_text "<li>Your file is too large.  The publisher of [ad_system_name] has chosen to limit attachments to [util_commify_number [ad_parameter MaxAttachmentSize "comments"]] bytes.\n"
    incr exception_count
}

if { $inline_image_p == "t" } {
    if { ![string equal $guessed_file_type "image/gif"] &&
    ![string equal $guessed_file_type "image/jpeg"] } {
	append exception_text "<li>The file you just uploaded is neither a .gif file nor a .jpg file. Therefore we cannot display it as an image. You have two options. You can either reupload a .gif or .jpg file. Or you must select \"Display a link the viewer can use to download the file\".\n"
	incr exception_count
    }
}


if { $exception_count > 0 } {
    ad_return_complaint $exception_count $exception_text
    return
}

if { $inline_image_p == "f" } {
    set display ""
}


# The reason I didn't wrap it in a pl/sql procedure is that 
# I don't know how to do blob_dml_file_bind in pl/sql. Maybe
# the current oracle driver doesn't support it at all. We 
# need to find out.

set item_id [db_exec_plsql attachment_insert {
begin
    select item_id into :1
    from cr_items
    where content_type = 'cr_wp_attachment'
    and   name = :client_filename
    and   parent_id = :slide_item_id;
exception
    when no_data_found then
        :1 := wp_attachment__new(
                :attachment,
		:display,
                :slide_item_id,
                now(),
                :user_id,
                :creation_ip
              );
end;
}]

set db [ns_db gethandle]

set path $tmp_filename

if {[string equal $guessed_file_type "*/*"]} {
    set mime_type "application/octet-stream"
} else {
    set mime_type $guessed_file_type
    # not sure if this is the best way to go. An alternative is to set mime_type to 
    # application/octet-stream as long as mime_type is neither image/gif nor image/jpeg
    db_dml mime_type_insert {
	insert into cr_mime_types (mime_type) 
	select :mime_type
	from dual
	where not exists (select 1 from cr_mime_types where mime_type = :mime_type)
    }
}

ns_db releasehandle $db

ad_returnredirect edit-slide?[export_url_vars slide_item_id pres_item_id]
