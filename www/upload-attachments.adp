<master>
<property name="doc(title)">#wp-slim.Upload_Attachments#</property>
<property name="context">@context@</property>

<form enctype=multipart/form-data action=attach method=post>
<input type=hidden name=slide_item_id value="@slide_item_id@">
<input type=hidden name=pres_item_id value="@pres_item_id@">

<center><p>
<table border=2 cellpadding=10><tr><td>
<table cellspacing=0 cellpadding=0>
<tr><td colspan=7><hr></td></tr>

<tr><td colspan=7 align=center><i>#wp-slim.There_are_#
<if @attachment_count@ eq 0>
@attachment_count@
</if>
<else>
<a href="attach-list?slide_item_id=@slide_item_id@&pres_item_id=@pres_item_id@">@attachment_count@</a>
</else>
#wp-slim.lt_attachments_currently#</i></td></tr>


  <tr valign=top><td colspan=7>
    <center>
      <br><a href="display/@pres_item_id@/@slide_item_id@.wimpy" target="_blank">#wp-slim.Preview_the_Slide#</a>
    </center>
    </p>
    <hr>
    <center>
      <br><b>#wp-slim.lt_Add_an_Image_or_Attac#</b>
      <p><input type=file size=30 name=attachment>
    </center>
    <p><input type=radio name=inline_image_p value=t checked> #wp-slim.Display_as_an_image#
<select name=display>
<option value=top >#wp-slim.lt_at_the_very_top_align#
<option value=preamble selected>#wp-slim.lt_next_to_the_preamble_#
<option value=after_preamble >#wp-slim.lt_after_the_preamble_al#
<option value=bullets >#wp-slim.lt_next_to_the_bullets_a#
<option value=after_bullets >#wp-slim.lt_after_the_bullets_ali#
<option value=postamble >#wp-slim.lt_next_to_the_postamble#
<option value=bottom >#wp-slim.lt_at_the_very_bottom_al#

</select>
      <br><input type=radio name=inline_image_p value=f> #wp-slim.lt_Display_a_link_the_vi#
      <center>
      <p><input type=submit value="Add the Attachment">
    </td>
    </tr></table>
  </td></tr>
</table>
</td></tr></table>
</p></center>
</form>


