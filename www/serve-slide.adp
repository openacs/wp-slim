<master src="master">
<property name="title">@slide_title@</property>

<table align=right>
<tr>
        <td>@href_back_forward@</td>
</tr>
</table>
<h2>@slide_title@</h2>
<hr>

<if @show_modified_p@ eq t>
<i>Last modified @modified_date@</i>
</if>

<multiple name="attach_list">
        <if @attach_list.display@ eq "top">
          <img src="@subsite_name@/attach/@attach_list.attach_id@/@attach_list.file_name@" alt="@attach_list.file_name@">         
        </if>
</multiple>

<table width=100%>
<tr>
<td>
<p>@preamble@
</td>
<td align=right>
<multiple name="attach_list">
        <if @attach_list.display@ eq "preamble">
          <img src="@subsite_name@/attach/@attach_list.attach_id@/@attach_list.file_name@" alt="@attach_list.file_name@">         
        </if>
</multiple>
</td>
</tr>
</table>

<multiple name="attach_list">
        <if @attach_list.display@ eq "after_preamble">
          <img src="@subsite_name@/attach/@attach_list.attach_id@/@attach_list.file_name@" alt="@attach_list.file_name@">         
        </if>
        <if @attach_list.display@ nil>
          <a href="@subsite_name@/attach/@attach_list.attach_id@/@attach_list.file_name@" alt="@attach_list.file_name@">@attach_list.file_name@</a>
        </if>
</multiple>

<table width=100%>
<tr>
<td>
<ul>
<list name="bullet_items">
        <li>@bullet_items:item@
</list>
</ul>
</td>

<td align=right>
<multiple name="attach_list">
        <if @attach_list.display@ eq "bullets">
          <img src="@subsite_name@/attach/@attach_list.attach_id@/@attach_list.file_name@" alt="@attach_list.file_name@">         
        </if>
</multiple>
</td>
</tr>
</table>

<multiple name="attach_list">
        <if @attach_list.display@ eq "after_bullets">
          <img src="@subsite_name@/attach/@attach_list.attach_id@/@attach_list.file_name@" alt="@attach_list.file_name@">         
        </if>
</multiple>

<table width=100%>
<tr>
<td>
<p>@postamble@
</td>
<td align=right>
<multiple name="attach_list">
        <if @attach_list.display@ eq "postamble">
          <img src="@subsite_name@/attach/@attach_list.attach_id@/@attach_list.file_name@" alt="@attach_list.file_name@">         
        </if>
</multiple>
</td>
</tr>
</table>

<multiple name="attach_list">
        <if @attach_list.display@ eq "bottom">
          <img src="@subsite_name@/attach/@attach_list.attach_id@/@attach_list.file_name@" alt="@attach_list.file_name@">         
        </if>
</multiple>


@page_signature@

