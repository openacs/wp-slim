
-- I think some cascade or something needs to be added to the delete
-- statements in case some other object points to a presentation or slide.


-- certainly needs to be modified !!
delete from cr_item_publish_audit;


delete from cr_folder_type_map
where content_type in ('cr_wp_attachment', 'cr_wp_presentation', 'cr_wp_presentation_aud', 'cr_wp_presentation_back', 'cr_wp_slide', 'cr_wp_slide_preamble', 'cr_wp_slide_postamble', 'cr_wp_slide_bullet_items');

-- drop clobs tables

create function inline_0 ()
returns integer as'
declare
  del_rec record;
begin
  for del_rec in select item_id from cr_items 
	where content_type in (''cr_wp_file_attachment'', ''cr_wp_image_attachment'')
  loop 
    update acs_objects set context_id = null where context_id = del_rec.item_id;
    PERFORM content_item__delete(del_rec.item_id);
  end loop;
return 0;
end;' language 'plpgsql';
select inline_0 ();
drop function inline_0 ();

--checked
-- drop attachment table and views
create function inline_1 ()
returns integer as'
begin
PERFORM content_type__unregister_child_type(''cr_wp_slide'',''cr_wp_file_attachment'',null);
PERFORM content_type__unregister_child_type(''cr_wp_slide'',''cr_wp_image_attachment'',null);
return 0;
end;' language 'plpgsql';
select inline_1 ();
drop function inline_1 ();

--checked
create function inline_2 ()
returns integer as'
begin
  PERFORM content_folder__unregister_content_type(content_item_globals.c_root_folder_id,''cr_wp_file_attachment'',''f'');
  PERFORM content_folder__unregister_content_type(content_item_globals.c_root_folder_id,''cr_wp_image_attachment'',''f'');
return 0;
end;' language 'plpgsql';
select inline_2 ();
drop function inline_2 ();

delete from cr_type_children
where parent_type in (
	'cr_wp_file_attachment', 
	'cr_wp_image_attachment', 
	'cr_wp_presentation',
	'cr_wp_presentation_aud', 
	'cr_wp_presentation_back',
	'cr_wp_slide', 
	'cr_wp_slide_preamble', 
	'cr_wp_slide_postamble',
	'cr_wp_slide_bullet_items'
	);


create function inline_3 ()
returns integer as'
begin
  PERFORM acs_attribute__drop_attribute(''cr_wp_file_attachment'', ''display'');
  PERFORM acs_attribute__drop_attribute(''cr_wp_image_attachment'', ''display'');
return 0;
end;' language 'plpgsql';
select inline_3 ();
drop function inline_3 ();

delete from acs_objects where object_type = 'cr_wp_file_attachment';
delete from acs_objects where object_type = 'cr_wp_image_attachment';


create function inline_4 ()
returns integer as'
begin
PERFORM acs_object_type__drop_type(''cr_wp_file_attachment'',''f'');
PERFORM acs_object_type__drop_type(''cr_wp_image_attachment'',''f'');
return 0;
end;' language 'plpgsql';
select inline_4 ();
drop function inline_4 ();

create function inline_5 ()
returns integer as'
declare
  del_rec_a record;
  del_rec_b record;
  del_rec_c record;
  del_rec_d record;
begin
  for del_rec_a in select item_id from cr_items
  where content_type in (
	''cr_wp_slide_preamble'', 
	''cr_wp_slide_postamble'', 
	''cr_wp_slide_bullet_items''
)
  loop
    update acs_objects set context_id = null 
	where context_id = del_rec_a.item_id; 
    PERFORM content_item__delete(del_rec_a.item_id);
  end loop;

  for del_rec_b
  in select item_id from cr_items
  where content_type = ''cr_wp_slide''
  loop
    update acs_objects set context_id = null 
	where context_id = del_rec_b.item_id; 
    PERFORM content_item__delete(del_rec_b.item_id);
  end loop;

  for del_rec_c
  in select item_id from cr_items
  where content_type in (
	''cr_wp_presentation_aud'', 
	''cr_wp_presentation_back'')
  loop
    update acs_objects set context_id = null 
	where context_id = del_rec_c.item_id;
    PERFORM content_item__delete(del_rec_c.item_id);
  end loop;

  for del_rec_d 
  in select item_id from cr_items
  where content_type = ''cr_wp_presentation''
  loop 
    update acs_objects set context_id = null 
	where context_id = del_rec_d.item_id;
    PERFORM content_item__delete(del_rec_d.item_id);
  end loop;

return 0;
end;' language 'plpgsql';
select inline_5 ();
drop function inline_5 ();

-- drop slides and presentations views and tables

create function inline_6 ()
returns integer as'
begin
  PERFORM
content_folder__unregister_content_type(content_item_globals.c_root_folder_id,''cr_wp_presentation'',''f'');
  PERFORM
content_folder__unregister_content_type(content_item_globals.c_root_folder_id,''cr_wp_presentation_aud'',''f'');
  PERFORM
