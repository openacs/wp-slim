<master src="master">
<property name="title">@pres_title@</property>


<table align=right>
<tr>
   <td><a href="@subsite_name@">done</a> | 
   <if @first_slide_item_id@ not nil>
   <a href="@first_slide_item_id@.wimpy">next</a>
   </if>
   </td>
</tr>
</table>
       
<h2>@pres_title@</h2>
a Wimpy Point Presentation owned by <a href="/shared/community-member?user_id=@owner_id@">@owner_name@</a>
<hr>

<ul>
<multiple name="slides">
        <li><a href="@slides.url@">@slides.slide_title@</a>
</multiple>
</ul>

@page_signature@
