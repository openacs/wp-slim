
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

insert into cr_mime_types (mime_type) 
select 'application/octet-stream'
from dual
where not exists (select 1 from cr_mime_types where mime_type ='application/octet-stream');

--jackp: Create the different styles 
create table wp_styles (
	style_id		integer 
                                constraint wp_styles_style_id_pk
                                primary key,
	name			varchar(400) 
                                constraint wp_styles_name_nn
                                not null,
	css			varchar(4000),
	text_color		varchar(20) check(text_color like '%,%,%'),
	background_color	varchar(20) check(background_color like '%,%,%'),
	background_image	varchar(200),
	link_color		varchar(20) check(link_color like '%,%,%'),
	alink_color		varchar(20) check(alink_color like '%,%,%'),
	vlink_color		varchar(20) check(vlink_color like '%,%,%')
);

insert into wp_styles(style_id, name, css)
values(-1, 'Default (Plain)',
       'BODY { back-color: white; color: black } P { line-height: 120% } UL { line-height: 140% }');

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
				check(show_modified_p in ('t','f'))
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
    	the_public := acs__magic_object_id(''the_public'');

    	PERFORM acs_permission__grant_permission(
		default_context, 
		registered_users, 
		''wp_create_presentation''
	);

    	PERFORM acs_permission__grant_permission(
		default_context, 
		the_public, 
		''wp_view_presentation''
	);
	return 0;
end;' language 'plpgsql';
select inline_11 ();
drop function inline_11 ();

--jackp: From here on the functions are defined

--jackp: To p_create each presentation
create function wp_presentation__new (
	timestamp,
	integer,
	varchar(400),
	varchar(400),	
	varchar(400),	
	varchar,	
	integer,	
	boolean,
	boolean,
	varchar,
	varchar,
	integer
) 
returns integer as'     
declare
	p_creation_date	      	alias for $1;
	p_creation_user	      	alias for $2;
	p_creation_ip	      	alias for $3;
	p_pres_title	      	alias for $4;
	p_page_signature	alias for $5;
	p_copyright_notice      alias for $6;
	p_style		      	alias for $7;
	p_public_p	      	alias for $8;
	p_show_modified_p      	alias for $9;
	aud	      	alias for $10;
	back	      	alias for $11;
	p_parent_id		alias for $12;
	v_item_id               cr_items.item_id%TYPE;
    	v_audience_item_id	cr_items.item_id%TYPE;
    	v_background_item_id	cr_items.item_id%TYPE;
    	v_revision_id		cr_revisions.revision_id%TYPE;
    	v_audience_revision_id	cr_revisions.revision_id%TYPE;
    	v_background_revision_id cr_revisions.revision_id%TYPE;
    	v_max_id                integer;
    	v_name                  cr_wp_presentations.pres_title%TYPE;
begin 
    select coalesce(max(item_id),0) into v_max_id
    from cr_items
    where content_type = ''cr_wp_presentation''
    and   name like p_pres_title || ''%'';
    
    v_name := p_pres_title || ''_'' || v_max_id;

    v_item_id := content_item__new( 
      v_name,
      p_parent_id,
      null,
      null,
      p_creation_date,
      p_creation_user,
      null,
      p_creation_ip,
      ''content_item'',
      ''cr_wp_presentation'',
       null,
       null,
       ''text/plain'',
       null,
       null,
       ''text''
    );

    v_revision_id := content_revision__new(
      null,
      null,
      current_timestamp,
      ''text/plain'',
      null,
      null,
      v_item_id,
      null,
      p_creation_date,
      p_creation_user,
      p_creation_ip
    );
    
    PERFORM content_item__set_live_revision(v_revision_id);

