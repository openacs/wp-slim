<master>
<property name="title">#wp-slim.WimpyPoint#</property>
<property name="context">@context@</property>

<table border=0 width="100%">
<tr><td align=left>
[ 
<if @show_age@ eq 7>
<b>#wp-slim.Last_Week#</b>
</if>
<else>
<a href=index?show_age=7&@show_user_value@>#wp-slim.Last_Week#</a>
</else>
| 
<if @show_age@ eq 14>
<b>#wp-slim.Last_Two_Weeks#</b>
</if>
<else>
<a href=index?show_age=14&@show_user_value@>#wp-slim.Last_Two_Weeks#</a>
</else>
| 
<if @show_age@ eq 30>
<b>#wp-slim.Last_Month#</b>
</if>
<else>
<a href=index?show_age=30&@show_user_value@>#wp-slim.Last_Month#</a>
</else>
| 
<if @show_age@ eq 0>
<b>#wp-slim.All#</b>
</if>
<else>
<a href=index?show_age=0&@show_user_value@>#wp-slim.All#</a>
</else>
]
</td>


<td align=right>
[ 
<if @show_user@ eq "yours">
<b>#wp-slim.Yours#</b>
| 
<a href=index?show_user=all&@show_age_value@>#wp-slim.Everyones#</a>
</if>
<else>
<a href=index?show_user=yours&@show_age_value@>#wp-slim.Yours#</a>
| 
<b>#wp-slim.Everyones#</b>
</else>
]
</td>
</tr>
</table>

<br>

<h2>#wp-slim.My_Presentations#</h2>

<ul>
<multiple name=presentations>
<li><a href="display/@presentations.pres_item_id@/">@presentations.pres_title@</a>&nbsp;#wp-slim.lt_created_on_presentati# [ <a href="presentation-top?pres_item_id=@presentations.pres_item_id@">#wp-slim.edit#</a> ] [ <a href="presentation-print-view.tcl?item_id=@presentations.pres_item_id@">#wp-slim.print_view#</a> ]
</multiple>      
</ul>


<h2>#wp-slim.Options#</h2>
<ul>
  <li><a href="add-edit-presentation">#wp-slim.lt_Create_a_new_presenta#</a>
  <li><a href="style-list">#wp-slim.Edit_your_styles#</a>
  <li>#wp-slim.Show_a_list_of# <a href="users">#wp-slim.all_WimpyPoint_users#</a>       
</ul>


<if @show_user@ eq "all">
<h2> #wp-slim.lt_Everyones_Presentatio#</h2>

<ul>
<multiple name=allpresentations>
<li><a href="display/@allpresentations.pres_item_id@/">@allpresentations.pres_title@</a> #wp-slim.lt_created_by_a_hrefshar# 
<if @allpresentations.edit_p@ eq "t">
[ <a href="presentation-top?pres_item_id=@allpresentations.pres_item_id@">#wp-slim.edit#</a> ]
</if>
&nbsp;[ <a href="presentation-print-view.tcl?item_id=@allpresentations.pres_item_id@">#wp-slim.print_view#</a> ]
</multiple>
</ul>
</if>


