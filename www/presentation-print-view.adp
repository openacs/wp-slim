<master>
<property name="doc(title)">@pres_title;literal@</property>
<property name="context">@context;literal@</property>

<h2>@pres_title@</h2>
#wp-slim.lt_a_Wimpy_Point_Present# <a href="/shared/community-member?user_id=@owner_id@">@owner_name@</a>

<multiple name="slides">
			<hr>
          <h1> @slides.title@ </h1>

          <% get_attach_list  @slides.slide_id@ %>

         <multiple name="attach_list">
                 <if @attach_list.display@ eq "top">
                   <img src="@subsite_name@attach/@attach_list.attach_id@/@attach_list.file_name@" alt="@attach_list.file_name@">
                 </if>
         </multiple>

          <table width="100%">
          <tr>
          <td>
	  <% set slides(preamble) [lindex $slides(preamble) 0] %>
          <p>@slides.preamble;noquote@
          </td>
		    <td align="right">
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
         </multiple>


          <table width="100%">
          <tr>
          <td>
			<%
				set rownum  @slides.rownum@
				set bullet_list   [ multirow get slides $rownum bullet_list ]
			%>
          <list name="bullet_list">
          <ul>
				<li> @bullet_list:item@		</li>
          </ul>
          </list>
          </td>

          <td align="right">
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

          <table width="100%">
          <tr>
          <td>
	  <% set slides(postamble) [lindex $slides(postamble) 0] %>
          <p>@slides.postamble;noquote@
          </td>

          <td align="right">
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
          <img src="../../attach/@attach_list.attach_id@/@attach_list.file_name@" alt="@attach_list.file_name@">
        </if>
	</multiple>
</multiple>
<hr>
@page_signature@
<br>
@copyright_notice@