--jackp: Actually place the information entered by the user into the table
    insert into cr_wp_presentations
    (
	presentation_id,
	pres_title,
    	page_signature,
    	copyright_notice,
    	style,
    	public_p,
    	show_modified_p
    ) values (
    	v_revision_id,
    	p_pres_title,
    	p_page_signature,
    	p_copyright_notice,
    	p_style,
    	p_public_p,
    	p_show_modified_p
    );
   
    v_audience_item_id := content_item__new(    
      aud,
      v_item_id,
      null,
      null,
      p_creation_date,
      p_creation_user,
      null,
      p_creation_ip,
      ''content_item'',
      ''cr_wp_presentation_aud'',
       null,
       null,
       ''text/plain'',
       null,
       null,
       ''text''
    );

    v_audience_revision_id := content_revision__new(
      null,
      null,
      current_timestamp,
      ''text/plain'',
      null,
      aud,
      v_audience_item_id,
      null,
      p_creation_date,
      p_creation_user,
      p_creation_ip
     );
    
    PERFORM content_item__set_live_revision(v_audience_revision_id);
      
    insert into cr_wp_presentations_aud
    (
    	id,
    	presentation_id
    ) values (
    	v_audience_revision_id,
   	v_revision_id
    );
    
    v_background_item_id := content_item__new(
      back,
      v_item_id,
      null,
      null,
      p_creation_date,
      p_creation_user,
      null,
      p_creation_ip,
      ''content_item'',
      ''cr_wp_presentation_back'',
       null,
       null,
       ''text/plain'',
       null,
       null,
       ''text''
    );
    
    v_background_revision_id := content_revision__new(
      null,
      null,
      current_timestamp,
      ''text/plain'',
      null,
      back,
      v_background_item_id,
      null,
      p_creation_date,
      p_creation_user,
      p_creation_ip
    );
    
    PERFORM content_item__set_live_revision(v_background_revision_id);
     
    insert into cr_wp_presentations_back
    (
    	id,
    	presentation_id
    ) values (
    	v_background_revision_id,
    	v_revision_id
    );
    
    return v_item_id;
end;' language 'plpgsql';
        
create function wp_presentation__delete_audience (
	integer		 
)
returns integer as'
declare
	audience_item_id	alias $1;
begin
    delete from cr_wp_presentations_aud
    where exists (select 1 from cr_revisions where revision_id = cr_wp_presentations_aud.id and item_id = audience_item_id);     
    delete from cr_item_publish_audit
    where item_id = audience_item_id;
     
    content_item__delete(audience_item_id);
return 0;
end;' language 'plpgsql';

create function wp_presentation__delete_background (
	integer		 
)
returns integer as'
declare
	background_item_id	alias $1;
begin
    delete from cr_wp_presentations_back
    where exists (select 1 from cr_revisions where revision_id = cr_wp_presentations_back.id and item_id = background_item_id);  
    delete from cr_item_publish_audit
    where item_id = background_item_id;
    
    content_item__delete(background_item_id);
    return 0;
end;' language 'plpgsql';

create function wp_presentation__delete (
	integer		
)
returns integer as'
declare
    pres_item_id		alias $1;
    v_audience_item_id		cr_items.item_id%TYPE;
    v_background_item_id	cr_items.item_id%TYPE;
    del_rec record;
begin
    for del_rec in select item_id as slide_item_id
    from cr_items
    where content_type = ''cr_wp_slide''
    and   parent_id = pres_item_id 
    loop 
       wp_slide__delete(del_rec.slide_item_id);
    end loop;
    
    select item_id into v_audience_item_id
    from cr_items
    where content_type = ''cr_wp_presentation_aud''
    and   parent_id = pres_item_id;
    
    delete_aud(v_audience_item_id);
    
    select item_id into v_background_item_id
    from cr_items
    where content_type = ''cr_wp_presentation_back''
    and   parent_id = pres_item_id;
    
    delete_back(v_background_item_id);
    
    delete from acs_permissions where object_id = pres_item_id;
    update acs_objects set context_id=null where context_id = pres_item_id;
    delete from cr_wp_presentations where exists (select 1 from cr_revisions where cr_revisions__revision_id = cr_wp_presentations__presentation_id and cr_revisions.item_id = pres_item_id);    
    content_item__delete(pres_item_id);
return 0;
end;' language 'plpgsql';

-- DRB: All these could've been implemented as a single function with a type argument
-- but I'm not going to rewrite all of wp-slim's queries just to clean this up...

create function wp_presentation__get_ad_revision (integer) returns text as '
declare
    p_pres_revision_id	alias for $1;
begin
  return r.content
  from cr_revisions r,
    cr_wp_presentations_aud pa
  where pa.presentation_id = p_pres_revision_id
    and r.revision_id = pa.id;
end;' language 'plpgsql';

create function wp_presentation__get_audience (
	integer		
) returns text as'
declare
    p_pres_item_id	alias for $1;
