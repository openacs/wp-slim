<master src="master">
<property name="title">All Revisions of This Presentation</property>
<property name="context">@context@</property>


Revision in <font color=red>red</font> is the current live revision.

<ul>
<multiple name="revisions">

<li>
<if @revisions.revision_id@ eq @revisions.live_revision@>
<font color=red>Created by @revisions.full_name@ from
@revisions.creation_ip@ at @revisions.creation_date@</font> (<a
href="presentation_revision/@pres_item_id@/@revisions.revision_id@">view</a>)
</if>
<else>
Created by @revisions.full_name@ from @revisions.creation_ip@ at
@revisions.creation_date@ (<a href="presentation_revision/@pres_item_id@/@revisions.revision_id@">view</a> | <a href="presentation-publish?revision_id=@revisions.revision_id@&return_url=@return_url@">go live</a>)
</else>

</li>

</multiple>
</ul>

<p> <a href="edit-presentation?pres_item_id=@pres_item_id@">Create a new revision</a>
