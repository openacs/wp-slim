<master>
<property name="title">All Revisions of This Slide</property>
<property name="context">@context;noquote@</property>

<blockquote>

Revision in <font color=red>red</font> is the current live revision.

<ul>
<multiple name="revisions">

<li>
<if @revisions.revision_id@ eq @revisions.live_revision@>
<font color=red>Created by @revisions.full_name@ from @revisions.creation_ip@ at @revisions.creation_date@</font> (<a href="@subsite_name@slide_revision/@pres_item_id@/@slide_item_id@/@revisions.revision_id@.wimpy">view</a>)
</if>
<else>
Created by @revisions.full_name@ from @revisions.creation_ip@ at @revisions.creation_date@ (<a href="@subsite_name@slide_revision/@pres_item_id@/@slide_item_id@/@revisions.revision_id@.wimpy">view</a> | <a href="slide-publish?revision_id=@revisions.revision_id@&pres_item_id=@pres_item_id@&return_url=@return_url@">go live</a>)
</else>

</multiple>
</ul>

<p> <a href="edit-slide?slide_item_id=@slide_item_id@&pres_item_id=@pres_item_id@">Create a new revision</a>
</blockquote>
