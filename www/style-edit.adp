<master>
<property name="title">@role@ Style</property>
<property name="context">@context@</property>


<form name=f action=style-edit-2 method=post enctype=multipart/form-data>
<h2>Create Style</h2>

@export_form_vars@

<script language=javascript>
@ad_color_widget_js@
</script>

<p><center>
<table border=2 cellpadding=10><tr><td>

<table cellspacing=0 cellpadding=0>
  <tr valign=baseline>
    <th nowrap align=right>Name:&nbsp;</th>
    <td><input type=text name=name size=50 value="<%=[philg_quote_double_quotes $name]%>"><br>
<i>A descriptive name, like @ramdom_name@.
  </tr>
  <tr>
    <th nowrap align=right>Text Color:&nbsp;</th>
    <td><%=[ad_color_widget text_color $text_color 1]%></td>
  </tr>
  <tr>
    <th nowrap align=right>Background Color:&nbsp;</th>
    <td><%=[ad_color_widget background_color $background_color 1]%></td>
  </tr>
  <tr>
    <th nowrap align=right>Background Image:&nbsp;</th>
    <td>@background_images@</td>
  </tr>
  <tr>
    <th nowrap align=right>Link Color:&nbsp;</th>
    <td><%=[ad_color_widget link_color $link_color 1]%></td>
  </tr>
  <tr>
    <th nowrap align=right>Visited Link Color:&nbsp;</th>
    <td><%=[ad_color_widget vlink_color $vlink_color 1]%></td>
  </tr>
  <tr>
    <th nowrap align=right>Active Link Color:&nbsp;</th>
    <td><%=[ad_color_widget alink_color $alink_color 1]%></td>
  </tr>
  <tr>
    <th nowrap align=right>Available to other people? (Public):&nbsp;</th>
    <td>@public@ </td>
  </tr>
  <tr>
    <th nowrap align=right valign=top><br>CSS Source:&nbsp;</th>
    <td><textarea name=css rows=15 cols=60><%=[philg_quote_double_quotes $css]%></textarea></td>
  </tr>
  <tr><td colspan=2 align=center><hr><input type=submit value="Save Style"></td></tr>
</table>

</td></tr></table>

</center></p>

