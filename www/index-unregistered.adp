<master>
<property name="title">WimpyPoint</property>
<property name="context"></property>

<table border=0 width="100%">
<tr><td align=left>
[ 
<if @show_age@ eq 7>
<b>Last Week</b>
</if>
<else>
<a href=index?show_age=7>Last Week</a>
</else>
| 
<if @show_age@ eq 14>
<b>Last Two Weeks</b>
</if>
<else>
<a href=index?show_age=14>Last Two Weeks</a>
</else>
| 
<if @show_age@ eq 20>
<b>Last Month</b>
</if>
<else>
<a href=index?show_age=30>Last Month</a>
</else>
| 
<if @show_age@ eq 0>
<b>All</b>
</if>
<else>
<a href=index?show_age=0>All</a>
</else>
]
</td>
<td align=right>
<h2>Options</h2>
<ul>
  <li>To create or edit presentations, please <a href="/register/?return_url=@return_url@">log in</a>
  <li>Show a list of <a href="users">all WimpyPoint users.</a>       
</ul>
</td>
</tr>
</table>
<br>

<h2> Everyone's Presentations</h2>

<ul>
<multiple name=allpresentations>
<li><a href="display/@allpresentations.pres_item_id@/">@allpresentations.pres_title@</a> created by <a href="/shared/community-member?user_id=@allpresentations.creation_user@">@allpresentations.full_name@</a> on @allpresentations.creation_date@
</multiple>
</ul>