begin
    return content
    from cr_revisions, cr_items
    where cr_items.content_type = ''cr_wp_presentation_aud''
    and cr_items.parent_id = p_pres_item_id
    and cr_revisions.revision_id = cr_items__live_revision;
end;' language 'plpgsql';

create function wp_presentation__get_bg_revision (integer) returns text as '
declare
    p_pres_revision_id	alias for $1;
begin
  return r.content
  from cr_revisions r,
    cr_wp_presentations_aud pa
  where pa.presentation_id = p_pres_revision_id
    and r.revision_id = pa.id;
end;' language 'plpgsql';

create function wp_presentation__get_background (
    integer	
) returns text as'
declare 
    pres_item_id	alias for $1;
begin
    return content
    from cr_revisions, cr_items
    where cr_items.content_type = ''cr_wp_presentation_bak''
    and cr_items.parent_id = p_pres_item_id
    and cr_revisions.revision_id = cr_items__live_revision;
end;' language 'plpgsql';
   

create function wp_presentation__new_revision (
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
    varchar
) returns integer as' 
declare
    p_creation_date	alias for $1;
    p_creation_user	alias for $2;
    p_creation_ip	alias for $3;
    p_pres_item_id	alias for $4;
    p_pres_title	alias for $5;
    p_page_signature	alias for $6;
    p_copyright_notice	alias for $7;
    p_style		alias for $8;
    p_public_p		alias for $9;
    p_show_modified_p	alias for $10;
    p_audience		alias for $11;
    p_background	alias for $12;
    v_audience_item_id          cr_items.item_id%TYPE;
    v_background_item_id        cr_items.item_id%TYPE;
    v_revision_id               cr_revisions.revision_id%TYPE;
    v_audience_revision_id      cr_revisions.revision_id%TYPE;
    v_background_revision_id    cr_revisions.revision_id%TYPE;
begin
    v_revision_id := content_revision__new(
      null,
      null,
      current_timestamp,
      ''text/plain'',
      null,
      null,
      p_pres_item_id,
      null,
      p_creation_date,
      p_creation_user,
      p_creation_ip
    );

    PERFORM content_item__set_live_revision(v_revision_id);
       
    insert into cr_wp_presentations
    (
     	presentation_id,
    	pres_title,
    	page_signature,
    	copyright_notice,
    	style,
    	public_p,
    	show_modified_p
    ) values ( 
     	v_revision_id,
    	p_pres_title,
    	p_page_signature,
   	p_copyright_notice,
    	p_style,
    	p_public_p,
    	p_show_modified_p
    );
   
    select item_id into v_audience_item_id
    from cr_items
    where parent_id = p_pres_item_id
    and   content_type = ''cr_wp_presentation_aud'';
    
    v_audience_revision_id := content_revision__new(
      null,
      null,
      current_timestamp,
      ''text/plain'',
      null,
      p_audience,
      v_audience_item_id,
      null,
      p_creation_date,
      p_creation_user,
      p_creation_ip
    );
    
    PERFORM content_item__set_live_revision(v_audience_revision_id);
        
    insert into cr_wp_presentations_aud
    (
    	id,
    	presentation_id
    ) values (
    	v_audience_revision_id,
    	v_revision_id
    );
    
    select item_id into v_background_item_id
    from cr_items
    where parent_id = p_pres_item_id   
    and   content_type = ''cr_wp_presentation_back'';
        
    v_background_revision_id := content_revision__new(
      null,
      null,
      current_timestamp,
      ''text/plain'',
      null,
      p_background,
      v_background_item_id,
      null,
      p_creation_date,
      p_creation_user,
      p_creation_ip
    );
    
    PERFORM content_item__set_live_revision(v_background_revision_id);
    
    insert into cr_wp_presentations_back 
    (
    	id,
    	presentation_id
    ) values (
    	v_background_revision_id,
    	v_revision_id
    );
    return 0;
end;' language 'plpgsql';

