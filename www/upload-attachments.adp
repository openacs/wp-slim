<master>
<property name="title">Upload Attachments</property>
<property name="context">@context;noquote@</property>

<form enctype=multipart/form-data action=attach method=post>
<input type=hidden name=slide_item_id value="@slide_item_id@">
<input type=hidden name=pres_item_id value="@pres_item_id@">

<center><p>
<table border=2 cellpadding=10><tr><td>
<table cellspacing=0 cellpadding=0>
<tr>
  <th align=left nowrap>File Name</th><td>&nbsp;&nbsp;&nbsp;</td>
  <th align=right nowrap>File Size</th><td>&nbsp;&nbsp;&nbsp;</td>
  <th nowrap>Display</th>
</tr>
<tr><td colspan=7><hr></td></tr>

<tr><td colspan=7 align=center><i>There are 
<if @attachment_count@ eq 0>
@attachment_count@
</if>
<else>
<a href="attach-list?slide_item_id=@slide_item_id@">@attachment_count@</a>
</else>
 attachments currently associated with this slide.</i></td></tr>


  <tr valign=top><td colspan=7>
    <center>
      <br><a href="display/@pres_item_id@/@slide_item_id@.wimpy" target="_blank">Preview the Slide</a>
    </center>
    </p>
    <hr>
    <center>
      <br><b>Add an Image or Attachment:</b>
      <p><input type=file size=30 name=attachment>
    </center>
    <p><input type=radio name=inline_image_p value=t checked> Display as an image
<select name=display>
<option value=top >at the very top (aligned center)
<option value=preamble selected>next to the preamble (aligned right)
<option value=after_preamble >after the preamble (aligned center)
<option value=bullets >next to the bullets (aligned right)
<option value=after_bullets >after the bullets (aligned center)
<option value=postamble >next to the postamble (aligned right)
<option value=bottom >at the very bottom (aligned center)

</select>
      <br><input type=radio name=inline_image_p value=f> Display a link the viewer can use to download the file
      <center>
      <p><input type=submit value="Add the Attachment">
    </td>
    </tr></table>
  </td></tr>
</table>
</td></tr></table>
</p></center>
</form>

