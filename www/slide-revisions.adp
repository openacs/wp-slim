<master>
<property name="title">#wp-slim.lt_All_Revisions_of_This_1#</property>
<property name="context">@context@</property>

<blockquote>

#wp-slim.lt_Revision_in_font_colo#

<ul>
<multiple name="revisions">

<li>
<if @revisions.revision_id@ eq @revisions.live_revision@>
<font color=red>#wp-slim.lt_Created_by_revisionsf_2#</font> (<a href="@subsite_name@slide_revision/@pres_item_id@/@slide_item_id@/@revisions.revision_id@.wimpy">#wp-slim.view#</a>)
</if>
<else>
#wp-slim.lt_Created_by_revisionsf_2# (<a href="@subsite_name@slide_revision/@pres_item_id@/@slide_item_id@/@revisions.revision_id@.wimpy">#wp-slim.view#</a> | <a href="slide-publish?revision_id=@revisions.revision_id@&pres_item_id=@pres_item_id@&return_url=@return_url@">#wp-slim.go_live#</a>)
</else>

</multiple>
</ul>

<p> <a href="add-edit-slide?slide_item_id=@slide_item_id@&pres_item_id=@pres_item_id@">#wp-slim.lt_Create_a_new_revision#</a>
</blockquote>