create function wp_slide__new (
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
) returns integer as'
declare
    p_pres_item_id           alias for $1; 
    p_creation_date          alias for $2; 
    p_creation_user          alias for $3; 
    p_creation_ip            alias for $4; 
    p_slide_title            alias for $5;
    p_style                  alias for $6;
    p_original_slide_id      alias for $7;
    p_sort_key               alias for $8;
    p_preamble               alias for $9;
    p_bullet_items           alias for $10;
    p_postamble              alias for $11;
    p_include_in_outline_p   alias for $12;
    p_context_break_after_p  alias for $13;
    p_context_id             alias for $14;
    v_item_id                   cr_items.item_id%TYPE;
    v_preamble_item_id          cr_items.item_id%TYPE;
    v_postamble_item_id         cr_items.item_id%TYPE;
    v_bullet_items_item_id      cr_items.item_id%TYPE;
    v_revision_id               cr_revisions.revision_id%TYPE;
    v_preamble_revision_id      cr_revisions.revision_id%TYPE;
    v_postamble_revision_id     cr_revisions.revision_id%TYPE;
    v_bullet_items_revision_id  cr_revisions.revision_id%TYPE;
    v_max_id                    integer;
    v_name                      varchar;
begin
    select coalesce(max(item_id),0) into v_max_id
    from cr_items
    where content_type = ''cr_wp_slide''
    and   name like p_slide_title || ''%'';
    
    v_name := p_slide_title || ''_'' || v_max_id;
  
    v_item_id := content_item__new(
      v_name,
      p_pres_item_id,
      null,
      null,
      p_creation_date,
      p_creation_user,
      null,
      p_creation_ip,
      ''content_item'',
      ''cr_wp_slide'',      
      null,
      null,
      ''text/plain'',
      null,
      null,
      ''text''
    );

    v_revision_id := content_revision__new(
      null,
      null, 
      current_timestamp,
      ''text/plain'', 
      null, 
      null,
      v_item_id,
      null,
      p_creation_date,
      p_creation_user,
      p_creation_ip          
    );
      
    PERFORM content_item__set_live_revision(v_revision_id);

    update cr_wp_slides
    set sort_key = p_sort_key + 1
    where sort_key >= p_sort_key
    and  exists (select 1 from cr_items, cr_revisions where parent_id =
      p_pres_item_id and cr_items.item_id = cr_revisions.item_id 
    and cr_revisions.revision_id=cr_wp_slides.slide_id);
        
    insert into cr_wp_slides
    ( 
    	slide_id,
    	original_slide_id,
    	sort_key,
    	slide_title,
   	 include_in_outline_p,
    	context_break_after_p,
    	style  
    ) values ( 
    	v_revision_id,
    	p_original_slide_id,
    	p_sort_key,
    	p_slide_title,
    	p_include_in_outline_p,
    	p_context_break_after_p,
    	p_style
    );  
    
    v_preamble_item_id := content_item__new(
      ''preamble'',
      v_item_id,
      null,
      null,
      p_creation_date,
      p_creation_user,
      null,
      p_creation_ip,
      ''content_item'',
      ''cr_wp_slide_preamble'',
      null,
      null,
      ''text/plain'',
      null,
      null,
      ''text''
    );  

    v_preamble_revision_id := content_revision__new(
      null,
      null, 
      current_timestamp,
      ''text/plain'', 
      null, 
      p_preamble,
      v_preamble_item_id,
      null,
      p_creation_date,
      p_creation_user,
      p_creation_ip          
    );
    
    PERFORM content_item__set_live_revision(v_preamble_revision_id);

    insert into cr_wp_slides_preamble
    (
    	id,
    	slide_id
    ) values (
    	v_preamble_revision_id,
    	v_revision_id
    );

    v_postamble_item_id := content_item__new(
      ''postamble'',
      v_item_id,
      null,
      null,
      p_creation_date,
      p_creation_user,
      null,
      p_creation_ip,
      ''content_item'',
      ''cr_wp_slide_postamble'',
      null,
      null,
      ''text/plain'',
      null,
      null,
      ''text''      
    );


    v_postamble_revision_id := content_revision__new(
      null,
      null, 
      current_timestamp,
      ''text/plain'', 
      null, 
      p_postamble,
      v_postamble_item_id,
      null,
      p_creation_date,
      p_creation_user,
      p_creation_ip          
    );

    PERFORM content_item__set_live_revision(v_postamble_revision_id);
    
    insert into cr_wp_slides_postamble
    (
    	id,
    	slide_id
    ) values ( 
    	v_postamble_revision_id,
    	v_revision_id
    );

    v_bullet_items_item_id := content_item__new(
      ''bullet_items'',
      v_item_id,
      null,
      null,
      p_creation_date,
      p_creation_user,
      null,
      p_creation_ip,
      ''content_item'',
      ''cr_wp_slide_bullet_items'',
      null,
      null,
      null,
      ''text/plain'',
      null,  
      ''text''      
    );


    v_bullet_items_revision_id := content_revision__new(
      null,
      null, 
      current_timestamp,
      ''text/plain'', 
      null, 
      p_bullet_items,
      v_bullet_items_item_id,
      null,
      p_creation_date,
      p_creation_user,
      p_creation_ip          
    );

    PERFORM content_item__set_live_revision(v_bullet_items_revision_id);

    insert into cr_wp_slides_bullet_items
    (
    	id,
    	slide_id
    ) values (
 	v_bullet_items_revision_id,
    	v_revision_id
    );
    return v_item_id;
