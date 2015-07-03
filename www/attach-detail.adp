<master>
<property name="doc(title)">#wp-slim.Details#</property>
<property name="context">@context;literal@</property>

#wp-slim.lt_Revision_in_font_colo#

<ul>
<multiple name="revisions">
<li>
<if @revisions.revision_id@ eq @revision_id@>
<font color=red>#wp-slim.lt_Uploaded_from_revisio#</font> (<a href="attach/@revisions.revision_id@/@file_name@">#wp-slim.view#</a>)
<p>
<form method=post action="display-change">
<input type="hidden" name="slide_item_id" value="@slide_item_id@">
<input type="hidden" name="attach_item_id" value="@attach_item_id@">
<input type="hidden" name="revision_id" value="@revisions.revision_id@">
<input type="hidden" name="file_name" value="@file_name@">
<if @attachment_type@ eq "image">
  <select name=display>
  <option value="" @_selected@>#wp-slim.as_a_link#
  <option value=top @top_selected@>#wp-slim.lt_at_the_very_top_align#
  <option value=preamble @preamble_selected@>#wp-slim.lt_next_to_the_preamble_#
  <option value=after_preamble @after_preamble_selected@>#wp-slim.lt_after_the_preamble_al#
  <option value=bullets @bullets_selected@>#wp-slim.lt_next_to_the_bullets_a#
  <option value=after_bullets @after_bullets_selected@>#wp-slim.lt_after_the_bullets_ali#
  <option value=postamble @postamble_selected@>#wp-slim.lt_next_to_the_postamble#
  <option value=bottom @bottom_selected@>#wp-slim.lt_at_the_very_bottom_al#
  </select>
</if>
<input type="submit" value="#wp-slim.Change#">
</form>
</if>
<else>
#wp-slim.lt_Uploaded_from_revisio_1#<a href="attach/@revisions.revision_id@/@file_name@">#wp-slim.view#</a> | <a href="live-revision-set?revision_id=@revisions.revision_id@&amp;return_url=@return_url@">#wp-slim.go_live#</a>)
</else>

</multiple>
</ul>


