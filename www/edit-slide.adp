<master>
<property name="title">Edit Slide</property>
<property name="context">@context;noquote@</property>

<form name=f action=edit-slide-2 method=post>

<input type=hidden name=slide_item_id value="@slide_item_id@">
<input type=hidden name=pres_item_id value="@pres_item_id@">
<input type=hidden name=bullet_num value="@bullets:rowcount@">
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

<multiple name="bullets">
<li> <if @bullets.widget@ eq "text">
    <input type="text" name="bullet.@bullets.rownum@" value="@bullets.item@" size="70">
</if><else>
    <textarea wrap="soft" rows="@bullets.rows@" cols="60" name="bullet.@bullets.rownum@">@bullets.item@</textarea>
</else>
<if @bullets.prev@ gt 0><a href="javascript:swapWithNext(@bullets.prev@)"><img src="pics/up.gif" width=18 height=15 border=0></a>
</if><else>
    <img src="pics/1white.gif" width=18 height=15">
</else>
<a href="javascript:swapWithNext(@bullets.rownum@)"><img src="pics/down.gif" width=18 height=15 border=0></a>
</multiple>
<li><input type="text" size="70" name="bullet.@bullet_num@" value="">&nbsp;<a href="javascript:swapWithNext(@bullets:rowcount@)"><img src="pics/up.gif" width=18 height=15 border=0></a><img src="pics/1white.gif" width=18 height=15">

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

