-- I think some cascade or something needs to be added to the delete
-- statements in case some other object points to a presentation or slide.


-- certainly needs to be modified !!

-- ??
delete from cr_folder_type_map
where content_type in ('cr_wp_image_attachment', 'cr_wp_file_attachment', 'cr_wp_presentation', 'cr_wp_presentation_aud', 'cr_wp_presentation_back', 'cr_wp_slide', 'cr_wp_slide_preamble', 'cr_wp_slide_postamble', 'cr_wp_slide_bullet_items');

-- drop clobs tables



declare
  cursor v_attach_cursor
  is
  select item_id from cr_items
  where content_type in ('cr_wp_image_attachment', 'cr_wp_file_attachment');

begin

  for c in v_attach_cursor loop
    content_item.delete(c.item_id);
  end loop;

end;
/
show errors

-- drop attachment table and views

begin
  content_type.unregister_child_type('cr_wp_slide', 'cr_wp_image_attachment', 'generic');
  content_type.unregister_child_type('cr_wp_slide', 'cr_wp_file_attachment', 'generic');
end;
/
show errors

begin
  content_folder.unregister_content_type(content_item.c_root_folder_id, 'cr_wp_image_attachment');
  content_folder.unregister_content_type(content_item.c_root_folder_id, 'cr_wp_file_attachment');
end;
/
show errors


begin
  content_type.drop_attribute('cr_wp_file_attachment', 'display');
  content_type.drop_attribute('cr_wp_image_attachment', 'display');
end;
/
show errors

delete from acs_objects where object_type in ('cr_wp_file_attachment', 'cr_wp_image_attachment');


begin
  acs_object_type.drop_type('cr_wp_image_attachment');
  acs_object_type.drop_type('cr_wp_file_attachment');
end;
/
show errors


-- content_item.delete really should take context_id into account
declare
  cursor v_slide_clob_cursor
  is
  select item_id from cr_items
  where content_type in ('cr_wp_slide_preamble', 'cr_wp_slide_postamble', 'cr_wp_slide_bullet_items');

  cursor v_slide_cursor
  is
  select item_id from cr_items
  where content_type = 'cr_wp_slide';

  cursor v_pres_clob_cursor
  is
  select item_id from cr_items
  where content_type in ('cr_wp_presentation_aud', 'cr_wp_presentation_back');
  
  cursor v_pres_cursor
  is
  select item_id from cr_items
  where content_type = 'cr_wp_presentation';

begin

  for c in v_slide_clob_cursor loop
    content_item.delete(c.item_id);
  end loop;

  for c in v_slide_cursor loop
    content_item.delete(c.item_id);
  end loop;

  for c in v_pres_clob_cursor loop
    content_item.delete(c.item_id);
  end loop;

  for c in v_pres_cursor loop
    content_item.delete(c.item_id);
  end loop;

end;
/
show errors


-- drop slides and presentations views and tables



begin
  content_type.unregister_child_type('cr_wp_presentation', 'cr_wp_presentation_aud', 'generic');
  content_type.unregister_child_type('cr_wp_presentation', 'cr_wp_presentation_back', 'generic');
  content_type.unregister_child_type('cr_wp_presentation', 'cr_wp_slide', 'generic');

  content_type.unregister_child_type('cr_wp_slide', 'cr_wp_slide_preamble', 'generic');
  content_type.unregister_child_type('cr_wp_slide', 'cr_wp_slide_postamble', 'generic');
  content_type.unregister_child_type('cr_wp_slide', 'cr_wp_slide_bullet_items', 'generic');
end;
/
show errors

begin
  content_folder.unregister_content_type(content_item.c_root_folder_id, 'cr_wp_presentation');
  content_folder.unregister_content_type(content_item.c_root_folder_id, 'cr_wp_presentation_aud');
  content_folder.unregister_content_type(content_item.c_root_folder_id, 'cr_wp_presentation_back');
  content_folder.unregister_content_type(content_item.c_root_folder_id, 'cr_wp_slide');
  content_folder.unregister_content_type(content_item.c_root_folder_id, 'cr_wp_slide_preamble');
  content_folder.unregister_content_type(content_item.c_root_folder_id, 'cr_wp_slide_postamble');
  content_folder.unregister_content_type(content_item.c_root_folder_id, 'cr_wp_slide_bullet_items');
end;
/
show errors