end;' language 'plpgsql';

create function wp_slide__delete_preamble (
    integer
) returns integer as'
declare
    delete_preamble__preamble_item_id         alias for $1;
begin 
    delete from cr_wp_slides_preamble
    where exists (select 1 from cr_revisions where revision_id = cr_wp_slides_preamble.id 
                  and item_id = delete_preamble__preamble_item_id);    
    
    delete from cr_item_publish_audit
    where item_id = delete_preamble__preamble_item_id;

    PERFORM content_item__delete(delete_preamble__preamble_item_id);
    return 0;
end;' language 'plpgsql'; 

create function wp_slide__delete_postamble(
    integer
) returns integer as'
declare
    delete_postamble__postamble_item_id          alias for $1;
begin
    delete from cr_wp_slides_postamble
    where exists (select 1 from cr_revisions where revision_id =
    cr_wp_slides_postamble.id 
    and item_id = delete_postamble__postamble_item_id);
    
    delete from cr_item_publish_audit
    where item_id = delete_postamble__postamble_item_id;
  
    PERFORM content_item__delete(delete_postamble__postamble_item_id);
    return 0;
end;' language 'plpgsql';

create function wp_slide__delete_bullet_items(
    integer
) returns integer as'
declare
    delete_bullet_items__bullet_items_item_id            alias for $1;
begin 
    delete from cr_wp_slides_bullet_items
    where exists (select 1 from cr_revisions where revision_id =
    cr_wp_slides_bullet_items.id 
    and item_id = delete_bullet_items__bullet_items_item_id);
    
    delete from cr_item_publish_audit
    where item_id = delete_bullet_items__bullet_items_item_id;

    PERFORM content_item__delete(delete_bullet_items__bullet_items_item_id);
    return 0;
end;' language 'plpgsql';

create function wp_slide__delete(
    integer
) returns integer as'
declare
    del_rec record;
    delete__slide_item_id            alias for $1;
    v_sort_key                       cr_wp_slides.sort_key%TYPE;
    v_pres_item_id                   cr_items.item_id%TYPE;
    v_preamble_item_id               cr_items.item_id%TYPE;
    v_postamble_item_id              cr_items.item_id%TYPE;
    v_bullet_items_item_id           cr_items.item_id%TYPE;
