<master src="master">
<property name="title">@slide_title@</property>
<property name="context">@context@</property>

<table align=right>
<tr>
        <td>@href_back_forward@</td>
</tr>
</table>

<if @show_modified_p@ eq t>
<i>Last modified @modified_date@</i>
</if>

<multiple name="attach_list">
        <if @attach_list.display@ eq "top">
          <img src="../../attach/@attach_list.attach_id@/@attach_list.file_name@" alt="@attach_list.file_name@">         
        </if>
</multiple>

<table width="100%">
<tr>
<td>
<p>@preamble@
</td>
<td align=right>
<multiple name="attach_list">
        <if @attach_list.display@ eq "preamble">
          <img src="../../attach/@attach_list.attach_id@/@attach_list.file_name@" alt="@attach_list.file_name@">         
        </if>
</multiple>
</td>
</tr>
</table>

<multiple name="attach_list">
        <if @attach_list.display@ eq "after_preamble">
          <img src="../../attach/@attach_list.attach_id@/@attach_list.file_name@" alt="@attach_list.file_name@">         
        </if>
        <if @attach_list.display@ nil>
          <a href="../../attach/@attach_list.attach_id@/@attach_list.file_name@">@attach_list.file_name@</a>
        </if>
</multiple>

<table width="100%">
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
          <img src="../../attach/@attach_list.attach_id@/@attach_list.file_name@" alt="@attach_list.file_name@">         
        </if>
</multiple>
</td>
</tr>
</table>

<multiple name="attach_list">
        <if @attach_list.display@ eq "after_bullets">
          <img src="../../attach/@attach_list.attach_id@/@attach_list.file_name@" alt="@attach_list.file_name@">         
        </if>
</multiple>

<table width="100%">
<tr>
<td>
<p>@postamble@
</td>
<td align=right>
<multiple name="attach_list">
        <if @attach_list.display@ eq "postamble">
          <img src="../../attach/@attach_list.attach_id@/@attach_list.file_name@" alt="@attach_list.file_name@">         
        </if>
</multiple>
</td>
</tr>
</table>

<multiple name="attach_list">
        <if @attach_list.display@ eq "bottom">
          <img src="../../attach/@attach_list.attach_id@/@attach_list.file_name@" alt="@attach_list.file_name@">         
        </if>
</multiple>


@page_signature@

