<master src="master">
<property name="title">Create A Slide</property>

<h2>@pres_title@</h2>
@nav_bar@
<hr>


<form name=f action=create-slide-2 method=post>

<input type=hidden name=pres_item_id value="@pres_item_id@">
<input type=hidden name=sort_key value="@sort_key@">

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
    <td><input type=text name=slide_title value="" size=50></td>
  </tr>
  <tr valign=top>
    <th align=right nowrap><br>Preamble:</th>
    <td>
      <textarea rows=4 cols=70 name=preamble wrap=virtual></textarea><br>
      <i>(optional random text that goes above the bullet list)</i>
    </td>
  </tr>
  <tr valign=baseline>
    <th align=right nowrap>Bullet Items:</th>
    <td>
      <ul>
        <input type=hidden name=array_max value="5">
<li><input type=text size=60 name=bullet.1 value="">&nbsp;<img src="pics/1white.gif" width=18 height=15"><a href="javascript:swapWithNext(1)"><img src="pics/down.gif" width=18 height=15 border=0></a>
<li><input type=text size=60 name=bullet.2 value="">&nbsp;<a href="javascript:swapWithNext(1)"><img src="pics/up.gif" width=18 height=15 border=0></a><a href="javascript:swapWithNext(2)"><img src="pics/down.gif" width=18 height=15 border=0></a>
<li><input type=text size=60 name=bullet.3 value="">&nbsp;<a href="javascript:swapWithNext(2)"><img src="pics/up.gif" width=18 height=15 border=0></a><a href="javascript:swapWithNext(3)"><img src="pics/down.gif" width=18 height=15 border=0></a>
<li><input type=text size=60 name=bullet.4 value="">&nbsp;<a href="javascript:swapWithNext(3)"><img src="pics/up.gif" width=18 height=15 border=0></a><a href="javascript:swapWithNext(4)"><img src="pics/down.gif" width=18 height=15 border=0></a>
<li><input type=text size=60 name=bullet.5 value="">&nbsp;<a href="javascript:swapWithNext(4)"><img src="pics/up.gif" width=18 height=15 border=0></a><img src="pics/1white.gif" width=18 height=15">

        <br><i>You can add additional bullets later.</i>
      </ul>
    </td>
  </tr>
  <tr valign=top>
    <th align=right nowrap><br>Postamble:</th>
    <td>
      <textarea rows=4 cols=70 name=postamble wrap=virtual></textarea><br>
      <i>(optional random text that goes after the bullet list)</i>
    </td>
  </tr>
</table>

<p><center>
<input type=submit value="Save Slide">
</center>
</form>

