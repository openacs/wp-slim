
-- Wimpy Point Data Model for ACS 4.0
-- 
-- Paul Konigsberg paulk@arsdigita.com 10/22/00
--    original module author Jon Salz jsalz@mit.edu
-- Ported to PostgreSQL: Jack Purswani and Sidharth Widge

-- Notes: 

-- Nothing is going into the content repository. 
-- Reasons for putting stuff in the repository:
-- You get versioning. You get indexed for intermedia searching.
-- Things that should go into the repository are:
-- 1. Presentation: You should be able to version a presentation. When you 
-- do, you should remember the current versions of all the slides in it.
-- 2. Slides.
-- 3. Attachments - since the repository is supposed to be good 
--    at handling weird lob data. (i.e. handling the mime type and
--    serving it back.
-- More on content repository: After Jesse Koontz's review, he said:
-- presentation -- subclass from content_items
-- slides -- subclass from content_items
-- Versions: are copied presentation
-- Clobs are mostly not used. Instead varchar(4000) is still being used
-- because working with clobs is tough in plsql. This needs to change.
-- Presentation have no context_id....should they? Answer: Yes their context id should
-- point to the package_id of the instance of this wimpy point. 
-- (There could be multiple instances.)



-- Only the basic -1 is implemented right now.
-- Style for presentation. We'll think more about this later if there's time 
-- maybe allow ADPs for more flexibility.

insert into cr_mime_types (label, mime_type) 
select 'Binary data', 'application/octet-stream'
from dual
where not exists (select 1 from cr_mime_types where mime_type ='application/octet-stream');


create sequence wp_style_seq;

create table wp_styles (
	style_id		integer 
                                constraint wp_styles_style_id_pk
                                primary key,
	name			varchar(400) 
                                constraint wp_styles_name_nn
                                not null,
	css			text,
	text_color		varchar(20) check(text_color like '%,%,%'),
	background_color	varchar(20) check(background_color like '%,%,%'),
	background_image	integer default 0,
	link_color		varchar(20) check(link_color like '%,%,%'),
	alink_color		varchar(20) check(alink_color like '%,%,%'),
	vlink_color		varchar(20) check(vlink_color like '%,%,%'),
	public_p		char(1) default 'f' check(public_p in ('t','f')),
	owner			integer 
				constraint wp_styles_to_users
				references users (user_id)
);


insert into wp_styles(style_id, name, css)
values(-1, 'Default (Plain)',
       'BODY { back-color: white; color: black } P { line-height: 120% } UL { line-height: 140% }');

-- this is also a new index!  roc@
create index wp_styles_by_owner on wp_styles(owner);

-- new table for supporting background images!
-- Images used for styles.

create table wp_style_images (
-- this one references to a cr!
	wp_style_images_id integer  primary key,
	style_id	integer references wp_styles(style_id) on delete cascade not null,
	file_size	integer not null,
	file_name	varchar(200) not null
);

create index wp_style_images_style_id on wp_style_images(style_id);


--jackp: p_create the presentation table
create table cr_wp_presentations (
	presentation_id		integer
				constraint cr_wp_presentations_id_fk
                                references cr_revisions
                                constraint cr_wp_presentations_pk
                                primary key,
	-- The title of the presentations, as displayed to the user.
	pres_title		varchar(400) 
                                constraint cr_wp_presentations_title_nn
                                not null,
	-- A signature on the bottom.
	page_signature		varchar(200),
	-- The copyright notice displayed on all pages.
	copyright_notice	varchar(400),
        -- Style information.
	style			integer
                                constraint cr_wp_style_fk
				references wp_styles on delete set null,
	public_p	        boolean
				constraint cr_wp_public_p_ck
				check(public_p in ('t','f')),
	-- Show last-modified date for slide?
	show_modified_p         boolean
				constraint cr_wp_show_p_ck
				check(show_modified_p in ('t','f')),
	show_comments_p		char(1) default 'f' 
				constraint cr_wp_comments_p 
				check(show_comments_p in ('t','f'))
);


-- Slide belonging to presentations. 
create table cr_wp_slides (
	slide_id		integer
				constraint cr_wp_slides_slide_id_fk
                                references cr_revisions
                                constraint cr_wp_slides_slide_id_pk
                                primary key,

	original_slide_id	integer,
	sort_key		integer  
                                constraint cr_wp_slides_sort_key_nn
                                not null,
	slide_title		varchar(400)
				constraint cr_wp_slides_title_nn
				not null,
	include_in_outline_p	boolean
				constraint cr_wp_slides_incld_ck
				check(include_in_outline_p in ('t','f')),
	context_break_after_p	boolean
				constraint cr_wp_slides_context_ck
				check(context_break_after_p in ('t','f')),
	style			integer
				constraint cr_wp_slides_style_fk
                                references wp_styles
);

create table cr_wp_presentations_aud (
	id 		integer  
                        references cr_revisions,
	presentation_id	integer
			constraint cr_wp_paudience_pid_nn
			not null
			constraint cr_wp_paudience_pid_fk
                       	references cr_wp_presentations
);

create table cr_wp_presentations_back (
	id 		integer 
                        references cr_revisions,
	presentation_id	integer
			constraint cr_wp_pbackground_pid_nn
			not null
			constraint cr_wp_pbackground_pid_fk
                       	references cr_wp_presentations
);

--jackp: table to store the preamble
create table cr_wp_slides_preamble (
	id 		integer 
                        references cr_revisions,
	slide_id	integer
			constraint cr_wp_spreamble_sid_nn
			not null
			constraint cr_wp_spreamble_sid_fk
                       	references cr_wp_slides
);

--jackp: table to store the postamble
create table cr_wp_slides_postamble (
	id 		integer
                        references cr_revisions,
	slide_id	integer
			constraint cr_wp_spostamble_sid_nn
			not null
			constraint cr_wp_spostamble_sid_fk
                       	references cr_wp_slides
);

--jackp: table to store the bullet items
create table cr_wp_slides_bullet_items (
	id 		integer 
                        references cr_revisions,
	slide_id	integer
			constraint cr_wp_sbullet_sid_nn
			not null
			constraint cr_wp_sbullet_sid_fk
                       	references cr_wp_slides
);

--jackp: Need to use inline functions in PostgreSQL.
--jackp: We p_create the main content type here.
--jackp: Need to use PERFORM command line to indicate that the line needs
--jackp: to be run.
create function inline_0 ()
returns integer as'
begin

--jackp: from acs-content-repository/sql/postgresql/content-type.sql
--jackp: The structure for content_type__create_type is as follows: 
--jackp:   PERFORM content_type__create_type (
--jackp:  	content_type        
--jackp:  	supertype             
--jackp:   	pretty_name            
--jackp: 	pretty_plural         
--jackp:	table_name            
--jackp:	id_column              
--jackp:	name_method          
--jackp:  );

	PERFORM content_type__create_type (
    		''cr_wp_presentation_aud'',
		''content_revision'',
  		''Wimpy Point  Presentation  Audience'',
		''Wimpy Point Presentation Audiences'',
		''cr_wp_presentations_aud'',
		''id'',
	        null
  	);

   	PERFORM content_type__create_type (
		''cr_wp_presentation_back'',
		''content_revision'',
		''Wimpy Point Presentation Background'',
		''WimpyPoint Presentation Backgrounds'',
		''cr_wp_presentations_back'', 
		''id'',
		null
	);

	PERFORM content_type__create_type (
		''cr_wp_presentation'',
		''content_revision'',
		''Wimpy Point Presentation'', 
		''WimpyPoint Presentations'',
		''cr_wp_presentations'',
		''presentation_id'',
		null
	);            
	return 0;
end;' language 'plpgsql';
select inline_0 ();
drop function inline_0 ();

create function inline_1 ()
returns integer as'
begin
	PERFORM content_type__create_type (
    		''cr_wp_slide_preamble'', 
		''content_revision'',
    		''wimpy Point Slide Preamble'', 
    		''Wimpy Point Slide Preambles'', 
   		''cr_wp_slides_preamble'', 
		''id'', 
		null
	);            

	PERFORM content_type__create_type (
		 ''cr_wp_slide_postamble'',
		 ''content_revision'',
		 ''wimpy Point Slide Postamble'',
		 ''WimpyPoint Slide Postamble'',
		 ''cr_wp_slides_postamble'',
		 ''id'',
		 null 
  	);
  
	PERFORM content_type__create_type (
		''cr_wp_slide_bullet_items'',
		''content_revision'',
		''wimpy Point Slide Bullet Items'',
		''WimpyPoint Slide Bullet Items'',
		''cr_wp_slides_bullet_items'',
		''id'',
		null
  	);

	PERFORM content_type__create_type (
		''cr_wp_slide'',
		''content_revision'',
		''WimpyPoint Slide'',
		''wimpy point slide'',
		''cr_wp_slides'',
		''slide_id'',
		null
  	);
	return 0;
end;' language 'plpgsql';
select inline_1 ();
drop function inline_1 ();

--jackp: This section p_creates the attributes that are linked to the
--jackp: different types
create function inline_2 ()
returns integer as'
declare
  	attr_id        acs_attributes.attribute_id%TYPE; 
begin

--jackp: from acs-content-repository/sql/postgresql/content-type.sql
--jackp: attr_id := content_type__create_attribute (
--jackp:  	content_type           
--jackp:  	attribute_name         
--jackp:  	datatype               
--jackp:  	pretty_name            
--jackp:  	pretty_plural          
--jackp:  	sort_order
--jackp: 	default_value
--jackp:  	column_spec
--jackp: );

 	attr_id := content_type__create_attribute (
    		''cr_wp_presentation'',
    		''pres_title'',		
    		''text'',			
    		''Presentation Title'',	
    		''Presentation Titles'',	
    		null,		  
    		null,		  
    		''text''
  	);

  	attr_id := content_type__create_attribute (
    		''cr_wp_presentation'',
    		''page_signature'',
    		''text'',
		''Page Signature'',
		''Page Signatures'',
		null,
		null,		
		''text''
	);

	attr_id := content_type__create_attribute (
		''cr_wp_presentation'',
		''copyright_notice'',
		''text'',
		''Copyright Notice'',
		''Copyright Notices'',	
		null,
		null,
		''text''
	);

	attr_id := content_type__create_attribute (
		''cr_wp_presentation'',
		''style'',
		''integer'',
		''Style'',
		''Styles'',
		null,
		null,
		''text''
	);

	attr_id := content_type__create_attribute (
		''cr_wp_presentation'',
		''public_p'',
		''boolean'',
		''Public Flag'',
		''Public Flags'',
		null,
		null,		
		''text''
	);

	attr_id := content_type__create_attribute (
		''cr_wp_presentation'',
		''show_modified_p'',
		''boolean'',	
		''Show Modified Flag'',
		''Show Modified Flags'',
		null,
		null,
		''text''
	);
	return 0;
end;' language 'plpgsql';
select inline_2 ();
drop function inline_2 ();


create function inline_3 ()
returns integer as'
declare
  	attr_id         acs_attributes.attribute_id%TYPE;
begin
  	attr_id := content_type__create_attribute (
    		''cr_wp_slide'',
    		''sort_key'',
    		''integer'',
    		''Sort Key'',
    		''Sort Keys'',
    		null,		
    		null,		
    		''text''
  	);

  	attr_id := content_type__create_attribute (
    		''cr_wp_slide'',
    		''slide_title'',
   	 	''text'',
    		''Slide Title'',
    		''Slide Titles'',
    		null,
    		null,
    		''text''
 	);

  	attr_id := content_type__create_attribute (
    		''cr_wp_slide'',
    		''include_in_outline_p'',
    		''boolean'',
    		''Include in Outline Flag'',
    		''Include in Outline Flags'',
    		null,
    		null,
    		''text''
  	);

  	attr_id := content_type__create_attribute (
    		''cr_wp_slide'',
    		''context_break_after_p'',
    		''boolean'',
    		''Context Break After Flag'',
    		''Context Break After Flags'',
    		null,
    		null,
    		''text''
  	);

  	attr_id := content_type__create_attribute (
    		''cr_wp_slide'',
    		''style'',
    		''integer'',
    		''Style'',
    		''Styles'',
    		null,
    		null,
    		''text''
  	);
	return 0;
end;' language 'plpgsql';
select inline_3 ();
drop function inline_3 ();

create function inline_4 ()
returns integer as'
declare
  	attr_id acs_attributes.attribute_id%TYPE;
begin

 	attr_id := content_type__create_attribute (
    		''cr_wp_presentation_aud'',
    		''presentation_id'',
    		''integer'',
    		''Prsentation ID'',
    		''Presentation IDs'',
    		null,
    		null,
    		''integer''
 	);

  	attr_id := content_type__create_attribute (
    		''cr_wp_presentation_back'',
    		''presentation_id'',
    		''integer'',
    		''Prsentation ID'',
    		''Presentation IDs'',
    		null,
    		null,
    		''integer''
  	);

  	attr_id := content_type__create_attribute (
    		''cr_wp_slide_preamble'',
    		''slide_id'',
    		''integer'',
    		''Slide ID'',
    		''Slide IDs'',
    		null,
    		null,
    		''integer''
  	);

  	attr_id := content_type__create_attribute (
    		''cr_wp_slide_postamble'',
    		''slide_id'',
    		''integer'',
    		''Slide ID'',
    		''Slide IDs'',
    		null,
    		null,
    		''integer''
  	);

  	attr_id := content_type__create_attribute (
    		''cr_wp_slide_bullet_items'',
    		''slide_id'',
    		''integer'',
    		''Slide ID'',
    		''Slide IDs'',
    		null,
    		null,
    		''integer''
  	);
	return 0;
end;' language 'plpgsql';
select inline_4 ();
drop function inline_4 ();

--jackp: We set the llinks with child types here.
--found in acs-content-repository/sql/postgresql/content-type.sql
create function inline_5 ()
returns integer as'
begin
	PERFORM content_type__register_child_type(''cr_wp_presentation'',''cr_wp_presentation_aud'', ''generic'', 0, null);
 	PERFORM content_type__register_child_type(''cr_wp_presentation'', ''cr_wp_presentation_back'', ''generic'', 0, null);
	PERFORM content_type__register_child_type(''cr_wp_presentation'', ''cr_wp_slide'', ''generic'', 0, null);
	PERFORM content_type__register_child_type(''cr_wp_slide'', ''cr_wp_slide_preamble'', ''generic'', 0, null);
 	PERFORM content_type__register_child_type(''cr_wp_slide'', ''cr_wp_slide_postamble'', ''generic'', 0, null);
 	PERFORM content_type__register_child_type(''cr_wp_slide'', ''cr_wp_slide_bullet_items'', ''generic'', 0, null);
	return 0;
end;' language 'plpgsql';
select inline_5 ();
drop function inline_5 ();

--jackp: Register the content types with the acs-objects
--jackp: found in acs-content-repository/sql/postgresql/content-folder.sql
create function inline_6 ()
returns integer as'
begin
 	PERFORM content_folder__register_content_type(content_item_globals.c_root_folder_id, ''cr_wp_presentation'', ''f'');
 	PERFORM content_folder__register_content_type(content_item_globals.c_root_folder_id, ''cr_wp_presentation_aud'', ''f'');
	PERFORM content_folder__register_content_type(content_item_globals.c_root_folder_id, ''cr_wp_presentation_back'', ''f'');
	PERFORM content_folder__register_content_type(content_item_globals.c_root_folder_id, ''cr_wp_slide'', ''f'');
	PERFORM content_folder__register_content_type(content_item_globals.c_root_folder_id, ''cr_wp_slide_preamble'', ''f'');
	PERFORM content_folder__register_content_type(content_item_globals.c_root_folder_id, ''cr_wp_slide_postamble'', ''f'');
	PERFORM content_folder__register_content_type(content_item_globals.c_root_folder_id, ''cr_wp_slide_bullet_items'', ''f'');
	return 0;
end;' language 'plpgsql';
select inline_6 ();
drop function inline_6 ();

-- DRB: table for file attachments.  Empty but necessary because the object
-- system doesn't allow for simple renaming of types.  Nor can two types
-- share an attribute table.

create table cr_wp_file_attachments (
	attach_id	integer
		        constraint cr_fattach_attach_id_fk
			references cr_revisions
			constraint cr_fattach_attach_id_pk
			primary key
);

create table cr_wp_image_attachments (
	attach_id	integer
		        constraint cr_iattach_attach_id_fk
			references cr_revisions
			constraint cr_iattach_attach_id_pk
			primary key,
        display         varchar(20)
	                constraint cr_iattach_display_ck
			check(display in (
				      'preamble',
				      'bullets', 
				      'postamble', 
				      'top', 
				      'after_preamble', 
				      'after_bullets', 
				      'bottom'))
);

--jackp: p_create the content-type and content-attribute assosciated with
--jackp: attachments
create function inline_7 ()
returns integer as'
declare
  	attr_id            acs_attributes.attribute_id%TYPE;
begin
 	PERFORM content_type__create_type (
		''cr_wp_image_attachment'',
		''image'',
		''Wimpy Image Attachment'',
		''Wimpy Image Attachments'',
		''cr_wp_image_attachments'',
		''attach_id'',
		null 
  	);

 	attr_id := content_type__create_attribute (
	       ''cr_wp_image_attachment'',
	       ''display'',
	       ''text'',
	       ''Where to display'',
	       ''Where display this'',
	       null,		   
	       null,		   
	       ''varchar(20)''
 	);

 	PERFORM content_type__create_type (
		''cr_wp_file_attachment'',
		''content_revision'',
		''Wimpy File Attachment'',
		''Wimpy File Attachments'',
		''cr_wp_file_attachments'',
		''attach_id'',
		null 
  	);

 	attr_id := content_type__create_attribute (
	       ''cr_wp_file_attachment'',
	       ''display'',
	       ''text'',
	       ''Where to display'',
	       ''Where display this'',
	       null,		   
	       null,		   
	       ''varchar(20)''
 	);

	return 0;
end;' language 'plpgsql';
select inline_7 ();
drop function inline_7 ();

--jackp: register the child types for attachments
create function inline_8 ()
returns integer as'
begin
 	PERFORM content_type__register_child_type(
		''cr_wp_slide'',
		''cr_wp_image_attachment'', 
		''generic'', 
		0, 
		null
	);
 	PERFORM content_type__register_child_type(
		''cr_wp_slide'',
		''cr_wp_file_attachment'', 
		''generic'', 
		0, 
		null
	);
	return 0;
end;' language 'plpgsql';
select inline_8 ();
drop function inline_8 ();

--jackp: register the different content types for attachments
--create function inline_9 ()
--returns integer as'
--begin
--  	PERFORM content_folder__register_content_type(
--		content_item_globals.c_root_folder_id, 
--		''cr_wp_attachment'', 
--		''f''
--	);
--	return 0;
--end;' language 'plpgsql';
--select inline_9 ();
--drop function inline_9 ();

commit;

--Define some privileges on the wp_presentation object.
--jackp: found in acs-kernel/sql/postgresql/acs-permissions-create.sql
create function inline_10 ()
returns integer as'
begin
	PERFORM acs_privilege__create_privilege(
		''wp_admin_presentation'', 
		null, 
		null
	);
        
	PERFORM acs_privilege__create_privilege(
		''wp_create_presentation'', 
		null, 
		null
	);
        
	PERFORM acs_privilege__create_privilege(
		''wp_edit_presentation'', 
		null, 
		null
	); 	

        PERFORM acs_privilege__create_privilege(
		''wp_delete_presentation'', 
		null, 
		null
	);
        
	PERFORM acs_privilege__create_privilege(
		''wp_view_presentation'', 
		null, 
		null
	);

	return 0;
end;' language 'plpgsql';
select inline_10 ();
drop function inline_10 ();


--jackp: set the permissions applicable to the package
create function inline_11 ()
returns integer as'
declare
    	default_context acs_objects.object_id%TYPE;
    	registered_users acs_objects.object_id%TYPE;
    	the_public acs_objects.object_id%TYPE;
begin
    	default_context := acs__magic_object_id(''default_context'');
    	registered_users := acs__magic_object_id(''registered_users'');
--    	the_public := acs__magic_object_id(''the_public'');

    	PERFORM acs_permission__grant_permission(
		default_context, 
		registered_users, 
		''wp_create_presentation''
	);

--	this commented out because permission, with this any user could see an slide that has not become public!
--    	PERFORM acs_permission__grant_permission(
--		default_context, 
--		the_public, 
--		''wp_view_presentation''
--	);
	return 0;
end;' language 'plpgsql';
select inline_11 ();
drop function inline_11 ();

-- new permissions roc@
select acs_privilege__add_child('wp_edit_presentation', 'wp_view_presentation');
select acs_privilege__add_child('wp_admin_presentation', 'wp_create_presentation');
select acs_privilege__add_child('wp_admin_presentation', 'wp_edit_presentation');
select acs_privilege__add_child('wp_admin_presentation', 'wp_delete_presentation');

-- lets give site-wide permissions, wp-permissions! 
select acs_privilege__add_child('admin', 'wp_admin_presentation');


