<master>
<property name="title">WimpyPoint</property>
<property name="context">@context@</property>

<table border=0 width="100%">
<tr><td align=left>
[ 
<if @show_age@ eq 7>
<b>Last Week</b>
</if>
<else>
<a href=index?show_age=7&@show_user_value@>Last Week</a>
</else>
| 
<if @show_age@ eq 14>
<b>Last Two Weeks</b>
</if>
<else>
<a href=index?show_age=14&@show_user_value@>Last Two Weeks</a>
</else>
| 
<if @show_age@ eq 30>
<b>Last Month</b>
</if>
<else>
<a href=index?show_age=30&@show_user_value@>Last Month</a>
</else>
| 
<if @show_age@ eq 0>
<b>All</b>
</if>
<else>
<a href=index?show_age=0&@show_user_value@>All</a>
</else>
]
</td>


<td align=right>
[ 
<if @show_user@ eq "yours">
<b>Yours</b>
| 
<a href=index?show_user=all&@show_age_value@>Everyone's</a>
</if>
<else>
<a href=index?show_user=yours&@show_age_value@>Yours</a>
| 
<b>Everyone's</b>
</else>
]
</td>
</tr>
</table>

<h2>My Presentations</h2>

<ul>
<multiple name=presentations>
<li><a href="display/@presentations.pres_item_id@/">@presentations.pres_title@</a> created on @presentations.creation_date@ [ <a href="presentation-top?pres_item_id=@presentations.pres_item_id@">edit</a> ] [<a href="presentation-print-view.tcl?item_id=@presentations.pres_item_id@">print view </a>]
</multiple>      
</ul>


<h2>Options</h2>
<ul>
  <li><a href="create-presentation">Create a new presentation.</a>
  <li><a href="style-list">Edit your styles.</a>
  <li>Show a list of <a href="users">all WimpyPoint users.</a>       
</ul>


<if @show_user@ eq "all">
<h2> Everyone's Presentations</h2>

<ul>
<multiple name=allpresentations>
<li><a href="display/@allpresentations.pres_item_id@/">@allpresentations.pres_title@</a> created by <a href="/shared/community-member?user_id=@allpresentations.creation_user@">@allpresentations.full_name@</a> on @allpresentations.creation_date@ 
<if @allpresentations.edit_p@ eq "t">
[ <a href="presentation-top?pres_item_id=@allpresentations.pres_item_id@">edit</a> ] [<a href="presentation-print-view.tcl?item_id=@allpresentations.pres_item_id@">print view </a>]
</if>
</multiple>
</ul>
</if>