begin
  content_type.drop_attribute('cr_wp_presentation_aud', 'presentation_id');
  content_type.drop_attribute('cr_wp_presentation_back', 'presentation_id');

  content_type.drop_attribute('cr_wp_slide_preamble', 'slide_id');
  content_type.drop_attribute('cr_wp_slide_postamble', 'slide_id');
  content_type.drop_attribute('cr_wp_slide_bullet_items', 'slide_id');
end;
/
show errors


begin
  content_type.drop_attribute('cr_wp_presentation', 'pres_title');
  content_type.drop_attribute('cr_wp_presentation', 'page_signature');
  content_type.drop_attribute('cr_wp_presentation', 'copyright_notice');
  content_type.drop_attribute('cr_wp_presentation', 'style');
  content_type.drop_attribute('cr_wp_presentation', 'public_p');
  content_type.drop_attribute('cr_wp_presentation', 'show_modified_p');

  content_type.drop_attribute('cr_wp_slide', 'sort_key');
  content_type.drop_attribute('cr_wp_slide', 'slide_title');
  content_type.drop_attribute('cr_wp_slide', 'include_in_outline_p');
  content_type.drop_attribute('cr_wp_slide', 'context_break_after_p');
  content_type.drop_attribute('cr_wp_slide', 'style');
  

end;
/
show errors


delete from acs_objects where object_type in ('cr_wp_image_attachment', 'cr_wp_file_attachment', 'cr_wp_presentation', 'cr_wp_presentation_aud', 'cr_wp_presentation_back', 'cr_wp_slide', 'cr_wp_slide_preamble', 'cr_wp_slide_postamble', 'cr_wp_slide_bullet_items');


begin
  acs_object_type.drop_type('cr_wp_presentation');
  acs_object_type.drop_type('cr_wp_presentation_aud');
  acs_object_type.drop_type('cr_wp_presentation_back');

  acs_object_type.drop_type('cr_wp_slide');
  acs_object_type.drop_type('cr_wp_slide_preamble');
  acs_object_type.drop_type('cr_wp_slide_postamble');
  acs_object_type.drop_type('cr_wp_slide_bullet_items');
end;
/
show errors



declare
    default_context acs_objects.object_id%TYPE;
    registered_users acs_objects.object_id%TYPE;
    the_public acs_objects.object_id%TYPE;
begin

    default_context := acs.magic_object_id('default_context');
    registered_users := acs.magic_object_id('registered_users');
--    the_public := acs.magic_object_id('the_public');

    acs_permission.revoke_permission (
        object_id => default_context,
        grantee_id => registered_users,
        privilege => 'wp_create_presentation'
    );

--    acs_permission.revoke_permission (
--        object_id => default_context,
--        grantee_id => the_public,
--        privilege => 'wp_view_presentation'
--    );

end;
/
show errors

begin
	

	acs_privilege.remove_child('admin', 'wp_admin_presentation');

	acs_privilege.remove_child('wp_edit_presentation',  'wp_view_presentation');
	acs_privilege.remove_child('wp_admin_presentation', 'wp_create_presentation');
	acs_privilege.remove_child('wp_admin_presentation', 'wp_edit_presentation');
	acs_privilege.remove_child('wp_admin_presentation', 'wp_delete_presentation');


	delete from acs_permissions
	where privilege in ('wp_admin_presentation', 'wp_create_presentation', 'wp_edit_presentation', 'wp_delete_presentation', 'wp_view_presentation');
	acs_privilege.drop_privilege('wp_admin_presentation');
        acs_privilege.drop_privilege('wp_create_presentation');
        acs_privilege.drop_privilege('wp_edit_presentation'); 
        acs_privilege.drop_privilege('wp_delete_presentation');
        acs_privilege.drop_privilege('wp_view_presentation');
        commit;
end;
/
show errors


drop package wp_attachment;
drop package wp_slide;
drop package wp_presentation;


drop table cr_wp_presentations_aud;
drop table cr_wp_presentations_back;
drop table cr_wp_slides_preamble;
drop table cr_wp_slides_postamble;
drop table cr_wp_slides_bullet_items;

drop table cr_wp_image_attachments;
drop table cr_wp_file_attachments;

drop view cr_wp_image_attachmentsi;
drop view cr_wp_image_attachmentsx;
drop view cr_wp_file_attachmentsi;
drop view cr_wp_file_attachmentsx;

drop view cr_wp_slidesi;
drop view cr_wp_slidesx;
drop table cr_wp_slides;
drop view cr_wp_presentationsi;
drop view cr_wp_presentationsx;
drop table cr_wp_presentations;

-- droping style definitions roc@

drop package wp_style;


drop sequence wp_style_seq;

drop table wp_style_images;

drop table wp_styles;

commit;
