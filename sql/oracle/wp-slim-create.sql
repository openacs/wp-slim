-- Wimpy Point Data Model for ACS 4.0
-- 
-- Paul Konigsberg paulk@arsdigita.com 10/22/00
--    original module author Jon Salz jsalz@mit.edu


-- Notes: 

-- Nothing is going into the content repository. 
-- Reasons for putting stuff in the repository:
-- You get versioning. You get indexed for intermedia searching.
-- Things that should go into the repository are:
-- 1. Presentations: You should be able to version a presentation. When you 
-- do, you should remember the current versions of all the slides in it.
-- 2. Slides.
-- 3. Attachments - since the repository is supposed to be good 
--    at handling weird lob data. (i.e. handling the mime type and
--    serving it back.

-- More on content repository: After Jesse Koontz's review, he said:
-- presentation -- subclass from content_items
-- slides -- subclass from content_items
-- Versions: are copied presentations

-- Clobs are mostly not used. Instead varchar(4000) is still being used
-- because working with clobs is tough in plsql. This needs to change.
-- Presentations have no context_id....should they? Answer: Yes their context id should
-- point to the package_id of the instance of this wimpy point. 
-- (There could be multiple instances.)



-- Only the basic -1 is implemented right now.
-- Styles for presentations. We'll think more about this later if there's time -
-- maybe allow ADPs for more flexibility.

insert into cr_mime_types (label, mime_type) 
select 'Binary data', 'application/octet-stream'
from dual
where not exists (select 1 from cr_mime_types where mime_type = 'application/octet-stream');


create sequence wp_style_seq;

create table wp_styles (
	style_id		integer 
                                constraint wp_styles_style_id_pk
                                primary key,
	name			varchar2(400) 
                                constraint wp_styles_name_nn
                                not null,
	css			varchar(4000),
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



create table cr_wp_presentations (
	presentation_id		integer
				constraint cr_wp_presentations_id_fk
                                references cr_revisions
                                constraint cr_wp_presentations_pk
                                primary key,
	-- The title of the presentation, as displayed to the user.
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
	public_p	        char(1) default 'f'
				constraint cr_wp_public_p_ck
				check(public_p in ('t','f')),
	-- Show last-modified date for slides?
	show_modified_p         char(1) default 'f'
				constraint cr_wp_show_p_ck
				check(show_modified_p in ('t','f')),
	show_comments_p		char(1) default 'f' 
				constraint cr_wp_pres_show_comments_p 
				check(show_comments_p in ('t','f'))
);


-- Slides belonging to presentations. 
create table cr_wp_slides (
	slide_id		integer
				constraint cr_wp_slides_slide_id_fk
                                references cr_revisions
                                constraint cr_wp_slides_slide_id_pk
                                primary key,
	-- The slide_id which this was branched from. Used to preserve comments across
	-- versions.
	original_slide_id	integer,
	sort_key		numeric 
                                constraint cr_wp_slides_sort_key_nn
                                not null,
	slide_title		varchar2(400)
				constraint cr_wp_slides_title_nn
				not null,
	-- preamble		varchar(4000),
	-- Store bullet items in a Tcl list.
	-- bullet_items		varchar(4000),
	-- postamble		varchar(4000),
	include_in_outline_p	char(1) default 't'
				constraint cr_wp_slides_incld_ck
				check(include_in_outline_p in ('t','f')),
	context_break_after_p	char(1) default 'f'
				constraint cr_wp_slides_context_ck
				check(context_break_after_p in ('t','f')),
	-- Can override the style setting for the presentation.
	style			constraint cr_wp_slides_style_fk
                                references wp_styles
);

create table cr_wp_presentations_aud (
	id 		references cr_revisions,
	presentation_id	integer
			constraint cr_wp_paudience_pid_nn
			not null
			constraint cr_wp_paudience_pid_fk
                       	references cr_wp_presentations
);

create table cr_wp_presentations_back (
	id 		references cr_revisions,
	presentation_id	integer
			constraint cr_wp_pbackground_pid_nn
			not null
			constraint cr_wp_pbackground_pid_fk
                       	references cr_wp_presentations
);

create table cr_wp_slides_preamble (
	id 		references cr_revisions,
	slide_id	integer
			constraint cr_wp_spreamble_sid_nn
			not null
			constraint cr_wp_spreamble_sid_fk
                       	references cr_wp_slides
);

create table cr_wp_slides_postamble (
	id 		references cr_revisions,
	slide_id	integer
			constraint cr_wp_spostamble_sid_nn
			not null
			constraint cr_wp_spostamble_sid_fk
                       	references cr_wp_slides
);

create table cr_wp_slides_bullet_items (
	id 		references cr_revisions,
	slide_id	integer
			constraint cr_wp_sbullet_sid_nn
			not null
			constraint cr_wp_sbullet_sid_fk
                       	references cr_wp_slides
);


begin
  content_type.create_type (
    content_type  => 'cr_wp_presentation_aud',
    pretty_name   => 'WimpyPoint Presentation Audience',
    pretty_plural => 'WimpyPoint Presentation Audience',
    table_name    => 'cr_wp_presentations_aud',
    id_column     => 'id'
  );

  content_type.create_type (
    content_type  => 'cr_wp_presentation_back',
    pretty_name   => 'WimpyPoint Presentation Background',
    pretty_plural => 'WimpyPoint Presentation Background',
    table_name    => 'cr_wp_presentations_back',
    id_column     => 'id'
  );


  content_type.create_type (
    content_type  => 'cr_wp_presentation',
    pretty_name   => 'WimpyPoint Presentation',
    pretty_plural => 'WimpyPoint Presentations',
    table_name    => 'cr_wp_presentations',
    id_column     => 'presentation_id'
  );
end;
/
show errors


begin
  content_type.create_type (
    content_type  => 'cr_wp_slide_preamble',
    pretty_name   => 'WimpyPoint Slide Preamble',
    pretty_plural => 'WimpyPoint Slide Preamble',
    table_name    => 'cr_wp_slides_preamble',
    id_column     => 'id'
  );

  content_type.create_type (
    content_type  => 'cr_wp_slide_postamble',
    pretty_name   => 'WimpyPoint Slide Postamble',
    pretty_plural => 'WimpyPoint Slide Postamble',
    table_name    => 'cr_wp_slides_postamble',
    id_column     => 'id'
  );
  
  content_type.create_type (
    content_type  => 'cr_wp_slide_bullet_items',
    pretty_name   => 'WimpyPoint Slide Bullet Items',
    pretty_plural => 'WimpyPoint Slide Bullet Items',
    table_name    => 'cr_wp_slides_bullet_items',
    id_column     => 'id'
  );


  content_type.create_type (
    content_type  => 'cr_wp_slide',
    pretty_name   => 'WimpyPoint Slide',
    pretty_plural => 'WimpyPoint Slides',
    table_name    => 'cr_wp_slides',
    id_column     => 'slide_id'
  );
end;
/
show errors

declare
  attr_id        acs_attributes.attribute_id%TYPE;
begin

  attr_id := content_type.create_attribute (
    content_type   => 'cr_wp_presentation',
    attribute_name => 'pres_title',
    datatype       => 'text',
    pretty_name    => 'Presentation Title',
    pretty_plural  => 'Presentation Titles',
    column_spec    => 'varchar2(400)'
  );
  
  attr_id := content_type.create_attribute (
    content_type   => 'cr_wp_presentation',
    attribute_name => 'page_signature',
    datatype       => 'text',
    pretty_name    => 'Page Signature',
    pretty_plural  => 'Page Signatures',
    column_spec    => 'varchar2(200)'
  );

  attr_id := content_type.create_attribute (
    content_type   => 'cr_wp_presentation',
    attribute_name => 'copyright_notice',
    datatype       => 'text',
    pretty_name    => 'Copyright Notice',
    pretty_plural  => 'Copyright Notices',
    column_spec    => 'varchar2(400)'
  );

  attr_id := content_type.create_attribute (
    content_type   => 'cr_wp_presentation',
    attribute_name => 'style',
    datatype       => 'integer',
    pretty_name    => 'Style',
    pretty_plural  => 'Styles',
    column_spec    => 'integer'
  );

  attr_id := content_type.create_attribute (
    content_type   => 'cr_wp_presentation',
    attribute_name => 'public_p',
    datatype       => 'boolean',
    pretty_name    => 'Public Flag',
    pretty_plural  => 'Public Flags',
    column_spec    => 'char(1)'
  );

  attr_id := content_type.create_attribute (
    content_type   => 'cr_wp_presentation',
    attribute_name => 'show_modified_p',
    datatype       => 'boolean',
    pretty_name    => 'Show Modified Flag',
    pretty_plural  => 'Show Modified Flags',
    column_spec    => 'char(1)'
  );
  
end;
/
show errors

declare
  attr_id acs_attributes.attribute_id%TYPE;
begin
  
  attr_id := content_type.create_attribute (
    content_type   => 'cr_wp_slide',
    attribute_name => 'sort_key',
    datatype       => 'integer',
    pretty_name    => 'Sort Key',
    pretty_plural  => 'Sort Keys',
    column_spec    => 'integer'
  );

  attr_id := content_type.create_attribute (
    content_type   => 'cr_wp_slide',
    attribute_name => 'slide_title',
    datatype       => 'text',
    pretty_name    => 'Slide Title',
    pretty_plural  => 'Slide Titles',
    column_spec    => 'varchar2(400)'
  );

  attr_id := content_type.create_attribute (
    content_type   => 'cr_wp_slide',
    attribute_name => 'include_in_outline_p',
    datatype       => 'boolean',
    pretty_name    => 'Include in Outline Flag',
    pretty_plural  => 'Include in Outline Flags',
    column_spec    => 'char(1)'
  );

  attr_id := content_type.create_attribute (
    content_type   => 'cr_wp_slide',
    attribute_name => 'context_break_after_p',
    datatype       => 'boolean',
    pretty_name    => 'Context Break After Flag',
    pretty_plural  => 'Context Break After Flags',
    column_spec    => 'char(1)'
  );

  attr_id := content_type.create_attribute (
    content_type   => 'cr_wp_slide',
    attribute_name => 'style',
    datatype       => 'integer',
    pretty_name    => 'Style',
    pretty_plural  => 'Styles',
    column_spec    => 'integer'
  );
end;
/
show errors

declare
  attr_id acs_attributes.attribute_id%TYPE;
begin
  
  attr_id := content_type.create_attribute (
    content_type   => 'cr_wp_presentation_aud',
    attribute_name => 'presentation_id',
    datatype       => 'integer',
    pretty_name    => 'Prsentation ID',
    pretty_plural  => 'Presentation IDs',
    column_spec    => 'integer'
  );

  attr_id := content_type.create_attribute (
    content_type   => 'cr_wp_presentation_back',
    attribute_name => 'presentation_id',
    datatype       => 'integer',
    pretty_name    => 'Prsentation ID',
    pretty_plural  => 'Presentation IDs',
    column_spec    => 'integer'
  );

  attr_id := content_type.create_attribute (
    content_type   => 'cr_wp_slide_preamble',
    attribute_name => 'slide_id',
    datatype       => 'integer',
    pretty_name    => 'Slide ID',
    pretty_plural  => 'Slide IDs',
    column_spec    => 'integer'
  );

  attr_id := content_type.create_attribute (
    content_type   => 'cr_wp_slide_postamble',
    attribute_name => 'slide_id',
    datatype       => 'integer',
    pretty_name    => 'Slide ID',
    pretty_plural  => 'Slide IDs',
    column_spec    => 'integer'
  );

  attr_id := content_type.create_attribute (
    content_type   => 'cr_wp_slide_bullet_items',
    attribute_name => 'slide_id',
    datatype       => 'integer',
    pretty_name    => 'Slide ID',
    pretty_plural  => 'Slide IDs',
    column_spec    => 'integer'
  );
end;
/
show errors



begin
  content_type.register_child_type('cr_wp_presentation', 'cr_wp_presentation_aud', 'generic');
  content_type.register_child_type('cr_wp_presentation', 'cr_wp_presentation_back', 'generic');
  content_type.register_child_type('cr_wp_presentation', 'cr_wp_slide', 'generic');

  content_type.register_child_type('cr_wp_slide', 'cr_wp_slide_preamble', 'generic');
  content_type.register_child_type('cr_wp_slide', 'cr_wp_slide_postamble', 'generic');
  content_type.register_child_type('cr_wp_slide', 'cr_wp_slide_bullet_items', 'generic');
end;
/
show errors

begin
  content_folder.register_content_type(content_item.c_root_folder_id, 'cr_wp_presentation');
  content_folder.register_content_type(content_item.c_root_folder_id, 'cr_wp_presentation_aud');
  content_folder.register_content_type(content_item.c_root_folder_id, 'cr_wp_presentation_back');
  content_folder.register_content_type(content_item.c_root_folder_id, 'cr_wp_slide');
  content_folder.register_content_type(content_item.c_root_folder_id, 'cr_wp_slide_preamble');
  content_folder.register_content_type(content_item.c_root_folder_id, 'cr_wp_slide_postamble');
  content_folder.register_content_type(content_item.c_root_folder_id, 'cr_wp_slide_bullet_items');
end;
/
show errors




-- Keeps track of the sorting order for frozen sets of slides.
-- ???? should references cr_items


-- File attachments - always displayed as a link

create table cr_wp_file_attachments (
	attach_id	integer
		        constraint cr_fattach_attach_id_fk
			references cr_revisions
			constraint cr_fattach_attach_id_pk
			primary key
);

-- Image attachments.  May or may not be displayed as a link.

create table cr_wp_image_attachments (
	attach_id	integer
		        constraint cr_iattach_attach_id_fk
			references cr_revisions
			constraint cr_iattach_attach_id_pk
			primary key,
	-- Display how? null for a link
        display         varchar(20)
	                constraint cr_iattach_display_ck
			check(display in ('preamble', 'bullets', 'postamble', 'top', 'after_preamble', 'after_bullets', 'bottom'))
);


declare
  attr_id        acs_attributes.attribute_id%TYPE;
begin
  content_type.create_type (
    content_type  => 'cr_wp_image_attachment',
    supertype     => 'image',
    pretty_name   => 'Wimpy Image Attachment',
    pretty_plural => 'Wimpy Image Attachments',
    table_name    => 'cr_wp_image_attachments',
    id_column     => 'attach_id'
  );

  attr_id := content_type.create_attribute (
    content_type   => 'cr_wp_image_attachment',
    attribute_name => 'display',
    datatype       => 'text',
    pretty_name    => 'Where to display',
    pretty_plural  => 'Where to display',
    column_spec    => 'varchar2(20)'
  );

  content_type.create_type (
    content_type  => 'cr_wp_file_attachment',
    pretty_name   => 'Wimpy File Attachment',
    pretty_plural => 'Wimpy File Attachments',
    table_name    => 'cr_wp_file_attachments',
    id_column     => 'attach_id'
  );

  attr_id := content_type.create_attribute (
    content_type   => 'cr_wp_file_attachment',
    attribute_name => 'display',
    datatype       => 'text',
    pretty_name    => 'Where to display',
    pretty_plural  => 'Where to display',
    column_spec    => 'varchar2(20)'
  );

end;
/
show errors


begin
  content_type.register_child_type('cr_wp_slide', 'cr_wp_image_attachment', 'generic');
  content_type.register_child_type('cr_wp_slide', 'cr_wp_file_attachment', 'generic');
end;
/
show errors

begin
  content_folder.register_content_type(content_item.c_root_folder_id, 'cr_wp_image_attachment');
  content_folder.register_content_type(content_item.c_root_folder_id, 'cr_wp_file_attachment');
end;
/
show errors


commit;

-- Define some privileges on the wp_presentation object.
begin
	acs_privilege.create_privilege('wp_admin_presentation');
        acs_privilege.create_privilege('wp_create_presentation');
        acs_privilege.create_privilege('wp_edit_presentation'); 
        acs_privilege.create_privilege('wp_delete_presentation');
        acs_privilege.create_privilege('wp_view_presentation');
        commit;
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

    -- give registered users the power to create presentations by default

    acs_permission.grant_permission (
        object_id => default_context,
        grantee_id => registered_users,
        privilege => 'wp_create_presentation'
    );

    -- give the public the power to view by default

--	this commented out because permission, with this any user could see an slide that has not become public!
--    acs_permission.grant_permission (
--        object_id => default_context,
--       grantee_id => the_public,
--        privilege => 'wp_view_presentation'
--    );

end;
/
show errors


-- Define a PL/SQL package containing construstor/deletor functions for the 
-- wp_presentation object.
create or replace package wp_presentation
as
  function new (
    creation_date	in acs_objects.creation_date%TYPE
			   default sysdate,
    creation_user	in acs_objects.creation_user%TYPE
			   default null,
    creation_ip		in acs_objects.creation_ip%TYPE default null,
    pres_title          in cr_wp_presentations.pres_title%TYPE,
    page_signature      in cr_wp_presentations.page_signature%TYPE,
    copyright_notice    in cr_wp_presentations.copyright_notice%TYPE,
    style               in cr_wp_presentations.style%TYPE default -1,
    public_p     	in cr_wp_presentations.public_p%TYPE default 'f',
    show_modified_p     in cr_wp_presentations.show_modified_p%TYPE default 'f',
    audience            in varchar2,
    background          in varchar2,
    parent_id		in integer,
    package_id		in integer
  ) return cr_items.item_id%TYPE;

  procedure delete_audience (
    audience_item_id	in cr_items.item_id%TYPE
  );

  procedure delete_background (
    background_item_id	in cr_items.item_id%TYPE
  );

  procedure del (
    pres_item_id	in cr_items.item_id%TYPE
  );

  function get_audience (
    pres_item_id	in cr_items.item_id%TYPE
  ) return blob;

  function get_audience_revision (
    pres_revision_id	in cr_revisions.revision_id%TYPE
  ) return blob;

  function get_background (
    pres_item_id	in cr_items.item_id%TYPE
  ) return blob;

  function get_background_revision (
    pres_revision_id	in cr_revisions.revision_id%TYPE
  ) return blob;

  procedure new_revision (
    creation_date	in acs_objects.creation_date%TYPE
			   default sysdate,
    creation_user	in acs_objects.creation_user%TYPE
			   default null,
    creation_ip		in acs_objects.creation_ip%TYPE default null,
    pres_item_id	in cr_items.item_id%TYPE,
    pres_title          in cr_wp_presentations.pres_title%TYPE,
    page_signature      in cr_wp_presentations.page_signature%TYPE,
    copyright_notice    in cr_wp_presentations.copyright_notice%TYPE,
    style               in cr_wp_presentations.style%TYPE,
    public_p     	in cr_wp_presentations.public_p%TYPE,
    show_modified_p     in cr_wp_presentations.show_modified_p%TYPE,
    audience            in varchar2,
    background          in varchar2
  );

end wp_presentation;
/
show errors

-- Define a PL/SQL package containing construstor/deletor functions for the 
-- wp_slide object.
-- context_id should be the presentation_id this slide belongs to.
create or replace package wp_slide
as
  function new (
    pres_item_id        	in cr_items.item_id%TYPE,
    creation_date		in acs_objects.creation_date%TYPE default sysdate,
    creation_user		in acs_objects.creation_user%TYPE default null,
    creation_ip			in acs_objects.creation_ip%TYPE default null,
    slide_title               	in cr_wp_slides.slide_title%TYPE,
    style               	in cr_wp_slides.style%TYPE default -1,     
    original_slide_id   	in cr_wp_slides.original_slide_id%TYPE,
    sort_key            	in cr_wp_slides.sort_key%TYPE,
    preamble            	in varchar2,
    bullet_items        	in varchar2,
    postamble           	in varchar2,
    include_in_outline_p 	in cr_wp_slides.include_in_outline_p%TYPE default 't',
    context_break_after_p 	in cr_wp_slides.context_break_after_p%TYPE default 'f',
    context_id          	in acs_objects.context_id%TYPE default null,
    package_id                  in acs_objects.package_id%TYPE default null
  ) return cr_items.item_id%TYPE;


  procedure delete_preamble (
    preamble_item_id	in cr_items.item_id%TYPE
  );

  procedure delete_postamble (
    postamble_item_id	in cr_items.item_id%TYPE
  );

  procedure delete_bullet_items (
    bullet_items_item_id	in cr_items.item_id%TYPE
  );
    
  procedure del (
    slide_item_id	in cr_items.item_id%TYPE
  );

  function get_preamble (
    slide_item_id	in cr_items.item_id%TYPE
  ) return blob;

  function get_preamble_revision (
    slide_revision_id	in cr_revisions.revision_id%TYPE
  ) return blob;
 
  function get_postamble (
    slide_item_id	in cr_items.item_id%TYPE
  ) return blob;

  function get_postamble_revision (
    slide_revision_id	in cr_revisions.revision_id%TYPE
  ) return blob;

  function get_bullet_items (
    slide_item_id	in cr_items.item_id%TYPE
  ) return blob;

  function get_bullet_items_revision (
    slide_revision_id	in cr_revisions.revision_id%TYPE
  ) return blob;

  procedure new_revision (
    creation_date		in acs_objects.creation_date%TYPE default sysdate,
    creation_user		in acs_objects.creation_user%TYPE default null,
    creation_ip			in acs_objects.creation_ip%TYPE default null,
    slide_item_id        	in cr_items.item_id%TYPE,
    slide_title               	in cr_wp_slides.slide_title%TYPE,
    preamble            	in varchar2,
    bullet_items        	in varchar2,
    postamble           	in varchar2,
    style               	in cr_wp_slides.style%TYPE default -1,     
    original_slide_id   	in cr_wp_slides.original_slide_id%TYPE,
    sort_key            	in cr_wp_slides.sort_key%TYPE,
    include_in_outline_p 	in cr_wp_slides.include_in_outline_p%TYPE default 't',
    context_break_after_p 	in cr_wp_slides.context_break_after_p%TYPE default 'f'
  );

end wp_slide;
/
show errors

-- DRB: Creating an attachment is handled by cr_import_content

create or replace package wp_attachment
as

  procedure del (
    attach_item_id	in cr_items.item_id%TYPE
  );

  procedure new_revision (
    attach_item_id        	in cr_items.item_id%TYPE
  );

end wp_attachment;
/
show errors
    
create or replace package body wp_presentation
as
  function new (
    creation_date	in acs_objects.creation_date%TYPE
			   default sysdate,
    creation_user	in acs_objects.creation_user%TYPE
			   default null,
    creation_ip		in acs_objects.creation_ip%TYPE default null,
    pres_title          in cr_wp_presentations.pres_title%TYPE,
    page_signature      in cr_wp_presentations.page_signature%TYPE,
    copyright_notice    in cr_wp_presentations.copyright_notice%TYPE,
    style               in cr_wp_presentations.style%TYPE default -1,
    public_p     	in cr_wp_presentations.public_p%TYPE,
    show_modified_p     in cr_wp_presentations.show_modified_p%TYPE default 'f',
    audience            in varchar2,
    background          in varchar2,
    parent_id		in integer,
    package_id		in integer
  ) return cr_items.item_id%TYPE
  is
    v_item_id			cr_items.item_id%TYPE;
    v_audience_item_id		cr_items.item_id%TYPE;
    v_background_item_id	cr_items.item_id%TYPE;
    v_revision_id		cr_revisions.revision_id%TYPE;
    v_audience_revision_id	cr_revisions.revision_id%TYPE;
    v_background_revision_id	cr_revisions.revision_id%TYPE;
    v_max_id			integer;
    v_name			cr_wp_presentations.pres_title%TYPE;
  begin
    -- (name, parent_id) must be unique. For type cr_wp_presentation,
    -- name has to be unique because parent_id is null.
    
    select nvl(max(item_id),0) into v_max_id
    from cr_items
    where content_type = 'cr_wp_presentation'
    and   name like new.pres_title || '%';

    v_name := new.pres_title || '_' || v_max_id;

    v_item_id := content_item.new(
      name          => v_name,
      content_type  => 'cr_wp_presentation',
      creation_date => creation_date,
      creation_user => creation_user,
      creation_ip   => creation_ip,
      parent_id     => parent_id,
      package_id    => package_id
    );

    v_revision_id := content_revision.new(
        item_id       => v_item_id,
        title         => '',
        data          => null,
	creation_date => creation_date,
        creation_user => creation_user,
        creation_ip   => creation_ip
    );

    content_item.set_live_revision(v_revision_id);
    
    insert into cr_wp_presentations
    (
    presentation_id,
    pres_title,
    page_signature,
    copyright_notice,
    style,
    public_p,
    show_modified_p
    )
    values
    (
    v_revision_id,
    new.pres_title,
    new.page_signature,
    new.copyright_notice,
    new.style,
    new.public_p,
    new.show_modified_p
    );

    v_audience_item_id := content_item.new(
      name          => 'aud',
      parent_id     => v_item_id,		
      content_type  => 'cr_wp_presentation_aud',
      creation_date => creation_date,
      creation_user => creation_user,
      creation_ip   => creation_ip,
      parent_id     => parent_id,
      package_id    => package_id
    );

    v_audience_revision_id := content_revision.new(
        item_id       => v_audience_item_id,
        title         => '',
	text          => audience,
	creation_date => creation_date,
        creation_user => creation_user,
        creation_ip   => creation_ip
    );

    content_item.set_live_revision(v_audience_revision_id);

    insert into cr_wp_presentations_aud
    (
    id,
    presentation_id
    )
    values
    (
    v_audience_revision_id,
    v_revision_id
    );

    v_background_item_id := content_item.new(
      name          => 'back',
      parent_id     => v_item_id,
      content_type  => 'cr_wp_presentation_back',
      creation_date => creation_date,
      creation_user => creation_user,
      creation_ip   => creation_ip,
      parent_id     => parent_id,
      package_id    => package_id
    );

    v_background_revision_id := content_revision.new(
        item_id       => v_background_item_id,
        title         => '',
	text          => background,
	creation_date => creation_date,
        creation_user => creation_user,
        creation_ip   => creation_ip
    );

    content_item.set_live_revision(v_background_revision_id);

    insert into cr_wp_presentations_back
    (
    id,
    presentation_id
    )
    values
    (
    v_background_revision_id,
    v_revision_id
    );

    return v_item_id;
  end;


  procedure delete_audience (
    audience_item_id	in cr_items.item_id%TYPE
  )
  is
  begin
    delete from cr_wp_presentations_aud
    where exists (select 1 from cr_revisions where revision_id = cr_wp_presentations_aud.id and item_id = audience_item_id);
    
    delete from cr_item_publish_audit
    where item_id = audience_item_id;

    content_item.del(audience_item_id);
  end;

  procedure delete_background (
    background_item_id	in cr_items.item_id%TYPE
  )
  is
  begin
    delete from cr_wp_presentations_back
    where exists (select 1 from cr_revisions where revision_id = cr_wp_presentations_back.id and item_id = background_item_id);
    
    delete from cr_item_publish_audit
    where item_id = background_item_id;

    content_item.del(background_item_id);
  end;

  procedure del (
    pres_item_id	in cr_items.item_id%TYPE
  )
  is
    v_audience_item_id		cr_items.item_id%TYPE;
    v_background_item_id	cr_items.item_id%TYPE;
    cursor v_slide_cursor is
    select item_id as slide_item_id
    from cr_items
    where content_type = 'cr_wp_slide'
    and   parent_id = pres_item_id;
  begin
    for c in v_slide_cursor loop
      wp_slide.del(c.slide_item_id);
    end loop;

    select item_id into v_audience_item_id
    from cr_items
    where content_type = 'cr_wp_presentation_aud'
    and   parent_id = pres_item_id;

    delete_audience(v_audience_item_id);

    select item_id into v_background_item_id
    from cr_items
    where content_type = 'cr_wp_presentation_back'
    and   parent_id = pres_item_id;

    delete_audience(v_background_item_id);

    delete from acs_permissions where object_id = pres_item_id;
    update acs_objects set context_id=null where context_id = pres_item_id;
    delete from cr_wp_presentations where exists (select 1 from cr_revisions where cr_revisions.revision_id = cr_wp_presentations.presentation_id and cr_revisions.item_id = pres_item_id);
    content_item.del(pres_item_id);
  end;

  function get_audience (
    pres_item_id	in cr_items.item_id%TYPE
  ) return blob
  is
    v_blob blob;
  begin
    select content into v_blob
    from cr_revisions, cr_items
    where cr_items.content_type = 'cr_wp_presentation_aud'
    and cr_items.parent_id = pres_item_id
    and cr_revisions.revision_id = cr_items.live_revision;
    return v_blob;
  end;

  function get_audience_revision (
    pres_revision_id	in cr_revisions.revision_id%TYPE
  ) return blob
  is
    v_blob blob;
  begin
    select r.content into v_blob
    from cr_revisions r,
         cr_wp_presentations_aud pa
    where pa.presentation_id = pres_revision_id
    and r.revision_id = pa.id;
    return v_blob;
  end;

  function get_background (
    pres_item_id	in cr_items.item_id%TYPE
  ) return blob
  is
    v_blob blob;
  begin
    select content into v_blob
    from cr_revisions, cr_items
    where cr_items.content_type = 'cr_wp_presentation_back'
    and cr_items.parent_id = pres_item_id
    and cr_revisions.revision_id = cr_items.live_revision;
    return v_blob;
  end;

  function get_background_revision (
    pres_revision_id	in cr_revisions.revision_id%TYPE
  ) return blob
  is
    v_blob blob;
  begin
    select r.content into v_blob
    from cr_revisions r,
         cr_wp_presentations_back pb
    where pb.presentation_id = pres_revision_id
    and r.revision_id = pb.id;
    return v_blob;
  end;

  procedure new_revision (
    creation_date	in acs_objects.creation_date%TYPE
			   default sysdate,
    creation_user	in acs_objects.creation_user%TYPE
			   default null,
    creation_ip		in acs_objects.creation_ip%TYPE default null,
    pres_item_id	in cr_items.item_id%TYPE,
    pres_title          in cr_wp_presentations.pres_title%TYPE,
    page_signature      in cr_wp_presentations.page_signature%TYPE,
    copyright_notice    in cr_wp_presentations.copyright_notice%TYPE,
    style               in cr_wp_presentations.style%TYPE,
    public_p     	in cr_wp_presentations.public_p%TYPE,
    show_modified_p     in cr_wp_presentations.show_modified_p%TYPE,
    audience            in varchar2,
    background          in varchar2
  )
  is
    v_audience_item_id		cr_items.item_id%TYPE;
    v_background_item_id	cr_items.item_id%TYPE;
    v_revision_id		cr_revisions.revision_id%TYPE;
    v_audience_revision_id	cr_revisions.revision_id%TYPE;
    v_background_revision_id	cr_revisions.revision_id%TYPE;
  begin

    v_revision_id := content_revision.new(
        creation_date => creation_date,
        creation_user => creation_user,
        creation_ip   => creation_ip,
        item_id       => pres_item_id,
        title         => '',
        data          => null
    );

    content_item.set_live_revision(v_revision_id);

    insert into cr_wp_presentations
    (
    presentation_id,
    pres_title,
    page_signature,
    copyright_notice,
    style,
    public_p,
    show_modified_p
    )
    values
    (
    v_revision_id,
    new_revision.pres_title,
    new_revision.page_signature,
    new_revision.copyright_notice,
    new_revision.style,
    new_revision.public_p,
    new_revision.show_modified_p
    );

    select item_id into v_audience_item_id
    from cr_items
    where parent_id = pres_item_id
    and   content_type = 'cr_wp_presentation_aud';

    v_audience_revision_id := content_revision.new(
        creation_date => creation_date,
        creation_user => creation_user,
        creation_ip   => creation_ip,
        item_id       => v_audience_item_id,
        title         => '',
	text          => audience
    );

    content_item.set_live_revision(v_audience_revision_id);

    insert into cr_wp_presentations_aud
    (
    id,
    presentation_id
    )
    values
    (
    v_audience_revision_id,
    v_revision_id
    );

    select item_id into v_background_item_id
    from cr_items
    where parent_id = pres_item_id
    and   content_type = 'cr_wp_presentation_back';

    v_background_revision_id := content_revision.new(
        creation_date => creation_date,
        creation_user => creation_user,
        creation_ip   => creation_ip,
        item_id       => v_background_item_id,
        title         => '',
	text          => background
    );

    content_item.set_live_revision(v_background_revision_id);

    insert into cr_wp_presentations_back
    (
    id,
    presentation_id
    )
    values
    (
    v_background_revision_id,
    v_revision_id
    );

  end;

end wp_presentation;
/
show errors


    
create or replace package body wp_slide
as
  function new (
    pres_item_id        	in cr_items.item_id%TYPE,
    creation_date		in acs_objects.creation_date%TYPE default sysdate,
    creation_user		in acs_objects.creation_user%TYPE default null,
    creation_ip			in acs_objects.creation_ip%TYPE default null,
    slide_title               	in cr_wp_slides.slide_title%TYPE,
    style               	in cr_wp_slides.style%TYPE default -1,     
    original_slide_id   	in cr_wp_slides.original_slide_id%TYPE,
    sort_key            	in cr_wp_slides.sort_key%TYPE,
    preamble            	in varchar2,
    bullet_items        	in varchar2,
    postamble           	in varchar2,
    include_in_outline_p 	in cr_wp_slides.include_in_outline_p%TYPE default 't',
    context_break_after_p 	in cr_wp_slides.context_break_after_p%TYPE default 'f',
    context_id          	in acs_objects.context_id%TYPE default null,
    package_id                  in acs_objects.package_id%TYPE default null
  ) return cr_items.item_id%TYPE
  is
    v_item_id			cr_items.item_id%TYPE;
    v_preamble_item_id		cr_items.item_id%TYPE;
    v_postamble_item_id		cr_items.item_id%TYPE;
    v_bullet_items_item_id	cr_items.item_id%TYPE;
    v_revision_id		cr_revisions.revision_id%TYPE;
    v_preamble_revision_id	cr_revisions.revision_id%TYPE;
    v_postamble_revision_id	cr_revisions.revision_id%TYPE;
    v_bullet_items_revision_id	cr_revisions.revision_id%TYPE;
    v_max_id			integer;
    v_name			cr_wp_slides.slide_title%TYPE;
  begin
    -- (name, parent_id) must be unique. Therefore, slide item
    -- name has to be unique within a presentation.
    
    select nvl(max(item_id),0) into v_max_id
    from cr_items
    where content_type = 'cr_wp_slide'
    and   name like new.slide_title || '%';

    v_name := new.slide_title || '_' || v_max_id;

    v_item_id := content_item.new(
      name          => v_name,
      parent_id     => pres_item_id,
      content_type  => 'cr_wp_slide',
      creation_date => creation_date,
      creation_user => creation_user,
      creation_ip   => creation_ip,
      parent_id     => parent_id,
      package_id    => package_id
    );

    v_revision_id := content_revision.new(
        item_id       => v_item_id,
        title         => '',
        data          => null,
	creation_date => creation_date,
        creation_user => creation_user,
        creation_ip   => creation_ip
    );
   
    content_item.set_live_revision(v_revision_id);

    -- update sort_key
    update cr_wp_slides
    set sort_key = sort_key + 1
    where sort_key >= new.sort_key
    and   exists (select 1 from cr_items, cr_revisions where parent_id = pres_item_id and cr_items.item_id = cr_revisions.item_id and cr_revisions.revision_id=cr_wp_slides.slide_id);

    insert into cr_wp_slides
    (
    slide_id,
    slide_title,
    style,
    original_slide_id,
    sort_key,
    include_in_outline_p,
    context_break_after_p
    )
    values
    (
    v_revision_id,
    new.slide_title,
    new.style,
    new.original_slide_id,
    new.sort_key,
    new.include_in_outline_p,
    new.context_break_after_p
    );


    v_preamble_item_id := content_item.new(
      name          => 'preamble',
      parent_id     => v_item_id,		
      content_type  => 'cr_wp_slide_preamble',
      creation_date => creation_date,
      creation_user => creation_user,
      creation_ip   => creation_ip,
      parent_id     => parent_id,
      package_id    => package_id
    );

    v_preamble_revision_id := content_revision.new(
        item_id       => v_preamble_item_id,
        title         => '',
	text          => preamble,
	creation_date => creation_date,
        creation_user => creation_user,
        creation_ip   => creation_ip
    );

    content_item.set_live_revision(v_preamble_revision_id);

    insert into cr_wp_slides_preamble
    (
    id,
    slide_id
    )
    values
    (
    v_preamble_revision_id,
    v_revision_id
    );

    v_postamble_item_id := content_item.new(
      name          => 'postamble',
      parent_id     => v_item_id,		
      content_type  => 'cr_wp_slide_postamble',
      creation_date => creation_date,
      creation_user => creation_user,
      creation_ip   => creation_ip,
      parent_id     => parent_id,
      package_id    => package_id
    );

    v_postamble_revision_id := content_revision.new(
        item_id       => v_postamble_item_id,
        title         => '',
	text          => postamble,
	creation_date => creation_date,
        creation_user => creation_user,
        creation_ip   => creation_ip
    );

    content_item.set_live_revision(v_postamble_revision_id);

    insert into cr_wp_slides_postamble
    (
    id,
    slide_id
    )
    values
    (
    v_postamble_revision_id,
    v_revision_id
    );

    v_bullet_items_item_id := content_item.new(
      name          => 'bullet_items',
      parent_id     => v_item_id,		
      content_type  => 'cr_wp_slide_bullet_items',
      creation_date => creation_date,
      creation_user => creation_user,
      creation_ip   => creation_ip,
      parent_id     => parent_id,
      package_id    => package_id
    );

    v_bullet_items_revision_id := content_revision.new(
        item_id       => v_bullet_items_item_id,
        title         => '',
	text          => bullet_items,
	creation_date => creation_date,
        creation_user => creation_user,
        creation_ip   => creation_ip
    );

    content_item.set_live_revision(v_bullet_items_revision_id);

    insert into cr_wp_slides_bullet_items
    (
    id,
    slide_id
    )
    values
    (
    v_bullet_items_revision_id,
    v_revision_id
    );

    return v_item_id;
  end;

  procedure delete_preamble (
    preamble_item_id	in cr_items.item_id%TYPE
  )
  is
  begin
    delete from cr_wp_slides_preamble
    where exists (select 1 from cr_revisions where revision_id = cr_wp_slides_preamble.id and item_id = preamble_item_id);
    
    delete from cr_item_publish_audit
    where item_id = preamble_item_id;

    content_item.del(preamble_item_id);
  end;

  procedure delete_postamble (
    postamble_item_id	in cr_items.item_id%TYPE
  )
  is
  begin
    delete from cr_wp_slides_postamble
    where exists (select 1 from cr_revisions where revision_id = cr_wp_slides_postamble.id and item_id = postamble_item_id);
    
    delete from cr_item_publish_audit
    where item_id = postamble_item_id;

    content_item.del(postamble_item_id);
  end;

   procedure delete_bullet_items (
    bullet_items_item_id	in cr_items.item_id%TYPE
  )
  is
  begin
    delete from cr_wp_slides_bullet_items
    where exists (select 1 from cr_revisions where revision_id = cr_wp_slides_bullet_items.id and item_id = bullet_items_item_id);
    
    delete from cr_item_publish_audit
    where item_id = bullet_items_item_id;

    content_item.del(bullet_items_item_id);
  end;

  procedure del (
    slide_item_id	in cr_items.item_id%TYPE
  )
  is
    v_sort_key      		cr_wp_slides.sort_key%TYPE;
    v_pres_item_id  		cr_items.item_id%TYPE;
    v_preamble_item_id		cr_items.item_id%TYPE;
    v_postamble_item_id		cr_items.item_id%TYPE;
    v_bullet_items_item_id	cr_items.item_id%TYPE;
    cursor v_attach_cursor is
    select item_id as attach_item_id
    from cr_items
    where content_type in ('cr_wp_image_attachment', 'cr_wp_file_attachment')
    and   parent_id = slide_item_id;
  begin
    for c in v_attach_cursor loop
      wp_attachment.del(c.attach_item_id);
    end loop;

    select item_id into v_preamble_item_id
    from cr_items
    where content_type = 'cr_wp_slide_preamble'
    and   parent_id = slide_item_id;

    delete_preamble(v_preamble_item_id);

    select item_id into v_postamble_item_id
    from cr_items
    where content_type = 'cr_wp_slide_postamble'
    and   parent_id = slide_item_id;

    delete_postamble(v_postamble_item_id);

    select item_id into v_bullet_items_item_id
    from cr_items
    where content_type = 'cr_wp_slide_bullet_items'
    and   parent_id = slide_item_id;

    delete_bullet_items(v_bullet_items_item_id);

    -- sort_key of all revisions should be the same
    select max(s.sort_key), max(i.parent_id) into v_sort_key, v_pres_item_id
    from cr_wp_slides s, cr_revisions r, cr_items i
    where r.item_id = slide_item_id
    and   r.revision_id = s.slide_id
    and   i.item_id = r.item_id;
    delete from cr_wp_slides where exists (select 1 from cr_revisions where cr_revisions.revision_id = cr_wp_slides.slide_id and cr_revisions.item_id = slide_item_id);
    update cr_wp_slides set sort_key = sort_key - 1 where sort_key > v_sort_key and exists (select 1 from cr_revisions r, cr_items i where i.parent_id = v_pres_item_id and i.item_id = r.item_id and r.revision_id = cr_wp_slides.slide_id);
    update acs_objects set context_id=null where context_id = slide_item_id;
    delete from cr_item_publish_audit where item_id = slide_item_id;
    content_item.del(slide_item_id);
  end;

  function get_preamble (
    slide_item_id	in cr_items.item_id%TYPE
  ) return blob
  is
    v_blob blob;
  begin
    select content into v_blob
    from cr_revisions, cr_items
    where cr_items.content_type = 'cr_wp_slide_preamble'
    and cr_items.parent_id = slide_item_id
    and cr_revisions.revision_id = cr_items.live_revision;
    return v_blob;
  end;

  function get_preamble_revision (
    slide_revision_id	in cr_revisions.revision_id%TYPE
  ) return blob
  is
    v_blob blob;
  begin
    select content into v_blob
    from cr_revisions r, cr_wp_slides_preamble sp
    where sp.slide_id = slide_revision_id
    and   r.revision_id = sp.id;

    return v_blob;
  end;

  function get_postamble (
    slide_item_id	in cr_items.item_id%TYPE
  ) return blob
  is
    v_blob blob;
  begin
    select content into v_blob
    from cr_revisions, cr_items
    where cr_items.content_type = 'cr_wp_slide_postamble'
    and cr_items.parent_id = slide_item_id
    and cr_revisions.revision_id = cr_items.live_revision;
    return v_blob;
  end;

  function get_postamble_revision (
    slide_revision_id	in cr_revisions.revision_id%TYPE
  ) return blob
  is
    v_blob blob;
  begin
    select content into v_blob
    from cr_revisions r, cr_wp_slides_postamble sp
    where sp.slide_id = slide_revision_id
    and   r.revision_id = sp.id;

    return v_blob;
  end;

  function get_bullet_items (
    slide_item_id	in cr_items.item_id%TYPE
  ) return blob
  is
    v_blob blob;
  begin
    select content into v_blob
    from cr_revisions, cr_items
    where cr_items.content_type = 'cr_wp_slide_bullet_items'
    and cr_items.parent_id = slide_item_id
    and cr_revisions.revision_id = cr_items.live_revision;
    return v_blob;
  end;

  function get_bullet_items_revision (
    slide_revision_id	in cr_revisions.revision_id%TYPE
  ) return blob
  is
    v_blob blob;
  begin
    select content into v_blob
    from cr_revisions r, cr_wp_slides_bullet_items sb
    where sb.slide_id = slide_revision_id
    and   r.revision_id = sb.id;

    return v_blob;
  end;

  procedure new_revision (
    creation_date		in acs_objects.creation_date%TYPE default sysdate,
    creation_user		in acs_objects.creation_user%TYPE default null,
    creation_ip			in acs_objects.creation_ip%TYPE default null,
    slide_item_id        	in cr_items.item_id%TYPE,
    slide_title               	in cr_wp_slides.slide_title%TYPE,
    preamble            	in varchar2,
    bullet_items        	in varchar2,
    postamble           	in varchar2,
    style               	in cr_wp_slides.style%TYPE default -1,     
    original_slide_id   	in cr_wp_slides.original_slide_id%TYPE,
    sort_key            	in cr_wp_slides.sort_key%TYPE,
    include_in_outline_p 	in cr_wp_slides.include_in_outline_p%TYPE default 't',
    context_break_after_p 	in cr_wp_slides.context_break_after_p%TYPE default 'f'
  )
  is
    v_preamble_item_id		cr_items.item_id%TYPE;
    v_postamble_item_id		cr_items.item_id%TYPE;
    v_bullet_items_item_id	cr_items.item_id%TYPE;
    v_revision_id		cr_revisions.revision_id%TYPE;
    v_preamble_revision_id	cr_revisions.revision_id%TYPE;
    v_postamble_revision_id	cr_revisions.revision_id%TYPE;
    v_bullet_items_revision_id	cr_revisions.revision_id%TYPE;
  begin

    v_revision_id := content_revision.new(
        creation_date => creation_date,
        creation_user => creation_user,
        creation_ip   => creation_ip,
        item_id       => slide_item_id,
        title         => '',
        data          => null
    );
   
    content_item.set_live_revision(v_revision_id);

    insert into cr_wp_slides
    (
    slide_id,
    slide_title,
    style,
    original_slide_id,
    sort_key,
    include_in_outline_p,
    context_break_after_p
    )
    values
    (
    v_revision_id,
    new_revision.slide_title,
    new_revision.style,
    new_revision.original_slide_id,
    new_revision.sort_key,
    new_revision.include_in_outline_p,
    new_revision.context_break_after_p
    );


    select item_id into v_preamble_item_id
    from cr_items
    where parent_id = slide_item_id
    and   content_type = 'cr_wp_slide_preamble';

    v_preamble_revision_id := content_revision.new(
        creation_date => creation_date,
        creation_user => creation_user,
        creation_ip   => creation_ip,
        item_id       => v_preamble_item_id,
        title         => '',
	text          => preamble
    );

    content_item.set_live_revision(v_preamble_revision_id);

    insert into cr_wp_slides_preamble
    (
    id,
    slide_id
    )
    values
    (
    v_preamble_revision_id,
    v_revision_id
    );

    select item_id into v_postamble_item_id
    from cr_items
    where parent_id = slide_item_id
    and   content_type = 'cr_wp_slide_postamble';

    v_postamble_revision_id := content_revision.new(
        creation_date => creation_date,
        creation_user => creation_user,
        creation_ip   => creation_ip,
        item_id       => v_postamble_item_id,
        title         => '',
	text          => postamble
    );

    content_item.set_live_revision(v_postamble_revision_id);

    insert into cr_wp_slides_postamble
    (
    id,
    slide_id
    )
    values
    (
    v_postamble_revision_id,
    v_revision_id
    );

    select item_id into v_bullet_items_item_id
    from cr_items
    where parent_id = slide_item_id
    and   content_type = 'cr_wp_slide_bullet_items';

    v_bullet_items_revision_id := content_revision.new(
        creation_date => creation_date,
        creation_user => creation_user,
        creation_ip   => creation_ip,
        item_id       => v_bullet_items_item_id,
        title         => '',
	text          => bullet_items
    );

    content_item.set_live_revision(v_bullet_items_revision_id);

    insert into cr_wp_slides_bullet_items
    (
    id,
    slide_id
    )
    values
    (
    v_bullet_items_revision_id,
    v_revision_id
    );
  end;

end wp_slide;
/
show errors


create or replace package body wp_attachment
as
    
  procedure del (
    attach_item_id	in cr_items.item_id%TYPE
  )
  is
  begin
    delete from cr_wp_image_attachments
    where exists (select 1 from cr_revisions where revision_id = cr_wp_image_attachments.attach_id and item_id = attach_item_id);

    delete from cr_wp_file_attachments
    where exists (select 1 from cr_revisions where revision_id = cr_wp_file_attachments.attach_id and item_id = attach_item_id);
    
    delete from cr_item_publish_audit
    where item_id = attach_item_id;

    content_item.del(attach_item_id);
  end;

  procedure new_revision (
    attach_item_id  in cr_items.item_id%TYPE
  )
  is
  begin
    return;
  end;

end wp_attachment;
/
show errors


-- adding some new permissions roc@

Begin

	acs_privilege.add_child('wp_edit_presentation',  'wp_view_presentation');
	acs_privilege.add_child('wp_admin_presentation', 'wp_create_presentation');
	acs_privilege.add_child('wp_admin_presentation', 'wp_edit_presentation');
	acs_privilege.add_child('wp_admin_presentation', 'wp_delete_presentation');

-- lets give site-wide permissions, wp-permissions! 
	acs_privilege.add_child('admin', 'wp_admin_presentation');

end;
/

--style package roc@

create or replace package wp_style
as

procedure del (
    p_style_id     in wp_styles.style_id%TYPE
);

procedure image_delete(
    p_revision_id       in wp_style_images.wp_style_images_id%TYPE
);

end wp_style;
/
show errors



create or replace package body wp_style 
as

procedure del (
    p_style_id	 in wp_styles.style_id%TYPE
)
is 
    p_item_id			integer;
begin

	for one_image in (
	    select * from wp_style_images 
	    where wp_style_images_id = (select background_image from wp_styles where style_id = wp_style.del.p_style_id))
	loop
		delete from wp_style_images where wp_style_images_id = one_image.wp_style_images_id;
		select item_id into p_item_id from cr_revisions where revision_id = one_image.wp_style_images_id;
		
		content_item.del(item_id => p_item_id);
	end loop;
	
	update cr_wp_slides set style = -1 where style = wp_style.del.p_style_id;
	update cr_wp_presentations set style = -1 where style = wp_style.del.p_style_id;
	delete from wp_styles where style_id = wp_style.del.p_style_id;

end;



procedure image_delete(
    p_revision_id	in wp_style_images.wp_style_images_id%TYPE
) 
is
    p_item_id			integer;
begin

    update wp_styles set background_image = 0 where background_image = wp_style.image_delete.p_revision_id;

    delete from wp_style_images 
    where wp_style_images_id = wp_style.image_delete.p_revision_id;
    
    select item_id into p_item_id from cr_revisions where revision_id = wp_style.image_delete.p_revision_id;

    content_item.del(item_id => p_item_id);

end;


end wp_style;
/
show errors


commit;
