-- /packages/wp-slim/sql/postgresql/upgrade-4.0b3-4.1.sql

-- timestamp fixes
-- @author Vinod Kurup (vinod@kurup.com)
-- @creation-date 2003-08-06
-- @cvs-id $Id$

-- why drop the functions instead of just doing create-or-replace?
-- because we're changing the signature, create-or-replace won't find 
-- the old functions, so they would linger in the db. drop them explicitly

drop function wp_presentation__new (
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
);

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
    varchar
);

drop function wp_slide__new (
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
    boolean
);

-- now load the new functions 
\i ../wp-packages-create.sql
