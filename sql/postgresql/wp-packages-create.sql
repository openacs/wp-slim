-- /packages/wp-slim/sql/postgresql/wp-packages-create.sql
--
-- PL/pgsql for wimpy point
-- 
-- @cvs-id $Id$
--

--jackp: From here on the functions are defined

--jackp: To p_create each presentation
create or replace function wp_presentation__new (
    timestamptz,
    integer,
    varchar,
    varchar,   
    varchar,   
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
    p_creation_date             alias for $1;
    p_creation_user             alias for $2;
    p_creation_ip               alias for $3;
    p_pres_title                alias for $4;
    p_page_signature            alias for $5;
    p_copyright_notice          alias for $6;
    p_style                     alias for $7;
    p_public_p                  alias for $8;
    p_show_modified_p           alias for $9;
    p_aud                       alias for $10;
    p_back                      alias for $11;
    p_parent_id                 alias for $12;
    v_item_id                   cr_items.item_id%TYPE;
    v_audience_item_id          cr_items.item_id%TYPE;
    v_background_item_id        cr_items.item_id%TYPE;
    v_revision_id               cr_revisions.revision_id%TYPE;
    v_audience_revision_id      cr_revisions.revision_id%TYPE;
    v_background_revision_id    cr_revisions.revision_id%TYPE;
    v_max_id                    integer;
    v_name                      cr_wp_presentations.pres_title%TYPE;
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
    
    perform content_item__set_live_revision(v_revision_id);

    --jackp: Actually place the information entered 
    --       by the user into the table

    insert into cr_wp_presentations (
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
        p_aud,
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
        p_aud,
        v_audience_item_id,
        null,
        p_creation_date,
        p_creation_user,
        p_creation_ip
     );
    
    perform content_item__set_live_revision(v_audience_revision_id);
      
    insert into cr_wp_presentations_aud 
    (id, presentation_id) 
    values 
    (v_audience_revision_id, v_revision_id);
    
    v_background_item_id := content_item__new(
        p_back,
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
        p_back,
        v_background_item_id,
        null,
        p_creation_date,
        p_creation_user,
        p_creation_ip
    );
    
    perform content_item__set_live_revision(v_background_revision_id);
     
    insert into cr_wp_presentations_back
    (id, presentation_id) 
    values 
    (v_background_revision_id, v_revision_id);
    
    return v_item_id;
end;' language 'plpgsql';
        
create or replace function wp_presentation__delete_audience (integer)
returns integer as '
declare
    audience_item_id    alias for $1;
begin
    delete from cr_wp_presentations_aud
    where exists (select 1 from cr_revisions 
                    where revision_id = cr_wp_presentations_aud.id 
                    and item_id = audience_item_id);

    delete from cr_item_publish_audit where item_id = audience_item_id;
     
    perform content_item__delete(audience_item_id);

    return 0;
end;' language 'plpgsql';

create or replace function wp_presentation__delete_background (integer)
returns integer as '
declare
    background_item_id  alias for $1;
begin
    delete from cr_wp_presentations_back
    where exists (select 1 from cr_revisions 
                    where revision_id = cr_wp_presentations_back.id 
                    and item_id = background_item_id);  

    delete from cr_item_publish_audit where item_id = background_item_id;
    
    perform content_item__delete(background_item_id);

    return 0;
end;' language 'plpgsql';

create or replace function wp_presentation__delete (integer)
returns integer as '
declare
    p_pres_item_id                  alias for $1;
    v_audience_item_id              cr_items.item_id%TYPE;
    v_background_item_id            cr_items.item_id%TYPE;
    del_rec                         record;
begin
    for del_rec in 
        select item_id as slide_item_id
          from cr_items
          where content_type = ''cr_wp_slide''
          and   parent_id = p_pres_item_id 
    loop 
       perform wp_slide__delete(del_rec.slide_item_id);
    end loop;
    
    select item_id into v_audience_item_id
      from cr_items
      where content_type = ''cr_wp_presentation_aud''
      and   parent_id = p_pres_item_id;
    
    perform wp_presentation__delete_audience(v_audience_item_id);
    
    select item_id into v_background_item_id
      from cr_items
      where content_type = ''cr_wp_presentation_back''
      and   parent_id = p_pres_item_id;
    
    perform wp_presentation__delete_background(v_background_item_id);
    
    delete from acs_permissions where object_id = p_pres_item_id;

   -- update acs_objects set context_id=null where context_id = p_pres_item_id;

    delete from cr_wp_presentations where exists 
        (select 1 from cr_revisions 
         where cr_revisions.revision_id = cr_wp_presentations.presentation_id 
         and cr_revisions.item_id = p_pres_item_id);

    perform content_item__delete(p_pres_item_id);

    return 0;
end;' language 'plpgsql';

-- DRB: All these could've been implemented as a single function with a 
--      type argument but I'm not going to rewrite all of wp-slim's queries 
--      just to clean this up...

create or replace function wp_presentation__get_ad_revision (integer) 
returns text as '
declare
    p_pres_revision_id  alias for $1;
begin
  return r.content
  from cr_revisions r, cr_wp_presentations_aud pa
  where pa.presentation_id = p_pres_revision_id
    and r.revision_id = pa.id;
end;' language 'plpgsql';

create or replace function wp_presentation__get_audience (integer) 
returns text as '
declare
    p_pres_item_id  alias for $1;
begin
    return content
    from cr_revisions, cr_items
    where cr_items.content_type = ''cr_wp_presentation_aud''
    and cr_items.parent_id = p_pres_item_id
    and cr_revisions.revision_id = cr_items__live_revision;
end;' language 'plpgsql';

create or replace function wp_presentation__get_bg_revision (integer) 
returns text as '
declare
    p_pres_revision_id  alias for $1;
begin
  return r.content
  from cr_revisions r, cr_wp_presentations_aud pa
  where pa.presentation_id = p_pres_revision_id
    and r.revision_id = pa.id;
end;' language 'plpgsql';

create or replace function wp_presentation__get_background (integer) 
returns text as '
declare 
    pres_item_id    alias for $1;
begin
    return content
    from cr_revisions, cr_items
    where cr_items.content_type = ''cr_wp_presentation_bak''
    and cr_items.parent_id = p_pres_item_id
    and cr_revisions.revision_id = cr_items__live_revision;
end;' language 'plpgsql';

create or replace function wp_presentation__new_revision (
    timestamptz,
    integer,     
    varchar,     
    integer,     
    varchar,
    varchar,
    varchar,
    integer,        
    boolean,    
    boolean,    
    varchar,    
    varchar
) returns integer as ' 
declare
    p_creation_date             alias for $1;
    p_creation_user             alias for $2;
    p_creation_ip               alias for $3;
    p_pres_item_id              alias for $4;
    p_pres_title                alias for $5;
    p_page_signature            alias for $6;
    p_copyright_notice          alias for $7;
    p_style                     alias for $8;
    p_public_p                  alias for $9;
    p_show_modified_p           alias for $10;
    p_audience                  alias for $11;
    p_background                alias for $12;
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

    perform content_item__set_live_revision(v_revision_id);
       
    insert into cr_wp_presentations (
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
    
    perform content_item__set_live_revision(v_audience_revision_id);
        
    insert into cr_wp_presentations_aud 
    (id, presentation_id) 
    values 
    (v_audience_revision_id, v_revision_id);
    
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
    
    perform content_item__set_live_revision(v_background_revision_id);
    
    insert into cr_wp_presentations_back 
    (id, presentation_id) 
    values 
    (v_background_revision_id, v_revision_id);

    return 0;
end;' language 'plpgsql';

create or replace function wp_slide__new (
    integer,
    timestamptz,
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
) returns integer as '
declare
    p_pres_item_id              alias for $1; 
    p_creation_date             alias for $2; 
    p_creation_user             alias for $3; 
    p_creation_ip               alias for $4; 
    p_slide_title               alias for $5;
    p_style                     alias for $6;
    p_original_slide_id         alias for $7;
    p_sort_key                  alias for $8;
    p_preamble                  alias for $9;
    p_bullet_items              alias for $10;
    p_postamble                 alias for $11;
    p_include_in_outline_p      alias for $12;
    p_context_break_after_p     alias for $13;
    p_context_id                alias for $14;
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
      
    perform content_item__set_live_revision(v_revision_id);

    update cr_wp_slides
    set sort_key = sort_key + 1
    where sort_key >= p_sort_key
    and  exists (select 1 from cr_items, cr_revisions 
                 where parent_id = p_pres_item_id 
                 and cr_items.item_id = cr_revisions.item_id 
                 and cr_revisions.revision_id=cr_wp_slides.slide_id);
        
    insert into cr_wp_slides ( 
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
    
    perform content_item__set_live_revision(v_preamble_revision_id);

    insert into cr_wp_slides_preamble
    (id, slide_id) 
    values 
    (v_preamble_revision_id, v_revision_id);

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

    perform content_item__set_live_revision(v_postamble_revision_id);
    
    insert into cr_wp_slides_postamble
    (id, slide_id) 
    values 
    (v_postamble_revision_id, v_revision_id);

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

    perform content_item__set_live_revision(v_bullet_items_revision_id);

    insert into cr_wp_slides_bullet_items
    (id, slide_id) 
    values 
    (v_bullet_items_revision_id, v_revision_id);

    return v_item_id;
end;' language 'plpgsql';

create or replace function wp_slide__delete_preamble (integer) 
returns integer as '
declare
    delete_preamble__preamble_item_id         alias for $1;
begin 
    delete from cr_wp_slides_preamble
    where exists (select 1 from cr_revisions 
                    where revision_id = cr_wp_slides_preamble.id
                    and item_id = delete_preamble__preamble_item_id);    
    
    delete from cr_item_publish_audit
    where item_id = delete_preamble__preamble_item_id;

    perform content_item__delete(delete_preamble__preamble_item_id);

    return 0;
end;' language 'plpgsql'; 

create or replace function wp_slide__delete_postamble(integer) 
returns integer as '
declare
    delete_postamble__postamble_item_id          alias for $1;
begin
    delete from cr_wp_slides_postamble
    where exists (select 1 from cr_revisions 
                    where revision_id = cr_wp_slides_postamble.id
                    and item_id = delete_postamble__postamble_item_id);
    
    delete from cr_item_publish_audit 
    where item_id = delete_postamble__postamble_item_id;
  
    perform content_item__delete(delete_postamble__postamble_item_id);

    return 0;
end;' language 'plpgsql';

create or replace function wp_slide__delete_bullet_items(integer) 
returns integer as '
declare
    delete_bullet_items__bullet_items_item_id            alias for $1;
begin 
    delete from cr_wp_slides_bullet_items
    where exists (select 1 from cr_revisions 
                    where revision_id = cr_wp_slides_bullet_items.id
                    and item_id = delete_bullet_items__bullet_items_item_id);
    
    delete from cr_item_publish_audit
    where item_id = delete_bullet_items__bullet_items_item_id;

    perform content_item__delete(delete_bullet_items__bullet_items_item_id);

    return 0;
end;' language 'plpgsql';

create or replace function wp_slide__delete(integer) 
returns integer as '
declare
    p_slide_item_id             alias for $1;
    del_rec                     record;
    v_sort_key                  cr_wp_slides.sort_key%TYPE;
    v_pres_item_id              cr_items.item_id%TYPE;
    v_preamble_item_id          cr_items.item_id%TYPE;
    v_postamble_item_id         cr_items.item_id%TYPE;
    v_bullet_items_item_id      cr_items.item_id%TYPE;
begin
    for del_rec in 
        select item_id as attach_item_id
        from cr_items
        where content_type in 
            (''cr_wp_image_attachment'', ''cr_wp_file_attachment'')
        and parent_id = p_slide_item_id
    loop
        perform wp_attachment__delete(del_rec.attach_item_id);
    end loop;

    select item_id into v_preamble_item_id
    from cr_items
    where content_type = ''cr_wp_slide_preamble''
    and parent_id = p_slide_item_id;
    
    perform wp_slide__delete_preamble(v_preamble_item_id);
    
    select item_id into v_postamble_item_id
    from cr_items
    where content_type = ''cr_wp_slide_postamble''
    and parent_id = p_slide_item_id;

    perform wp_slide__delete_postamble(v_postamble_item_id);
    
    select item_id into v_bullet_items_item_id
    from cr_items
    where content_type = ''cr_wp_slide_bullet_items''
    and parent_id = p_slide_item_id;
    
    perform wp_slide__delete_bullet_items(v_bullet_items_item_id);

    -- sort_key of all revisions should be the same
    select max(s.sort_key), max(i.parent_id) into v_sort_key, v_pres_item_id
    from cr_wp_slides s, cr_revisions r, cr_items i
    where r.item_id = p_slide_item_id
    and   r.revision_id = s.slide_id
    and   i.item_id = r.item_id;
    
    delete from cr_wp_slides where exists (select 1 from cr_revisions
    where cr_revisions.revision_id = cr_wp_slides.slide_id
    and cr_revisions.item_id = p_slide_item_id);

    update cr_wp_slides set sort_key = sort_key - 1 
    where sort_key > v_sort_key and exists 
      (select 1 from cr_revisions r, cr_items i 
      where i.parent_id = v_pres_item_id and i.item_id = r.item_id
      and r.revision_id = cr_wp_slides.slide_id);    

--    update acs_objects set context_id=null
--    where context_id = p_slide_item_id;

    delete from cr_item_publish_audit where item_id = p_slide_item_id;

    perform content_item__delete(p_slide_item_id);

    return 0;
end;' language 'plpgsql';

create or replace function wp_slide__get_preamble_revision (integer) 
returns text as '
declare
  p_slide_revision_id       alias for $1;
begin
  return content
  from cr_revisions r, cr_wp_slides_preamble sp
  where sp.slide_id = p_slide_revision_id
  and r.revision_id = sp.id;
end;' language 'plpgsql';

create or replace function wp_slide__get_postamble_revision (integer) 
returns text as '
declare
  p_slide_revision_id       alias for $1;
begin
  return content
  from cr_revisions r, cr_wp_slides_postamble sp
  where sp.slide_id = p_slide_revision_id
  and r.revision_id = sp.id;
end;' language 'plpgsql';

create or replace function wp_slide__get_bullet_items_revision (integer) 
returns text as '
declare
  p_slide_revision_id       alias for $1;
begin
  return content
  from cr_revisions r, cr_wp_slides_bullet_items sp
  where sp.slide_id = p_slide_revision_id
  and r.revision_id = sp.id;
end;' language 'plpgsql';

create or replace function wp_slide__get_postamble(integer) 
returns text as '
declare
    p_slide_item_id         alias for $1;
begin
    return content
    from cr_revisions, cr_items
    where cr_items.content_type = ''cr_wp_slide_postamble''
    and cr_items.parent_id = p_slide_item_id
    and cr_revisions.revision_id = cr_items.live_revision;
end;' language 'plpgsql';

create or replace function wp_slide__get_preamble(integer) 
returns text as'
declare
    p_slide_item_id         alias for $1;
begin
    return content
    from cr_revisions, cr_items
    where cr_items.content_type = ''cr_wp_slide_preamble''
    and cr_items.parent_id = p_slide_item_id
    and cr_revisions.revision_id = cr_items.live_revision;
end;' language 'plpgsql';

create or replace function wp_slide__get_bullet_items(integer) 
returns text as '
declare
    p_slide_item_id         alias for $1;
begin
    return content
    from cr_revisions, cr_items
    where cr_items.content_type = ''cr_wp_slide_bullet_items''
    and cr_items.parent_id = p_slide_item_id
    and cr_revisions.revision_id = cr_items.live_revision;
end;' language 'plpgsql';

create or replace function wp_slide__new_revision(
    timestamptz,
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
    p_creation_date             alias for $1;  
    p_creation_user             alias for $2;
    p_creation_ip               alias for $3;
    p_slide_item_id             alias for $4;
    p_slide_title               alias for $5;
    p_preamble                  alias for $6;
    p_bullet_items              alias for $7;
    p_postamble                 alias for $8;
    p_style                     alias for $9;
    p_original_slide_id         alias for $10;
    p_sort_key                  alias for $11;    
    p_include_in_outline_p      alias for $12;
    p_context_break_after_p     alias for $13;
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

    perform content_item__set_live_revision(v_revision_id);
    
    insert into cr_wp_slides (
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
          
    perform content_item__set_live_revision(v_preamble_revision_id);

    insert into cr_wp_slides_preamble
    (id, slide_id) 
    values 
    (v_preamble_revision_id, v_revision_id);

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

    perform content_item__set_live_revision(v_postamble_revision_id);
      
    insert into cr_wp_slides_postamble
    (id, slide_id) 
    values 
    (v_postamble_revision_id, v_revision_id);

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

    perform content_item__set_live_revision(v_bullet_items_revision_id); 

    insert into cr_wp_slides_bullet_items
    (id, slide_id) 
    values 
    (v_bullet_items_revision_id, v_revision_id);

    return 0;
end;' language 'plpgsql';

-- bug fixed, delete first an image then a file, roc@
create or replace function wp_attachment__delete(integer) 
returns integer as '
declare 
    p_attach_item_id        alias for $1;
begin   
    delete from cr_wp_image_attachments
    where exists (select 1 from cr_revisions where revision_id 
      = cr_wp_image_attachments.attach_id 
      and item_id = p_attach_item_id);
    
    delete from cr_wp_file_attachments
    where exists (select 1 from cr_revisions where revision_id 
      = cr_wp_file_attachments.attach_id 
      and item_id = p_attach_item_id);

    delete from cr_item_publish_audit
    where item_id = p_attach_item_id;

    perform content_item__delete(p_attach_item_id);

    return 0;
end;' language 'plpgsql';

create or replace function wp_attachment__new_revision (integer) 
returns integer as '
declare
    p_attach_item_id        alias for $1;
begin
    return 0;
end; 'language 'plpgsql';

create or replace function wp_presentation__set_live_revision(integer) 
returns integer as '
declare
  p_revision_id         alias for $1;
  v_revision_id         integer;
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


-- style functions roc@
create or replace function wp_style__delete(integer) 
returns integer as '
declare 
    p_style_id          alias for $1;
    v_item_id           integer;
    one_image           record;
begin
    for one_image in 
        select * from wp_style_images where wp_style_images_id = 
          (select background_image from wp_styles where style_id = p_style_id)
    loop
        delete from wp_style_images 
        where wp_style_images_id = one_image.wp_style_images_id;

        select item_id into v_item_id 
        from cr_revisions 
        where revision_id = one_image.wp_style_images_id;

        perform content_item__delete(v_item_id);
    end loop;
    
    update cr_wp_slides set style = -1 where style = p_style_id;
    update cr_wp_presentations set style = -1 where style = p_style_id;
    delete from wp_styles where style_id = p_style_id;

    return 0;
end;' language 'plpgsql';

create or replace function wp_style__image_delete(integer) 
returns integer as '
declare 
    p_revision_id       alias for $1;
    v_item_id           integer;
begin
    update wp_styles set background_image = 0 
    where background_image = p_revision_id;

    delete from wp_style_images 
    where wp_style_images_id = p_revision_id;
    
    select item_id into v_item_id from cr_revisions 
    where revision_id = p_revision_id;

    perform content_item__delete(v_item_id);

    return 0;
end;' language 'plpgsql';


