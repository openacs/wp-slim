<master>
<property name="title">Details</property>
<property name="context">@context@</property>

Revision in <font color=red>red</font> is the current live revision.

<ul>
<multiple name="revisions">
<li>
<if @revisions.revision_id@ eq @revision_id@>
<font color=red>Uploaded from @revisions.creation_ip@ at @revisions.creation_date@</font> (<a href="attach/@revisions.revision_id@/@file_name@">view</a>)
<p>
<form method=post action="display-change">
<input type=hidden name=slide_item_id value=@slide_item_id@>
<input type=hidden name=attach_item_id value=@attach_item_id@>
<input type=hidden name=revision_id value=@revisions.revision_id@>
<input type=hidden name=file_name value="@file_name@">
<if @attachment_type@ eq "image">
  <select name=display>
  <option value="" @_selected@>as a link
  <option value=top @top_selected@>at the very top (aligned center)
  <option value=preamble @preamble_selected@>next to the preamble (aligned right)
  <option value=after_preamble @after_preamble_selected@>after the preamble (aligned center)
  <option value=bullets @bullets_selected@>next to the bullets (aligned right)
  <option value=after_bullets @after_bullets_selected@>after the bullets (aligned center)
  <option value=postamble @postamble_selected@>next to the postamble (aligned right)
  <option value=bottom @bottom_selected@>at the very bottom (aligned center)
  </select>
</if>
<input type=submit value=Change>
</form>
</if>
<else>
Uploaded from @revisions.creation_ip@ at @revisions.creation_date@ (<a href="attach/@revisions.revision_id@/@file_name@">view</a> | <a href="live-revision-set?revision_id=@revisions.revision_id@&return_url=@return_url@">go live</a>)
</else>

</multiple>
</ul>

