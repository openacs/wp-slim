-- upgrade script
-- extra permissions roc@

create function inline_1 ()
returns integer as'
declare
    default_context acs_objects.object_id%TYPE;
    the_public acs_objects.object_id%TYPE;
begin

    default_context := acs__magic_object_id(''default_context'');
    the_public := acs__magic_object_id(''the_public'');

    PERFORM acs_permission__revoke_permission (
         default_context,
         the_public,
        ''wp_view_presentation''
    );

return 0;
end;' language 'plpgsql';
select inline_1 ();
drop function inline_1 ();


select acs_privilege__add_child('wp_edit_presentation', 'wp_view_presentation');
select acs_privilege__add_child('wp_admin_presentation', 'wp_create_presentation');
select acs_privilege__add_child('wp_admin_presentation', 'wp_edit_presentation');
select acs_privilege__add_child('wp_admin_presentation', 'wp_delete_presentation');

-- lets give site-wide permissions, wp-permissions! 
select acs_privilege__add_child('admin', 'wp_admin_presentation');



-- styles stuff
alter table wp_styles add public_p char(1) check(public_p in ('t','f'));
alter table wp_styles alter public_p set default 'f';

alter table wp_styles add owner	integer constraint wp_styles_to_users references users (user_id);


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

create function wp_style__delete(
    integer
) returns integer as'
declare 
    p_style_id		alias for $1;
    p_item_id			integer;
    one_image			record;
begin

	for one_image in 
	    select * from wp_style_images 
	    where wp_style_images_id = (select background_image from wp_styles where style_id = p_style_id)
	loop
		delete from wp_style_images where wp_style_images_id = one_image.wp_style_images_id;
		select item_id into p_item_id from cr_revisions where revision_id = one_image.wp_style_images_id;
		PERFORM content_item__delete(p_item_id);
	end loop;
	
	update cr_wp_slides set style = -1 where style = p_style_id;
	update cr_wp_presentations set style = -1 where style = p_style_id;
	delete from wp_styles where style_id = p_style_id;

    return 0;
end;' language 'plpgsql';

create function wp_style__image_delete(
    integer
) returns integer as'
declare 
    p_revision_id		alias for $1;
    p_item_id			integer;
begin

    update wp_styles set background_image = 0 where background_image = p_revision_id;

    delete from wp_style_images 
    where wp_style_images_id = p_revision_id;
    
    select item_id into p_item_id from cr_revisions where revision_id = p_revision_id;

    PERFORM content_item__delete(p_item_id);

    return 0;
end;' language 'plpgsql';



-- added for showing comments to general users

alter table cr_wp_presentations add show_comments_p char(1) check(show_comments_p in ('t','f'));
alter table cr_wp_presentations alter show_comments_p set default 'f';
