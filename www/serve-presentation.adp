<master src="wp-presentation-master">
<property name="title">@pres_title;noquote@</property>
<property name="context">"one presentation"</property>

<table align=right>
<tr>
   <td><a href="@subsite_name@">done</a> | 
   <if @first_slide_item_id@ not nil>
   <a href="@subsite_name@/display/@pres_item_id@/@first_slide_item_id@.wimpy">next</a>
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

<p>Here is a <a href="@subsite_name@/presentation-print-view.tcl?item_id=@pres_item_id@">printer-friendly</a> version of the presentation.
  <br>
@page_signature@
