-- Wimpy Point Data Model for ACS 4.0
-- 
-- Paul Konigsberg paulk@arsdigita.com 10/22/00
--    original module author Jon Salz jsalz@mit.edu


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
    parent_id		in integer
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
    parent_id		in integer
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
      parent_id     => parent_id
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
