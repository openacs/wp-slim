<master src="wp-presentation-master">
<property name="title">@pres_title@</property>
<property name="context">"one presentation"</property>
<property name="style_id">@style@</property>
<property name="page_signature">@page_signature@</property>
<property name="copyright_notice">@copyright_notice@</property>

<table align=right>
<tr>
   <td><a href="@subsite_name@">done</a> 
   <if @first_slide_item_id@ not nil>
   |  <a href="@subsite_name@/display/@pres_item_id@/@first_slide_item_id@.wimpy">next</a>
   </if>
   </td>
</tr>
</table>
       
<h2>@pres_title@</h2>
a Wimpy Point Presentation owned by <a href="/shared/community-member?user_id=@owner_id@">@owner_name@</a>
<if @collaborators:rowcount@ gt 0>
<br> in collaboration with 
<multiple name="collaborators">
<a href="/shared/community-member?user_id=@collaborators.person_id@">@collaborators.full_name@</a>
<if @collaborators.rownum@ lt @collaborators:rowcount@>,&nbsp;</if>
</multiple>
</if>
.
<hr>

<ul>
<multiple name="slides">
        <li><a href="@slides.url@">@slides.slide_title@</a>
</multiple>
</ul>

