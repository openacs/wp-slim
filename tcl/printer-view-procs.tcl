ad_library {

   Wimpy Helper methods
}

ad_proc get_attach_list {
slide_item_id
}  {

db_multirow attach_list get_attachments {
    
    select live_revision as attach_id, display, name as file_name
    from (select live_revision, name
          from cr_items
          where parent_id = :slide_item_id and
                content_type in ('cr_wp_image_attachment', 'cr_wp_file_attachment')
          ) a
    left join cr_wp_image_attachments on (a.live_revision = attach_id)

}

}