content_folder__unregister_content_type(content_item_globals.c_root_folder_id,''cr_wp_presentation_back'',''f'');
  PERFORM
content_folder__unregister_content_type(content_item_globals.c_root_folder_id,''cr_wp_slide'',''f'');
  PERFORM
content_folder__unregister_content_type(content_item_globals.c_root_folder_id,''cr_wp_slide_preamble'',''f'');
  PERFORM 
content_folder__unregister_content_type(content_item_globals.c_root_folder_id,''cr_wp_slide_postamble'',''f'');
  PERFORM
content_folder__unregister_content_type(content_item_globals.c_root_folder_id,''cr_wp_slide_bullet_items'',''f'');
  
return 0;
end;' language 'plpgsql';
select inline_6 ();
drop function inline_6 ();





--checked
create function inline_7 ()
returns integer as'
begin
  PERFORM content_type__unregister_child_type(''cr_wp_presentation'',''cr_wp_presentation_aud'', ''null'');
  PERFORM content_type__unregister_child_type(''cr_wp_presentation'',''cr_wp_presentation_back'', ''null'');
  PERFORM content_type__unregister_child_type(''cr_wp_presentation'',''cr_wp_slide'', ''null'');

  PERFORM content_type__unregister_child_type(''cr_wp_slide'',''cr_wp_slide_preamble'', ''null'');
  PERFORM content_type__unregister_child_type(''cr_wp_slide'',''cr_wp_slide_postamble'', ''null'');
  PERFORM content_type__unregister_child_type(''cr_wp_slide'',''cr_wp_slide_bullet_items'',''null'');
return 0;
end;' language 'plpgsql';
select inline_7 ();
drop function inline_7 ();


create function inline_8 ()
returns integer as'
begin
  PERFORM content_type__drop_type(
	''cr_wp_presentation_aud'',
	''f'',
	''f''
);
  PERFORM content_type__drop_type(
        ''cr_wp_presentation'',
        ''f'',
        ''f''
);

return 0;
end;' language 'plpgsql';
select inline_8 ();
drop function inline_8 ();

create function inline_20 ()
returns integer as'
begin
  PERFORM content_type__drop_type(
        ''cr_wp_presentation_back'',
        ''f'',
        ''f''
);

  PERFORM content_type__drop_type(
	''cr_wp_slide_preamble'',
	''f'',
	''f''
);
  PERFORM content_type__drop_type(
       ''cr_wp_slide'',
        ''f'',
        ''f''
);


  PERFORM content_type__drop_type(
	''cr_wp_slide_postamble'',
	''f'',
	''f''
);
  PERFORM content_type__drop_type(
	''cr_wp_slide_bullet_items'',
	''f'',
	''f''
); 

return 0;
end;' language 'plpgsql';
select inline_20 ();
drop function inline_20 ();

--checked
create function inline_9 ()
returns integer as'

begin
  PERFORM acs_attribute__drop_attribute(''cr_wp_presentation'',''pres_title'');
  PERFORM acs_attribute__drop_attribute(''cr_wp_presentation'',''page_signature'');
  PERFORM acs_attribute__drop_attribute(''cr_wp_presentation'',''copyright_notice'');
  PERFORM acs_attribute__drop_attribute(''cr_wp_presentation'',''style'');
  PERFORM acs_attribute__drop_attribute(''cr_wp_presentation'',''public_p'');
  PERFORM acs_attribute__drop_attribute(''cr_wp_presentation'',''show_modified_p'');


  PERFORM acs_attribute__drop_attribute(''cr_wp_slide'',''sort_key'');
  PERFORM acs_attribute__drop_attribute(''cr_wp_slide'',''slide_title'');
  PERFORM acs_attribute__drop_attribute(''cr_wp_slide'',''include_in_outline_p'');
  PERFORM acs_attribute__drop_attribute(''cr_wp_slide'',''context_break_after_p'');
  PERFORM acs_attribute__drop_attribute(''cr_wp_slide'',''style'');

return 0;
end;' language 'plpgsql';
select inline_9 ();
drop function inline_9 ();

delete from acs_objects 
where object_type in (
	'cr_wp_presentation', 
	'cr_wp_presentation_aud', 
	'cr_wp_presentation_back', 
	'cr_wp_slide', 
	'cr_wp_slide_preamble', 
	'cr_wp_slide_postamble', 
	'cr_wp_slide_bullet_items'
);

--checked
create function inline_10 ()
returns integer as'
begin
  PERFORM acs_object_type__drop_type(''cr_wp_presentation'',''f'');
  PERFORM
acs_object_type__drop_type(''cr_wp_presentation_aud'',''f'');
  PERFORM
acs_object_type__drop_type(''cr_wp_presentation_back'',''f'');
  PERFORM acs_object_type__drop_type(''cr_wp_slide'',''f'');
  PERFORM acs_object_type__drop_type(''cr_wp_slide_preamble'',''f'');
  PERFORM acs_object_type__drop_type(''cr_wp_slide_postamble'',''f'');
  PERFORM acs_object_type__drop_type(''cr_wp_slide_bullet_items'',''f'');
