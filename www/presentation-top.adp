<master>
<property name="doc(title)">@presentation_title;literal@</property>
<property name="context">@context;literal@</property>

<h3>#wp-slim.The_Slides#</h3>
   <if  @slides:rowcount@ eq 0>
      <a href="add-edit-slide?sort_key=1&amp;edit_preamble=1&amp;pres_item_id=@pres_item_id@">#wp-slim.lt_Create_the_first_slid#</a>
   </if>
   <else>
     <table border="0" cellspacing="10" cellpadding="0">
     <multiple name="slides">
     <tr>
     <td>@slides.sort_key@.</td>
     <td> <a href="@subsite_name@display/@pres_item_id@/@slides.slide_item_id@.wimpy">@slides.slide_title;noquote@</a> </td>
     <td>
     [ #wp-slim.Preamble#
     <a href="add-edit-slide?slide_item_id=@slides.slide_item_id@&amp;pres_item_id=@pres_item_id@&amp;edit_slide=1&amp;edit_preamble=1">
     #wp-slim.edit#</a> |
     #wp-slim.Postamble#
     <a href="add-edit-slide?slide_item_id=@slides.slide_item_id@&amp;pres_item_id=@pres_item_id@&amp;edit_slide=1&amp;edit_preamble=0">
     #wp-slim.edit#</a> |
<if @delete_p@ eq t>
  <a href="delete-slide?slide_item_id=@slides.slide_item_id@&amp;pres_item_id=@pres_item_id@&amp;slide_title=@slides.slide_title@">#wp-slim.delete#</a> |
</if>
<a href="attach-list?slide_item_id=@slides.slide_item_id@&amp;pres_item_id=@pres_item_id@">#wp-slim.attach#</a> |
<a href="slide-revisions?slide_item_id=@slides.slide_item_id@&amp;pres_item_id=@pres_item_id@">#wp-slim.view_revisions#</a>]
     </td>
     <td> <img src="pics/arrow.gif" alt="#wp-slim.arrow#" align=top> <font size=-1><a href="add-edit-slide?pres_item_id=@pres_item_id@&amp;sort_key=@slides.sort_key@">#wp-slim.Insert#</a></font> </td>
     </tr>
     </multiple>
     <tr>
     <td></td>
     <td> <a href="slides-reorder?pres_item_id=@pres_item_id@">#wp-slim.lt_Change_order_of_slide#</a> </td>
     <td></td>
     <td> <img src="pics/arrow.gif" alt="#wp-slim.arrow#" align=top> <font size=-1><a href="add-edit-slide?pres_item_id=@pres_item_id@">#wp-slim.Add#</a></font> </td>
     </tr>
     </table>
</else>


<h3>#wp-slim.Options#</h3>
<ul>
<li> <a href="display/@pres_item_id@/">#wp-slim.Show_presentation#</a>
<li> <a href="presentation-print-view.tcl?item_id=@pres_item_id@">#wp-slim.lt_Printer_friendly_view# </a>
<li> <a href="add-edit-presentation?pres_item_id=@pres_item_id@">#wp-slim.lt_Edit_presentation_pro#</a>
<if @delete_p@ eq t>
  <li> <a href="delete-presentation?pres_item_id=@pres_item_id@&title=@encoded_title@">#wp-slim.lt_Delete_this_presentat#</a>
</if>
</ul>

<h3>#wp-slim.lt_Viewers__Collaborator#</h3>

<ul>
<if @public_p@ eq t>
  <li> #wp-slim.lt_Everyone_can_view_the#
</if>
<multiple name="users">
  <li><a href="/shared/community-member?user_id=@users.person_id@">@users.full_name@</a>
  <if @users.person_id@ eq @creation_user@>
    #wp-slim.creator#
  </if>
  <if @users.person_id@ eq @user_id@>
    #wp-slim.You#
  </if>
  <if @users.privilege@ eq "wp_admin_presentation">
  #wp-slim._admin_#
  </if>
  <elseif @users.privilege@ eq "wp_edit_presentation">
  #wp-slim._editor_#
  </elseif>
  <else>
  #wp-slim._viewer_#
  </else>
</multiple>

<if @admin_p@ eq t>
  <li><a href="presentation-acl?pres_item_id=@pres_item_id@">#wp-slim.lt_Change_people_who_can#</a>
<if @show_comments_p@ eq "t">
  <li>#wp-slim.lt_All_viewers_can_see_t#<a href="toggle-comments-view?pres_item_id=@pres_item_id@&amp;presentation_id=@presentation_id@&view=f">#wp-slim.lt_make_available_only_f#</a>)
	</if>
<else>
  <li>#wp-slim.lt_Editors_can_see_the_c#<a href="toggle-comments-view?pres_item_id=@pres_item_id@&amp;presentation_id=@presentation_id@&view=t">#wp-slim.lt_make_available_to_all#</a>)
</else>
</if>
</ul>


<h3>#wp-slim.Versioning#</h3>

<ul>
<li><a href="presentation-revisions?pres_item_id=@pres_item_id@">#wp-slim.lt_All_revisions_of_this#</a>
</ul>

