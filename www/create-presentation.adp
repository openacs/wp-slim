<master>
<property name="title">#wp-slim.Create_Presentation#</property>
<property name="context">@context@</property>

<form method=POST action="create-presentation-2">

<table>
<tr>
    <td></td><td>
#wp-slim.lt_Give_this_presentatio#
    </td>
  </tr>
  <tr>
    <th nowrap align=right>#wp-slim.Title#</th>
    <td><input type=text name=pres_title size=50 maxlength="400" value=""></td>
  </tr>
  <tr>
    <td></td><td>
#wp-slim.lt_If_you_want_a_signatu#
    </td>
  </tr>
  <tr>
    <th nowrap align=right>#wp-slim.Page_Signature#</th>
    <td><input type=text name=page_signature size=50 maxlength="200" value=""></td>
  </tr>
  <tr>
    <td></td><td>
#wp-slim.lt_Personally_I_like_to_#

<p>#wp-slim.lt_If_you_want_a_copyrig#
    </td>
  </tr>
  <tr>
    <th nowrap align=right>#wp-slim.Copyright_Notice#</th>
    <td><input type=text name=copyright_notice size=50 maxlength="400" value=""></td>
  </tr>
  <tr>
    <td></td><td>
#wp-slim.lt_WimpyPoint_keeps_trac#
    </td>
  </tr>
  <tr>
    <th nowrap align=right>#wp-slim.lt_Show_Modification_Dat#</th>
    <td>
<input type=radio name=show_modified_p value=t > #wp-slim.Yes#
<input type=radio name=show_modified_p value=f checked> #wp-slim.No#
    </td>
  </tr>
  <tr>
    <td></td><td>
#wp-slim.lt_If_you_want_to_hide_t#
    </td>
  </tr>
  <tr>
    <th nowrap align=right>#wp-slim.Available_to_Public#</th>
    <td>
<input type=radio name=public_p value=t > #wp-slim.Yes#
<input type=radio name=public_p value=f checked> #wp-slim.No#
    </td>
  </tr>
  <tr>
    <td></td><td>
#wp-slim.lt_Suggestion_if_you_hav#


    </td>
  </tr>
  <tr>
    <th nowrap align=right>#wp-slim.Style#</th>
    <td>@available_styles;noquote@
    </td>
  </tr>
  <tr>
    <td></td><td>
<p>#wp-slim.lt_Finally_if_youre_plan#
    </td>
  </tr>
  <tr valign=top>
    <th nowrap align=right><br>#wp-slim.Audience#</th>
    <td><textarea name=audience rows=4 cols=50
wrap=virtual>#wp-slim.Audience#</textarea></td>
  </tr>
  <tr valign=top>
    <th nowrap align=right><br>#wp-slim.Background#</th>
    <td><textarea name=background rows=4 cols=50 
wrap=virtual>#wp-slim.Background#</textarea></td>
  </tr>

</table>
<center><input type=submit value="#wp-slim.Save_Presentation#"></center>
</form>

