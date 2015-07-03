<master>
<property name="doc(title)">#wp-slim.One_Style#</property>
<property name="context">@context;literal@</property>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="/wp-slim">Done</a>
<form name=f action=style-image-add method=post enctype=multipart/form-data>

@export_form_vars;noquote@

<p><center>
<table border="2" cellpadding="10"><tr><td>

<table cellspacing="0" cellpadding="0">
  <tr valign="baseline">
    <th nowrap align="right">#wp-slim.Namenbsp#</th>
    <td colspan="5">@name@</td>
  </tr>
  <tr valign="top">
    <th nowrap align="right"><br>#wp-slim.Color_Schemenbsp#</th>
    <td colspan="5">
      <table border="2" @bgcolor_str@ cellpadding="10">
        <tr><td @bgimage_str@>
          #wp-slim.lt_text_color_fontPlain_#<br>
          @link_color_font;noquote@<u>#wp-slim.Linked_Text#</u>@link_color_font_end;noquote@<br>
          @vlink_color_font;noquote@<u>#wp-slim.Linked_Text_Visited#</u>@alink_color_font_end;noquote@<br>
          @alink_color_font;noquote@<u>#wp-slim.Linked_Text_Active#</u>@vlink_color_font_end;noquote@
        </td></tr>
      </table>
    </td>
  <tr>
    <th nowrap align="right">#wp-slim.CSS_Codenbsp#</th>
      <td colspan="5"><%=[expr { [regexp {[^ \n\r\t]} $css] ? "<a href="\"[ad_conn" package_url]styles/$style_id/style.css\">#wp-slim.view#</a>" : "none" }]%></td>
  </tr>
  <tr>
    <td align="center" colspan="5"><br><input type="button" onClick="location.href='style-edit?@url_vars@'" value="#wp-slim.Edit_Style#"><hr></td>
  </tr>

<if @style_images:rowcount@ eq 0>
	<tr><th align="right">#wp-slim.Imagesnbsp#</th><td>#wp-slim.none#</td></tr>
</if>
<else>
	<tr><th>
	#wp-slim.Imagesnbsp# 
	</th></tr>
<multiple name="style_images">
	<tr>
	<td><a href="view-image?revision_id=@style_images.wp_style_images_id@">@style_images.file_name@</a></td>
	<td>&nbsp;</td>
<td align="right">@style_images.file_size@&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
<td align="right"><a href="style-image-delete?style_id=@style_id@&amp;revision_id=@style_images.wp_style_images_id@">#wp-slim.delete#</a></td>
</tr>

</multiple>
</else>






  <tr>
    <td colspan="5" align="center">
      <br><br><b>#wp-slim.Add_an_image#</b><br>
      <input name="image" type="file" size="30"><br>
      <p><input type="submit" value="#wp-slim.Save_Image#">
    </td>
  </tr>
</table>

</td></tr></table>

</center></p>
</form>