begin
    for del_rec in select item_id as attach_item_id
    from cr_items
    where content_type in (''cr_wp_image_attachment'', ''cr_wp_file_attachment'')
    and   parent_id = delete__slide_item_id
    loop
     wp_attachment__delete(del_rec.attach_item_id);
    end loop;

    select item_id into v_preamble_item_id
    from cr_items
    where content_type = ''cr_wp_slide_preamble''
    and   parent_id = delete__slide_item_id;
    
    PERFORM wp_slide__delete_preamble(v_preamble_item_id);
    
    select item_id into v_postamble_item_id
    from cr_items
    where content_type = ''cr_wp_slide_postamble''
    and   parent_id = delete__slide_item_id;

    PERFORM wp_slide__delete_postamble(v_postamble_item_id);
    
    select item_id into v_bullet_items_item_id
    from cr_items
    where content_type = ''cr_wp_slide_bullet_items''
    and   parent_id = delete__slide_item_id;
    
    PERFORM wp_slide__delete_bullet_items(v_bullet_items_item_id);

    -- sort_key of all revisions should be the same
    select max(s.sort_key), max(i.parent_id) into v_sort_key,
      v_pres_item_id
    from cr_wp_slides s, cr_revisions r, cr_items i
    where r.item_id = delete__slide_item_id
    and   r.revision_id = s.slide_id
    and   i.item_id = r.item_id;
    
    delete from cr_wp_slides where exists (select 1 from cr_revisions
    where cr_revisions.revision_id = cr_wp_slides.slide_id 
    and cr_revisions.item_id = delete__slide_item_id);

    update cr_wp_slides set sort_key = sort_key - 1 
    where sort_key > v_sort_key and exists 
      (select 1 from cr_revisions r, cr_items i 
      where i.parent_id = v_pres_item_id and i.item_id = r.item_id
      and r.revision_id = cr_wp_slides.slide_id);    

    update acs_objects set context_id = ''''
    where context_id = delete__slide_item_id;

    delete from cr_item_publish_audit where item_id = delete__slide_item_id;

    PERFORM content_item__delete(delete__slide_item_id);

    return 0;
end;' language 'plpgsql';

create function wp_slide__get_preamble_revision (
    integer
) returns text as '
declare
  p_slide_revision_id alias for $1;
begin
  return content
  from cr_revisions r, cr_wp_slides_preamble sp
  where sp.slide_id = p_slide_revision_id
  and r.revision_id = sp.id;
end;' language 'plpgsql';

create function wp_slide__get_postamble_revision (
    integer
) returns text as '
declare
  p_slide_revision_id alias for $1;
begin
  return content
  from cr_revisions r, cr_wp_slides_postamble sp
  where sp.slide_id = p_slide_revision_id
  and r.revision_id = sp.id;
end;' language 'plpgsql';

create function wp_slide__get_bullet_items_revision (
    integer
) returns text as '
declare
  p_slide_revision_id alias for $1;
begin
  return content
  from cr_revisions r, cr_wp_slides_bullet_items sp
  where sp.slide_id = p_slide_revision_id
  and r.revision_id = sp.id;
end;' language 'plpgsql';

create function wp_slide__get_postamble(
    integer
) returns text as '
declare
    p_slide_item_id	alias for $1;
begin
    return content
    from cr_revisions, cr_items
    where cr_items.content_type = ''cr_wp_slide_postamble''
    and cr_items.parent_id = p_slide_item_id
    and cr_revisions.revision_id = cr_items.live_revision;
end;' language 'plpgsql';

create function wp_slide__get_preamble(
    integer
) returns text as'
declare
    p_slide_item_id                alias for $1;
begin
    return content
    from cr_revisions, cr_items
    where cr_items.content_type = ''cr_wp_slide_preamble''
    and cr_items.parent_id = p_slide_item_id
    and cr_revisions.revision_id = cr_items.live_revision;
end;' language 'plpgsql';

create function wp_slide__get_bullet_items(
    integer
) returns text as'
declare
    p_slide_item_id	alias for $1;
begin
    return content
    from cr_revisions, cr_items
    where cr_items.content_type = ''cr_wp_slide_bullet_items''
    and cr_items.parent_id = p_slide_item_id
    and cr_revisions.revision_id = cr_items.live_revision;
end;' language 'plpgsql';

create function wp_slide__new_revision(
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
    boolean
) returns integer as'
declare
    p_creation_date                  alias for $1;  
    p_creation_user                  alias for $2;
    p_creation_ip                    alias for $3;
    p_slide_item_id                  alias for $4;
    p_slide_title                    alias for $5;
    p_preamble                       alias for $6;
    p_bullet_items                   alias for $7;
    p_postamble                      alias for $8;
    p_style                          alias for $9;
    p_original_slide_id              alias for $10;
    p_sort_key                       alias for $11;    
    p_include_in_outline_p           alias for $12;
    p_context_break_after_p          alias for $13;
    v_preamble_item_id          cr_items.item_id%TYPE;
    v_postamble_item_id         cr_items.item_id%TYPE;
    v_bullet_items_item_id      cr_items.item_id%TYPE;
    v_revision_id               cr_revisions.revision_id%TYPE;
    v_preamble_revision_id      cr_revisions.revision_id%TYPE;
    v_postamble_revision_id     cr_revisions.revision_id%TYPE;
    v_bullet_items_revision_id  cr_revisions.revision_id%TYPE;
begin
    v_revision_id := content_revision__new(
      null,
      null,
      current_timestamp,
      ''text/plain'',
      null,
      null,
      p_slide_item_id,
      null,
      p_creation_date,
      p_creation_user,
      p_creation_ip
    );

    PERFORM content_item__set_live_revision(v_revision_id);
    
    insert into cr_wp_slides
    (
     	slide_id,
    	slide_title,
    	style,
    	original_slide_id,
	sort_key,
    	include_in_outline_p,
    	context_break_after_p
    ) values (
	v_revision_id,
    	p_slide_title,
    	p_style,
    	p_original_slide_id,
    	p_sort_key,
    	p_include_in_outline_p,
    	p_context_break_after_p 
    );

    select item_id into v_preamble_item_id
    from cr_items
    where parent_id = p_slide_item_id
    and   content_type = ''cr_wp_slide_preamble'';
    
    v_preamble_revision_id := content_revision__new(
      null,
      null,
      current_timestamp,
      ''text/plain'',
      null,
      p_preamble,
      v_preamble_item_id,
      null,
      p_creation_date,
      p_creation_user,
      p_creation_ip
    );
          
    PERFORM content_item__set_live_revision(v_preamble_revision_id);

    insert into cr_wp_slides_preamble
    (
    	id,
    	slide_id
    ) values (
    	v_preamble_revision_id,
    	v_revision_id
    );

    select item_id into v_postamble_item_id
    from cr_items
    where parent_id = p_slide_item_id
    and   content_type = ''cr_wp_slide_postamble'';

    v_postamble_revision_id := content_revision__new(
      null,
      null,
      current_timestamp,
      ''text/plain'',
      null,
      p_postamble,
      v_postamble_item_id,
      null,
      p_creation_date,
      p_creation_user,
      p_creation_ip
    );

    PERFORM content_item__set_live_revision(v_postamble_revision_id);
      
    insert into cr_wp_slides_postamble
    (
    	id,
    	slide_id
    ) values (
    	v_postamble_revision_id,
    	v_revision_id
    );

    select item_id into v_bullet_items_item_id
    from cr_items
    where parent_id = p_slide_item_id
    and   content_type = ''cr_wp_slide_bullet_items'';
 
    v_bullet_items_revision_id := content_revision__new(
      null,
      null,
      current_timestamp,
      ''text/plain'',
      null,
      p_bullet_items,
      v_bullet_items_item_id,
      null,
      p_creation_date,
      p_creation_user,
      p_creation_ip
    );

    PERFORM content_item__set_live_revision(v_bullet_items_revision_id); 

    insert into cr_wp_slides_bullet_items
    (
    	id,
    	slide_id
    ) values ( 
   	v_bullet_items_revision_id,
    	v_revision_id
    );
    return 0;
end;' language 'plpgsql';

create function wp_attachment__delete(
    integer
) returns integer as'
declare 
    p_attach_item_id		alias for $1;
begin
    delete from cr_wp_file_attachments
    where exists (select 1 from cr_revisions where revision_id 
      = cr_wp_file_attachments.attach_id 
      and item_id = p_attach_item_id);
    
    delete from cr_wp_image_attachments
    where exists (select 1 from cr_revisions where revision_id 
      = cr_wp_image_attachments.attach_id 
      and item_id = p_attach_item_id);
    
    delete from cr_item_publish_audit
    where item_id = p_attach_item_id;

    PERFORM content_item__delete(p_attach_item_id);
    return 0;
end;' language 'plpgsql';

create function wp_attachment__new_revision (
    integer
) returns integer as'
declare
    p_attach_item_id		alias for $1;
begin
    return 0;
end; 'language 'plpgsql';

create function wp_presentation__set_live_revision(integer) returns integer as '
declare
  p_revision_id    alias for $1;
  v_revision_id    integer;
begin
  perform content_item__set_live_revision(p_revision_id);

  select id into v_revision_id
  from cr_wp_presentations_aud
  where presentation_id = p_revision_id;
      
  perform content_item__set_live_revision(v_revision_id);

  select id into v_revision_id
  from cr_wp_presentations_back
  where presentation_id = p_revision_id;

  perform content_item__set_live_revision(v_revision_id);
  return 0;
end;' language 'plpgsql';


