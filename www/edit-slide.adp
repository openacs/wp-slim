<master src="master">
<property name="title">Edit Slide</property>
<property name="context">@context@</property>

<form name=f action=edit-slide-2 method=post>

<input type=hidden name=slide_item_id value="@slide_item_id@">
<input type=hidden name=pres_item_id value="@pres_item_id@">
<input type=hidden name=bullet_num value="@bullet_num@">
<input type=hidden name=sort_key value="@sort_key@">
<input type=hidden name=original_slide_id value="@original_slide_id@">

<script language=javascript>

function swapWithNext(index)
{
  var val = document.f['bullet.' + index].value;
  document.f['bullet.' + index].value = document.f['bullet.' + (index+1)].value;
  document.f['bullet.' + (index+1)].value = val;
}

</script>

<table>
  <tr>
    <th align=right nowrap>Slide Title:&nbsp;</th>
    <td><input type=text name=slide_title value="@slide_title@" size=50></td>
  </tr>
  <tr valign=top>
    <th align=right nowrap><br>Preamble:</th>
    <td>
      <textarea rows=4 cols=70 name=preamble wrap=virtual>@preamble@</textarea><br>
      <i>(optional random text that goes above the bullet list)</i>
    </td>
  </tr>
  <tr valign=baseline>
    <th align=right nowrap>Bullet Items:</th>
    <td>
      <ul>
        <input type=hidden name=array_max value=<%=[expr $bullet_num + 2]%>>
<list name="bullet_items">
  <if @bullet_items:rownum@ eq 1>
    <li><input type=text size=60 name=bullet.1 value="@bullet_items:item@">&nbsp;<img src="pics/1white.gif" width=18 height=15"><a href="javascript:swapWithNext(1)"><img src="pics/down.gif" width=18 height=15 border=0></a>
  </if>
<else>
  <li><input type=text size=60 name=bullet.@bullet_items:rownum@ value="@bullet_items:item@">&nbsp;<a href="javascript:swapWithNext(<%=[expr @bullet_items:rownum@ - 1]%>)"><img src="pics/up.gif" width=18 height=15 border=0></a><a href="javascript:swapWithNext(@bullet_items:rownum@)"><img src="pics/down.gif" width=18 height=15 border=0></a>
</else>
</list>
<li><input type=text size=60 name=bullet.<%=[expr $bullet_num + 1]%> value="">&nbsp;<a href="javascript:swapWithNext(@bullet_num@)"><img src="pics/up.gif" width=18 height=15 border=0></a><img src="pics/1white.gif" width=18 height=15">

        <br><i>You can add additional bullets later.</i>
      </ul>
    </td>
  </tr>
  <tr valign=top>
    <th align=right nowrap><br>Postamble:</th>
    <td>
      <textarea rows=4 cols=70 name=postamble wrap=virtual>@postamble@</textarea><br>
      <i>(optional random text that goes after the bullet list)</i>
    </td>
  </tr>
</table>

<p><center>
<input type=submit name=button value="Save Slide">
<spacer type=horizontal size=50>
<input type=submit name=button value="Upload Attachments">
</center>
</form>



