-- add a (possibly) new mime type
insert into cr_mime_types (mime_type) 
select 'application/octet-stream'
from dual
where not exists (select 1 from cr_mime_types where mime_type = 'application/octet-stream');


-- users with wp_admin_presentaiton privilege can access 
-- authorization pages
begin
	acs_privilege.create_privilege('wp_admin_presentation');
end;
/
show errors


-- add a parent_id column in all of the auxiliary tables for clobs so that we can keep
-- track of all revisions of a specific presentation or slide.
alter table cr_wp_presentations_audience add (
	presentation_id	integer
			constraint cr_wp_paud_pid_nn
			not null
			constraint cr_wp_paud_pid_fk
                       	references cr_wp_presentations
);

alter table cr_wp_presentations_background add (
	presentation_id	integer
			constraint cr_wp_pback_pid_nn
			not null
			constraint cr_wp_pback_pid_fk
                       	references cr_wp_presentations
);

alter table cr_wp_slides_preamble add (
	slide_id	integer
			constraint cr_wp_spreamble_sid_nn
			not null
			constraint cr_wp_spreamble_sid_fk
                       	references cr_wp_slides
);

alter table cr_wp_slides_postamble add (
	slide_id	integer
			constraint cr_wp_spostamble_sid_nn
			not null
			constraint cr_wp_spostamble_sid_fk
                       	references cr_wp_slides
);

alter table cr_wp_slides_bullet_items add (
	slide_id	integer
			constraint cr_wp_sbullet_sid_nn
			not null
			constraint cr_wp_sbullet_sid_fk
                       	references cr_wp_slides
);

-- add the correspondent attributes
declare
  attr_id acs_attributes.attribute_id%TYPE;
begin
  
  attr_id := content_type.create_attribute (
    content_type   => 'cr_wp_presentation_audience',
    attribute_name => 'presentation_id',
    datatype       => 'integer',
    pretty_name    => 'Prsentation ID',
    pretty_plural  => 'Presentation IDs',
    column_spec    => 'integer'
  );

  attr_id := content_type.create_attribute (
    content_type   => 'cr_wp_presentation_background',
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




-- add a public_p column
alter table cr_wp_presentations
add (
	public_p	char(1) default 'f'
			constraint cr_wp_public_p_ck
			check(public_p in ('t','f'))
);

-- create a public_p attribute
declare
  attr_id        acs_attributes.attribute_id%TYPE;
begin
  attr_id := content_type.create_attribute (
    content_type   => 'cr_wp_presentation',
    attribute_name => 'public_p',
    datatype       => 'boolean',
    pretty_name    => 'Public Flag',
    pretty_plural  => 'Public Flags',
    column_spec    => 'char(1)'
  );
end;
/
show errors

-- public_p added. delete_audience and delete_background added.
-- get_audience_revision and get_background_revision added.
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
    background          in varchar2
  ) return cr_items.item_id%TYPE;

  procedure delete_audience (
    audience_item_id	in cr_items.item_id%TYPE
  );

  procedure delete_background (
    background_item_id	in cr_items.item_id%TYPE
  );

  procedure delete (
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


-- public_p added. delete_audience and delete_background added. presentation_id in clobs table added.
-- get_audience_revision and get_background_revision added.
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
    background          in varchar2
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
      creation_ip   => creation_ip
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
      name          => 'audience',
      parent_id     => v_item_id,		
      content_type  => 'cr_wp_presentation_audience',
      creation_date => creation_date,
      creation_user => creation_user,
      creation_ip   => creation_ip
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

    insert into cr_wp_presentations_audience
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
      name          => 'background',
      parent_id     => v_item_id,
      content_type  => 'cr_wp_presentation_background',
      creation_date => creation_date,
      creation_user => creation_user,
      creation_ip   => creation_ip
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

    insert into cr_wp_presentations_background
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
    delete from cr_wp_presentations_audience
    where exists (select 1 from cr_revisions where revision_id = cr_wp_presentations_audience.id and item_id = audience_item_id);
    
    delete from cr_item_publish_audit
    where item_id = audience_item_id;

    content_item.delete(audience_item_id);
  end;

  procedure delete_background (
    background_item_id	in cr_items.item_id%TYPE
  )
  is
  begin
    delete from cr_wp_presentations_background
    where exists (select 1 from cr_revisions where revision_id = cr_wp_presentations_background.id and item_id = background_item_id);
    
    delete from cr_item_publish_audit
    where item_id = background_item_id;

    content_item.delete(background_item_id);
  end;

  procedure delete (
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
      wp_slide.delete(c.slide_item_id);
    end loop;

    select item_id into v_audience_item_id
    from cr_items
    where content_type = 'cr_wp_presentation_audience'
    and   parent_id = pres_item_id;

    delete_audience(v_audience_item_id);

    select item_id into v_background_item_id
    from cr_items
    where content_type = 'cr_wp_presentation_background'
    and   parent_id = pres_item_id;

    delete_audience(v_background_item_id);

    delete from acs_permissions where object_id = pres_item_id;
    update acs_objects set context_id=null where context_id = pres_item_id;
    delete from cr_wp_presentations where exists (select 1 from cr_revisions where cr_revisions.revision_id = cr_wp_presentations.presentation_id and cr_revisions.item_id = pres_item_id);
    content_item.delete(pres_item_id);
  end;

  function get_audience (
    pres_item_id	in cr_items.item_id%TYPE
  ) return blob
  is
    v_blob blob;
  begin
    select content into v_blob
    from cr_revisions, cr_items
    where cr_items.content_type = 'cr_wp_presentation_audience'
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
         cr_wp_presentations_audience pa
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
    where cr_items.content_type = 'cr_wp_presentation_background'
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
         cr_wp_presentations_background pb
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
    and   content_type = 'cr_wp_presentation_audience';

    v_audience_revision_id := content_revision.new(
        creation_date => creation_date,
        creation_user => creation_user,
        creation_ip   => creation_ip,
        item_id       => v_audience_item_id,
        title         => '',
	text          => audience
    );

    content_item.set_live_revision(v_audience_revision_id);

    insert into cr_wp_presentations_audience
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
    and   content_type = 'cr_wp_presentation_background';

    v_background_revision_id := content_revision.new(
        creation_date => creation_date,
        creation_user => creation_user,
        creation_ip   => creation_ip,
        item_id       => v_background_item_id,
        title         => '',
	text          => background
    );

    content_item.set_live_revision(v_background_revision_id);

    insert into cr_wp_presentations_background
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


-- slide_id in clobs table added. delete_preamble, delete_postamble and delete_bullet_items added.
-- get_preamble_revision, get_postamble_revision and get_bullet_items_revision added.
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
    context_id          	in acs_objects.context_id%TYPE default null
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
    
  procedure delete (
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
    context_id          	in acs_objects.context_id%TYPE default null
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
      creation_ip   => creation_ip
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
      creation_ip   => creation_ip
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
      creation_ip   => creation_ip
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
      creation_ip   => creation_ip
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

    content_item.delete(preamble_item_id);
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

    content_item.delete(postamble_item_id);
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

    content_item.delete(bullet_items_item_id);
  end;

  procedure delete (
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
    where content_type = 'cr_wp_attachment'
    and   parent_id = slide_item_id;
  begin
    for c in v_attach_cursor loop
      wp_attachment.delete(c.attach_item_id);
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
    content_item.delete(slide_item_id);
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