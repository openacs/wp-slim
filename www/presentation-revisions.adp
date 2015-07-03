<master>
<property name="doc(title)">#wp-slim.lt_All_Revisions_of_This#</property>
<property name="context">@context;literal@</property>


#wp-slim.lt_Revision_in_font_colo#

<ul>
<multiple name="revisions">

<li>
<if @revisions.revision_id@ eq @revisions.live_revision@>
<font color=red>#wp-slim.lt_Created_by_revisionsf#</font> (<a
href="presentation_revision/@pres_item_id@/@revisions.revision_id@">#wp-slim.view#</a>)
</if>
<else>
#wp-slim.lt_Created_by_revisionsf_1# (<a href="presentation_revision/@pres_item_id@/@revisions.revision_id@">#wp-slim.view#</a> | <a href="presentation-publish?revision_id=@revisions.revision_id@&amp;return_url=@return_url@">#wp-slim.go_live#</a>)
</else>

</li>

</multiple>
</ul>

<p> <a href="edit-presentation?pres_item_id=@pres_item_id@">#wp-slim.lt_Create_a_new_revision#</a>

