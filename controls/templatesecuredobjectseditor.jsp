<%-- $HeadURL$
 This file is part of deegree, http://deegree.org/
 Copyright (C) 2001-2009 by:
 - Department of Geography, University of Bonn -
 and
 - lat/lon GmbH -

 This library is free software; you can redistribute it and/or modify it under
 the terms of the GNU Lesser General Public License as published by the Free
 Software Foundation; either version 2.1 of the License, or (at your option)
 any later version.
 This library is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 details.
 You should have received a copy of the GNU Lesser General Public License
 along with this library; if not, write to the Free Software Foundation, Inc.,
 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

 Contact information:

 lat/lon GmbH
 Aennchenstr. 19, 53177 Bonn
 Germany
 http://lat-lon.de/

 Department of Geography, University of Bonn
 Prof. Dr. Klaus Greve
 Postfach 1147, 53001 Bonn
 Germany
 http://www.geographie.uni-bonn.de/deegree/

 e-mail: info@deegree.org
--%>
<%@ page contentType="text/html" %>
<jsp:include page="header.jsp" flush="true"/>
<jsp:include page="logotable.jsp" flush="true"/>
<jsp:include page="menutable.jsp" flush="true"/>

<%@ page import="org.deegree.portal.standard.security.control.*" %>
<%@ page import="org.deegree.security.drm.model.*" %>
<%@ page import="org.deegree.framework.util.StringTools" %>
<%
	SecuredObject[] templates = (SecuredObject[]) request.getAttribute( "KatasterTemplates" );
%>                          

<script language="JavaScript1.2" type="text/javascript">
	
    var templates;

    /**
     * Constructs a new SecuredObject-object, consisting of:
     *
     * - id:          unique identifier (-1 means: new)
     * - name:        display name
     * - type:        KatasterTemplate
     * - isDeletable: always true at the moment
     */
    function SecuredObject( id, name, type ) {
      this.id = id;
      this.name = name;
      this.type = type;
      this.isDeletable = true;
    }

    /**
     * Initializes all listboxes with the data from the roles- and
     * allGroups-Arrays.
     */
    function initForm() {
        refreshTemplateListBox();
    }
    
     /**
      * Fills the Template listbox with the data from the templates-Array.
      */
    function refreshTemplateListBox() {
    
        var oldCount = document.templateForm.templateSelect.length;
        for ( i = oldCount - 1; i >=0 ; i-- ) {
            document.templateForm.templateSelect.options[i] = null;
        }    
        for ( i = 0; i < templates.length; i++ ) {
            document.templateForm.templateSelect.options[document.templateForm.templateSelect.length] =
                new Option( templates[i].name, templates[i].id );
        }
     }
   

    /**
     * Adds a new Template to the template-array. Keeps the array in alphabetical order.
     */
    function createTemplate() {
    
        var templateName = document.templateForm.templateName.value;
        if ( templateName == null || templateName == '' ) {
            alert( "Please enter a Template name." );
            return;
        }    
        for ( i = 0; i < templates.length; i++ ) {
            if ( templateName == templates[i].name ) {
                alert( "Please enter a unique name. The template of this name  '" + templateName + "' exists.!" );
                return;
            }
        }
        var templateIdx = templates.length;
        templates[templateIdx] = new SecuredObject( -1, templateName, "KatasterTemplate" );
        templates.sort( namesort );
        refreshTemplateListBox();
        document.templateForm.templateName.value = "";
    }

    /**
     * Deletes the selected Templates from the templates-Array.
     */
    function deleteTemplates() {
        selected = getSelectedOptionsIdx( document.templateForm.templateSelect.options );
        if ( selected.length == 0 ) {
            alert( "Please select a Template before trying to delete." );
            return;
        }
        // remove from template-Array
        for ( i = 0; i < selected.length; i++ ) {
            templateId = selected[i];
            if ( i != selected.length - 1 ) {
                nextId = selected[i + 1];
            } else {
                nextId = templates.length;
            }
            for ( j = templateId + 1; j < nextId; j++ ) {
                templates[j - (i + 1)] = templates[j];
            }
        }
        templates.length = templates.length - selected.length;
        refreshTemplateListBox();
    }

	 function init() {   	
<%
    out.println ("        templates = new Array(" + templates.length + " );");
    for ( int i = 0; i < templates.length; i++ ) {
        out.println ("        templates[" + i + "] = new SecuredObject( " + templates[i].getID() + ", '"
            + StringTools.replace( templates[i].getName(), "'", "\\'", true ) + "', 'KatasterTemplate' );");
    }
    out.println ("        templates.sort( namesort );");    
%>
        changed = false;
        initForm();
    }

    function performStoreTemplates() {
        if ( confirm( "Wollen Sie die vorgenommenen \u00C4nderungen wirklich speichern?" ) ) {
            storeTemplateObjects( templates );
        }
    }


</script>

<table class="maintable">
  <tr>
    <td valign="top">
      <h2>Pdf Templates-Editor</h2>
      <table border="0" cellpadding="3" cellspacing="0">
        <tr>
          <td align="left">
            <form action="javascript:createTemplate()" name="templateForm">
              <table border="0">
                <tr>
                  <td class="caption">Pdf Templates</td>
                </tr>
                <tr>
                  <td colspan="2">
                    <select class="largeselect" name="templateSelect" size="17" multiple="multiple">
                      <option>Formularinitialisierung...</option>
                    </select>
                  </td>
                </tr>
                <tr>
                  <td height="10"/>
                </tr>
                <tr>
                	<td>
                    	<table border="0" cellspacing="5" cellpadding="2">
                     		<tr>
		                        <td>
        		                	<table border="0" cellspacing="5" cellpadding="2">
			                            <tr>
                              				<td class="menu">
				                                <a href="javascript:createTemplate()">new Template</a>
                			             	</td>
                            			</tr>
		                          </table>
        		                </td>
                		        <td>
                        			<input type="text" name="templateName"/>
			                    </td>
            		        </tr>
                      		<tr>
                        		<td colspan="2">
                          			<table border="0" cellspacing="5" cellpadding="2">
                            			<tr>
		                              		<td class="menu">
			                                <a href="javascript:deleteTemplates()">Delete Pdf Template(s)</a>
            			                  	</td>
                            			</tr>
                          			</table>
                       			 </td>
                      		</tr>
                    	</table>
                 	 </td>
               	</tr>
        	</table>
       	</form>
     	</td>        
		</tr>
	</table>
	</td>
	</tr>
</table>

<table class="submittable">
  <tr>
    <td align="right">
      <table border="0" cellspacing="8" cellpadding="0">
        <tr>
          <td>
            <input type="button" value="&Auml;nderungen verwerfen" onclick="init()"/>
          </td>
          <td>
            <input type="button" value="&Auml;nderungen speichern" onclick="performStoreTemplates()"/>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<jsp:include page="footer.jsp" flush="true"/>
