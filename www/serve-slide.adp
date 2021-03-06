<master src="wp-presentation-master">
<property name="doc(title)">@slide_title;literal@</property>
<property name="context">@context;literal@</property>
<property name="style_id">@style;literal@</property>
<property name="page_signature">@page_signature;literal@</property>
<property name="copyright_notice">@copyright_notice;literal@</property>

<table align="right">
<tr>
        <td>@href_back_forward;noquote@</td>
</tr>
</table>

<h2>@slide_title;noquote@</h2>
<if @show_modified_p@ eq t>
<i>#wp-slim.lt_Last_modified_modifie#</i>
</if>
<hr>

<multiple name="attach_list">
        <if @attach_list.display@ eq "top">
          <img src="../../attach/@attach_list.attach_id@/@attach_list.file_name@" alt="@attach_list.file_name@">         
        </if>
</multiple>

<table width="100%">
<tr>
<td>
<p>@preamble;noquote@
</td>
<td align="right">
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
        <li>@bullet_items:item;noquote@
</list>
</ul>
</td>

<td align="right">
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
<p>@postamble;noquote@
</td>
<td align="right">
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


@page_signature;noquote@

<if @edit_p@ eq 1 or @show_comments_p@ eq "t">

<if @comments@ ne "">
<h3>#wp-slim.Slide_Comments#</h3>
@comments;noquote@
</if>

</if>


<if @edit_p@ eq 1>

<if @comment_link@ ne "">
<ul>
<li>
@comment_link;noquote@
</ul>
</if>

</if>

