<master>
<property name="title">One Style</property>
<property name="context">@context@</property>

<form name=f action=style-image-add method=post enctype=multipart/form-data>

@export_form_vars@

<p><center>
<table border=2 cellpadding=10><tr><td>

<table cellspacing=0 cellpadding=0>
  <tr valign=baseline>
    <th nowrap align=right>Name:&nbsp;</th>
    <td colspan=5>@name@</td>
  </tr>
  <tr valign=top>
    <th nowrap align=right><br>Color Scheme:&nbsp;</th>
    <td colspan=5>
      <table border=2 @bgcolor_str@ cellpadding=10>
        <tr><td @bgimage_str@>
          @text_color_font@Plain Text@text_color_font_end@<br>
          @link_color_font@<u>Linked Text</u>@link_color_font_end@<br>
          @vlink_color_font@<u>Linked Text (Visited)</u>@alink_color_font_end@<br>
          @alink_color_font@<u>Linked Text (Active)</u>@vlink_color_font_end@
        </td></tr>
      </table>
    </td>
  <tr>
    <th nowrap align=right>CSS Code:&nbsp;</th>
      <td colspan=5><%=[expr { [regexp {[^ \n\r\t]} $css] ? "<a href=\"[ad_conn package_url]styles/$style_id/style.css\">view</a>" : "none" }]%></td>
  </tr>
  <tr>
    <td align=center colspan=5><br><input type=button onClick="location.href='style-edit?@url_vars@'" value="Edit Style"><hr></td>
  </tr>

<if @style_images:rowcount@ eq 0>
	<tr><th align=right>Images:&nbsp;</th><td>(none)</td></tr>
</if>
<else>
	<tr><th>
	Images:&nbsp; 
	</th></tr>
<multiple name="style_images">
	<tr>
	<td><a href="view-image?revision_id=@style_images.wp_style_images_id@">@style_images.file_name@</a></td>
	<td>&nbsp;</td>
<td align=right>@style_images.file_size@&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
<td align=right><a href="style-image-delete?style_id=@style_id@&revision_id=@style_images.wp_style_images_id@">delete</a></td>
</tr>

</multiple>
</else>






  <tr>
    <td colspan=5 align=center>
      <br><br><b>Add an image:</b><br>
      <input name=image type=file size=30><br>
      <p><input type=submit value="Save Image">
    </td>
  </tr>
</table>

</td></tr></table>

</center></p>
</form>
