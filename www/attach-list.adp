<master>
<property name="doc(title)">#wp-slim.List_of_Attachments#</property>
<property name="context">@context;literal@</property>
<ul>
<multiple name="att">
<li>@att.name@ (<a href="attach-del?slide_item_id=@slide_item_id@&amp;attach_item_id=@att.item_id@&amp;pres_item_id=@pres_item_id@">#wp-slim.remove#</a> | <a href="attach-detail?slide_item_id=@slide_item_id@&amp;attach_item_id=@att.item_id@&amp;file_name=@att.name@&amp;pres_item_id=@pres_item_id@">#wp-slim.details#</a>)
</multiple>
</ul>

<form enctype=multipart/form-data action=attach method=post>
<input type="hidden" name="slide_item_id" value="@slide_item_id@">
<input type="hidden" name="pres_item_id" value="@pres_item_id@">

      <br><b>#wp-slim.lt_Add_an_Image_or_Attac#</b>
      <p><input type="file" size="30" name="attachment">
    <p><input type="radio" name="inline_image_p" value="t" checked> #wp-slim.Display_as_an_image#
<select name=display>
<option value=top>#wp-slim.lt_at_the_very_top_align#
<option value=preamble selected>#wp-slim.lt_next_to_the_preamble_#
<option value=after_preamble>#wp-slim.lt_after_the_preamble_al#
<option value=bullets>#wp-slim.lt_next_to_the_bullets_a#
<option value=after_bullets>#wp-slim.lt_after_the_bullets_ali#
<option value=postamble>#wp-slim.lt_next_to_the_postamble#
<option value=bottom>#wp-slim.lt_at_the_very_bottom_al#

</select>
      <br><input type="radio" name="inline_image_p" value="f"> #wp-slim.lt_Display_a_link_the_vi#
      <p><input type="submit" value="#wp-slim._Add#">
</form>

