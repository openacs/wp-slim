<master src="wp-presentation-master">
<property name="doc(title)">@pres_title@</property>
<property name="context">#wp-slim.One_Presentation#</property>
<property name="style_id">@style@</property>
<property name="page_signature">@page_signature@</property>
<property name="copyright_notice">@copyright_notice@</property>

<table align=right>
<tr>
   <td><a href="@subsite_name@">#wp-slim.done#</a> 
   <if @first_slide_item_id@ not nil>
   |  <a href="@subsite_name@/display/@pres_item_id@/@first_slide_item_id@.wimpy">#wp-slim.next#</a>
   </if>
   </td>
</tr>
</table>
       
<h2>@pres_title;noquote@</h2>
#wp-slim.lt_a_Wimpy_Point_Present# <a href="/shared/community-member?user_id=@owner_id@">@owner_name@</a>
<if @collaborators:rowcount@ gt 0>
<br> #wp-slim.lt_in_collaboration_with# 
<multiple name="collaborators">
<a href="/shared/community-member?user_id=@collaborators.person_id@">@collaborators.full_name@</a>
<if @collaborators.rownum@ lt @collaborators:rowcount@>,&nbsp;</if>
</multiple>
</if>
.
<hr>

<ul>
<multiple name="slides">
        <li><a href="@slides.url@">@slides.slide_title;noquote@</a>
</multiple>
</ul>


