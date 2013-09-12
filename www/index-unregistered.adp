<master>
<property name="doc(title)">#wp-slim.WimpyPoint#</property>
<property name="context"></property>

<table border=0 width="100%">
<tr><td align=left>
[ 
<if @show_age@ eq 7>
<b>#wp-slim.Last_Week#</b>
</if>
<else>
<a href=index?show_age=7>#wp-slim.Last_Week#</a>
</else>
| 
<if @show_age@ eq 14>
<b>#wp-slim.Last_Two_Weeks#</b>
</if>
<else>
<a href=index?show_age=14>#wp-slim.Last_Two_Weeks#</a>
</else>
| 
<if @show_age@ eq 20>
<b>#wp-slim.Last_Month#</b>
</if>
<else>
<a href=index?show_age=30>#wp-slim.Last_Month#</a>
</else>
| 
<if @show_age@ eq 0>
<b>#wp-slim.All#</b>
</if>
<else>
<a href=index?show_age=0>#wp-slim.All#</a>
</else>
]
</td>
<td align=right>
<h2>#wp-slim.Options#</h2>
<ul>
  <li>#wp-slim.lt_To_create_or_edit_pre# <a href="/register/?return_url=@return_url@">#wp-slim.log_in#</a>
  <li>#wp-slim.Show_a_list_of# <a href="users">#wp-slim.all_WimpyPoint_users#</a>       
</ul>
</td>
</tr>
</table>
<br>

<h2> #wp-slim.lt_Everyones_Presentatio#</h2>

<ul>
<multiple name=allpresentations>
<li><a href="display/@allpresentations.pres_item_id@/">@allpresentations.pres_title@</a>&nbsp;#wp-slim.lt_created_by_a_hrefshar#
</multiple>
</ul>


