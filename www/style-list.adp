<master>
<property name="title">Your Styles</property>
<property name="context">@context@</property>

<p><center>

<table border=2 cellpadding=10><tr><td>
<table cellspacing=0 cellpadding=0>
<tr>
<th align=left>Style</th><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
<th align=right>#&nbsp;Images</th><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
<th align=right>Total Size</th><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
</tr>
<tr><td colspan=7><hr></td></tr>

<if @styles_select:rowcount@ gt 0>
<multiple name="styles_select">
	<tr><td><a href="style-view?style_id=@styles_select.style_id@">@styles_select.name@</a></td><td></td>
<td align=right>@styles_select.images@</td><td></td>

    <if @total_size@ ne "">
        <td align=right>@styles_select.total_size@</td>
    </if>
    <else>
	<td align=right>-</td>
    </else>
    <td></td><td>[ <a href="style-delete?style_id=@styles_select.style_id@">delete</a> ]</td></tr>

</multiple>
</if>
<else>
	<tr><td align=center colspan=7><i>You haven't created any styles.</i></td></tr>
</else>

<tr><td colspan=7 align=center><hr><b><a href="style-edit"	>Create a new style</a></b></td></tr>

</table>
</td></tr></table>

</center></p>
