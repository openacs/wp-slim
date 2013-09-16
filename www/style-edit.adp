<master>
<property name="doc(title)">#wp-slim.role_Style#</property>
<property name="context">@context@</property>

<a href="/wp-slim"> Done </a>
<form name=f action=style-edit-2 method=post enctype=multipart/form-data>

@export_form_vars@

<script language=javascript>
@ad_color_widget_js@
</script>

<p><center>
<table border=2 cellpadding=10><tr><td>

<table cellspacing=0 cellpadding=0>
  <tr valign=baseline>
    <th nowrap align=right>#wp-slim.Namenbsp#</th>
    <td><input type=text name=name size=50 value="<%=[ad_quotehtml $name]%>"><br>
<i>#wp-slim.lt_A_descriptive_name_li#
  </tr>
  <tr>
    <th nowrap align=right>#wp-slim.Text_Colornbsp#</th>
    <td><%=[ad_color_widget text_color $text_color 1]%></td>
  </tr>
  <tr>
    <th nowrap align=right>#wp-slim.Background_Colornbsp#</th>
    <td><%=[ad_color_widget background_color $background_color 1]%></td>
  </tr>
  <tr>
    <th nowrap align=right>#wp-slim.Background_Imagenbsp#</th>
    <td>@background_images;noquote@</td>
  </tr>
  <tr>
    <th nowrap align=right>#wp-slim.Link_Colornbsp#</th>
    <td><%=[ad_color_widget link_color $link_color 1]%></td>
  </tr>
  <tr>
    <th nowrap align=right>#wp-slim.lt_Visited_Link_Colornbs#</th>
    <td><%=[ad_color_widget vlink_color $vlink_color 1]%></td>
  </tr>
  <tr>
    <th nowrap align=right>#wp-slim.lt_Active_Link_Colornbsp#</th>
    <td><%=[ad_color_widget alink_color $alink_color 1]%></td>
  </tr>
  <tr>
    <th nowrap align=right>#wp-slim.lt_Available_to_other_pe#</th>
    <td>@public;noquote@ </td>
  </tr>
  <tr>
    <th nowrap align=right valign=top><br>#wp-slim.CSS_Sourcenbsp#</th>
    <td><textarea name=css rows=15 cols=60><%=[ad_quotehtml $css]%></textarea></td>
  </tr>
  <tr><td colspan=2 align=center><hr><input type=submit value="#wp-slim.Save_Style#"></td></tr>
</table>

</td></tr></table>

</center></p>