return 0;
end;' language 'plpgsql';
select inline_10 ();
drop function inline_10 ();

--checked
create function inline_11 ()
returns integer as'
declare
    default_context acs_objects.object_id%TYPE;
    registered_users acs_objects.object_id%TYPE;
    the_public acs_objects.object_id%TYPE;
begin

    default_context := acs__magic_object_id(''default_context'');
    registered_users := acs__magic_object_id(''registered_users'');
    the_public := acs__magic_object_id(''the_public'');

    PERFORM acs_permission__revoke_permission (
         default_context,
         registered_users,
         ''wp_create_presentation''
    );

    PERFORM acs_permission__revoke_permission (
         default_context,
         the_public,
         ''wp_view_presentation''
    );

return 0;
end;' language 'plpgsql';
select inline_11 ();
drop function inline_11 ();

--checked
create function inline_12 ()
returns integer as'
begin
	delete from acs_permissions
	where privilege in (
		''wp_admin_presentation'', 
		''wp_create_presentation'', 
		''wp_edit_presentation'', 
		''wp_delete_presentation'', 
		''wp_view_presentation''
	);
	PERFORM acs_privilege__drop_privilege(''wp_admin_presentation'');
	PERFORM acs_privilege__drop_privilege(''wp_create_presentation'');
	PERFORM acs_privilege__drop_privilege(''wp_edit_presentation''); 
	PERFORM acs_privilege__drop_privilege(''wp_delete_presentation'');
	PERFORM acs_privilege__drop_privilege(''wp_view_presentation'');
return 0;
end;' language 'plpgsql';
select inline_12 ();
drop function inline_12 ();


DROP FUNCTION wp_attachment__delete (
	integer
);

DROP FUNCTION wp_attachment__new_revision(
    integer	 
);

--drop package wp_slide;
DROP FUNCTION wp_slide__new(
	integer,
	timestamp,
	integer,
	varchar,
	varchar,
	integer,
	integer,
	integer,
	varchar,
	varchar,
	varchar,	
        boolean,
	boolean,
	integer
);

DROP FUNCTION wp_slide__delete_preamble(
	integer
);

DROP FUNCTION wp_slide__delete_postamble(
	integer
);

DROP FUNCTION wp_slide__delete_bullet_items(
	integer
);

DROP FUNCTION wp_slide__delete(
	integer
);

DROP FUNCTION wp_slide__get_preamble_revision(
	integer
);
DROP FUNCTION wp_slide__get_preamble(
	integer
);

--drop package wp_presentation;
DROP FUNCTION wp_presentation__new(
	timestamp,
	integer,
	varchar,
	varchar,
	varchar,
	varchar,
	integer,
	boolean,
	boolean,
        varchar,
        varchar
);

DROP FUNCTION wp_presentation__delete_audience(
	integer
);

DROP FUNCTION wp_presentation__delete_background(
	integer
);

DROP FUNCTION wp_presentation__delete(
	integer
);

DROP FUNCTION wp_presentation__get_ad_revision (
	integer
);

DROP FUNCTION wp_presentation__get_bg_revision(
	integer
);
DROP FUNCTION wp_presentation__get_audience(
	integer
);

DROP FUNCTION wp_presentation__get_background(
	integer
);

drop function wp_slide__new_revision(
    timestamp,
    integer,
    varchar,
    integer,
    varchar, 
    text, 
    varchar, 
    varchar, 
    integer, 
    integer, 
    integer, 
    boolean,
    boolean);

drop function wp_presentation__new_revision (
    timestamp,
    integer,	 
    varchar,	 
    integer,	 
    varchar(400),    
    varchar(200),	 
    varchar(400),	 
    integer,		
    boolean,	
    boolean,	
    varchar,	
    varchar);

--checked
drop table cr_wp_presentations_aud;
drop table cr_wp_presentations_back;
drop table cr_wp_slides_preamble;
drop table cr_wp_slides_postamble;
drop table cr_wp_slides_bullet_items;

drop view cr_wp_image_attachmentsi;
drop view cr_wp_image_attachmentsx;
drop table cr_wp_image_attachments;

drop view cr_wp_file_attachmentsi;
drop view cr_wp_file_attachmentsx;
drop table cr_wp_file_attachments;

drop view cr_wp_slidesi;
drop view cr_wp_slidesx;
drop table cr_wp_slides;
drop view cr_wp_presentationsi;
drop view cr_wp_presentationsx;
drop table cr_wp_presentations;

drop table wp_styles;
drop function wp_slide__get_bullet_items_revision(integer);
drop function wp_slide__get_postamble_revision(integer);
drop function wp_slide__get_bullet_items(integer);
drop function wp_slide__get_postamble(integer);

drop function wp_presentation__set_live_revision(integer);
