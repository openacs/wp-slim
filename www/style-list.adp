<master>
<property name="doc(title)">#wp-slim.Your_Styles#</property>
<property name="context">@context@</property>
<a href="/wp-slim"> Done </a>
<p><center>

<table border="2" cellpadding="10"><tr><td>
<table cellspacing="0" cellpadding="0">
<tr>
<th align="left">#wp-slim.Style_1#</th><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
<th align="right">#wp-slim.nbspImages#</th><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
<th align="right">#wp-slim.Total_Size#</th><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
</tr>
<tr><td colspan="7"><hr></td></tr>

<if @styles_select:rowcount@ gt 0>
<multiple name="styles_select">
	<tr><td><a href="style-view?style_id=@styles_select.style_id@">@styles_select.name@</a></td><td></td>
<td align="right">@styles_select.images@</td><td></td>

    <if @total_size@ ne "">
        <td align="right">@styles_select.total_size@</td>
    </if>
    <else>
	<td align="right">-</td>
    </else>
    <td></td><td>[ <a href="style-delete?style_id=@styles_select.style_id@">#wp-slim.delete#</a> ]</td></tr>

</multiple>
</if>
<else>
	<tr><td align="center" colspan="7"><i>#wp-slim.lt_You_havent_created_an#</i></td></tr>
</else>

<tr><td colspan="7" align="center"><hr><b><a href="style-edit">#wp-slim.Create_a_new_style#</a></b></td></tr>

</table>
</td></tr></table>

</center></p>

