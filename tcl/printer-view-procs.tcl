ad_library {

   Wimpy Helper methods
}

ad_proc get_attach_list {
slide_item_id
}  {

db_multirow attach_list get_attachments { *SQL* }

}
