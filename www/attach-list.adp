<master>
<property name="title">List of Attachments</property>
<property name="context">@context@</property>

<ul>
<multiple name="att">
<li>@att.name@ (<a href="attach-del?slide_item_id=@slide_item_id@&attach_item_id=@att.item_id@">remove</a> | <a href="attach-detail?slide_item_id=@slide_item_id@&attach_item_id=@att.item_id@&file_name=@att.name@">details</a>)
</multiple>
</ul>

<form enctype=multipart/form-data action=attach method=post>
<input type=hidden name=slide_item_id value="@slide_item_id@">
<input type=hidden name=pres_item_id value="@pres_item_id@">

      <br><b>Add an Image or Attachment:</b>
      <p><input type=file size=30 name=attachment>
    <p><input type=radio name=inline_image_p value=t checked> Display as an image
<select name=display>
<option value=top>at the very top (aligned center)
<option value=preamble selected>next to the preamble (aligned right)
<option value=after_preamble>after the preamble (aligned center)
<option value=bullets>next to the bullets (aligned right)
<option value=after_bullets>after the bullets (aligned center)
<option value=postamble>next to the postamble (aligned right)
<option value=bottom>at the very bottom (aligned center)

</select>
      <br><input type=radio name=inline_image_p value=f> Display a link the viewer can use to download the file
      <p><input type=submit value="Add the Attachment">
</form>
