# /wp/style-image-add.tcl
ad_page_contract {
    Add an image to a style.

    @param style_id id of the style to which to add
    @param image the image to add

    @creation-date  28 Nov 1999
    @author Jon Salz <jsalz@mit.edu>
    @author Rocael HR <roc@viaro.net>
} {
    style_id:naturalnum,notnull
    image:notnull
    image.tmpfile:tmpfile,notnull
}

set user_id [ad_maybe_redirect_for_registration]

set tmp_filename ${image.tmpfile}

set file_extension [string tolower [file extension $image]]
# remove the first . from the file extension
regsub {\.} $file_extension "" file_extension
set guessed_file_type [ns_guesstype $image]

set n_bytes [file size $tmp_filename]
# strip off the C:\directories... crud and just get the file name
if ![regexp {([^/\\]+)$} $image match client_filename] {
    set client_filename $image
}

    set mime_type [ns_guesstype $client_filename]



db_transaction {

    set revision_id [cr_import_content -image_only -title $client_filename "" $tmp_filename $n_bytes $mime_type "${client_filename}${style_id}" ]

   
    db_dml wp_style_img_insert { *SQL* }

    set background_image [db_string get_bg_image_id { *SQL* }]

    if {$background_image == 0} {
	db_dml update_bg_image { *SQL* }
    }
    
} on_error {
    # most likely a duplicate name, double click, or non-image file uploaded as an inline image.

    ad_return_complaint 1 "[_ wp-slim.lt_There_was_an_error_tr_1]<blockquote><pre>$errmsg</pre></blockquote>"

    ad_script_abort

}

db_release_unused_handles

ad_returnredirect "style-view?style_id=$style_id"
