-- upgrade script
-- some extra permissions roc@
declare
    default_context acs_objects.object_id%TYPE;
    the_public acs_objects.object_id%TYPE;
Begin

    default_context := acs.magic_object_id('default_context');
    the_public := acs.magic_object_id('the_public');


    acs_permission.revoke_permission (
        object_id => default_context,
        grantee_id => the_public,
        privilege => 'wp_view_presentation'
    );


	acs_privilege.add_child('wp_edit_presentation',  'wp_view_presentation');
	acs_privilege.add_child('wp_admin_presentation', 'wp_create_presentation');
	acs_privilege.add_child('wp_admin_presentation', 'wp_edit_presentation');
	acs_privilege.add_child('wp_admin_presentation', 'wp_delete_presentation');

-- lets give site-wide permissions, wp-permissions! 
	acs_privilege.add_child('admin', 'wp_admin_presentation');
end;
/
show errors



alter table wp_styles add public_p char(1) default 'f' check(public_p in ('t','f'));
alter table wp_styles add owner integer constraint wp_styles_to_users references users (user_id);

create sequence wp_style_seq;

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

create or replace package wp_style
as

procedure delete (
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

procedure delete (
    p_style_id	 in wp_styles.style_id%TYPE
)
is 
    p_item_id			integer;
begin

	for one_image in (
	    select * from wp_style_images 
	    where wp_style_images_id = (select background_image from wp_styles where style_id = wp_style.delete.p_style_id))
	loop
		delete from wp_style_images where wp_style_images_id = one_image.wp_style_images_id;
		select item_id into p_item_id from cr_revisions where revision_id = one_image.wp_style_images_id;
		
		content_item.delete(item_id => p_item_id);
	end loop;
	
	update cr_wp_slides set style = -1 where style = wp_style.delete.p_style_id;
	update cr_wp_presentations set style = -1 where style = wp_style.delete.p_style_id;
	delete from wp_styles where style_id = wp_style.delete.p_style_id;

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

    content_item.delete(item_id => p_item_id);

end;


end wp_style;
/
show errors


alter table cr_wp_presentations add (
      show_comments_p char(1) default 'f' constraint cr_wp_pres_show_comments_p check(show_comments_p in ('t','f'))
);
