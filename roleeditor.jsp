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

<%@ page import="org.deegree.security.drm.*" %>
<%@ page import="org.deegree.security.drm.model.*" %>
<%@ page import="org.deegree.framework.util.StringTools" %>

<%
    Role[] roles = (Role[]) request.getAttribute( "ROLES" );
    Group[] groups = (Group[]) request.getAttribute( "GROUPS" );
    SecurityAccess access = (SecurityAccess) request.getAttribute( "ACCESS" );

    String s = (String) request.getAttribute( "supportManyServices" );
    boolean manyServices = false;
    if ( s != null ) {
        manyServices = s.equalsIgnoreCase( "true" );
    }
%>

<script language="JavaScript1.2" type="text/javascript">
<!--
    var roles, allGroups, changed;

    /**
     * Constructs a new Group-object, consisting of:
     * - id:     unique identifier
     * - name:   display name
     */
    function Group( id, name ) {
      this.id = id;
      this.name = name;
    }

    /**
     * Constructs a new Role-object, consisting of:
     * - id:          unique identifier
     * - name:        display name
     * - groups:      array of groups (associated with this role)
     * - isGrantable: is current editor allowed to grant this role?
     * - isDeletable: is current editor allowed to delete this role?
     * - isUpdatable: is current editor allowed to modify this role?
     * - lookup:      lookup-array of associated groups
     */
    function Role( id, name, groups, isGrantable, isDeletable, isUpdatable ) {
        this.id = id;
        this.name = name;
        this.groups = groups;
        this.isGrantable = isGrantable;
        this.isDeletable = isDeletable;
        this.isUpdatable = isUpdatable;
        this.lookup = new Array();
        for ( i = 0; i < groups.length; i++ ) {
            this.lookup["ID" + groups[i].id] = groups[i].name;
        }
    }

    /**
     * Initializes all listboxes with the data from the roles- and
     * allGroups-Arrays.
     */
    function initForm() {
        refreshRolesListBox(0);
        refreshGroupsListBox();
        refreshAllGroupsListBox();
    }

     /**
      * Fills the roles listbox with all roles from the roles-Array and
      * selects the entry with the given index.
      */
    function refreshRolesListBox( roleIdx ) {
        var oldCount = document.roleForm.roleSelect.length;
        for ( i = oldCount - 1; i >= 0; i-- ) {
            document.roleForm.roleSelect.options[i] = null;
        }
        for ( i = 0; i < roles.length; i++ ) {
            document.roleForm.roleSelect.options[document.roleForm.roleSelect.length] =
                new Option( roles[i].name, roles[i].id );
        }
        if ( roles.length > 0 ) {
            document.roleForm.roleSelect.selectedIndex = roleIdx;
        }
     }

    /**
     * Fills the associated groups listbox with all groups from that are
     * associated with the currently selected role.
     */
    function refreshGroupsListBox() {
        var roleIdx = document.roleForm.roleSelect.selectedIndex;
        var oldCount = document.groupForm.groupSelect1.length;
        for ( i = oldCount - 1; i >= 0; i-- ) {
            document.groupForm.groupSelect1.options[i] = null;
        }
        if ( roleIdx == -1 ) return;
        var groups = roles[roleIdx].groups;
        for ( i = 0; i < groups.length; i++ ) {
            document.groupForm.groupSelect1.options[document.groupForm.groupSelect1.length] =
                new Option( groups[i].name, groups[i].id );
        }
    }

    /**
     * Fills the available groups listbox with all groups from the groups-Array
     * that are not associated with the currently selected role.
     */
    function refreshAllGroupsListBox() {
        var roleIdx = document.roleForm.roleSelect.selectedIndex;
        var oldCount = document.groupForm.groupSelect2.length;
        for ( i = oldCount - 1; i >= 0 ; i-- ) {
            document.groupForm.groupSelect2.options[i] = null;
        }
        if ( roleIdx == -1 ) return;
        var lookup = roles[roleIdx].lookup;
        for ( i = 0; i < allGroups.length; i++ ) {
            if ( lookup["ID" + allGroups[i].id] == null ) {
                document.groupForm.groupSelect2.options[document.groupForm.groupSelect2.length] =
                    new Option( allGroups[i].name, allGroups[i].id );
            }
        }
    }

    /**
     * Adds a new role to the roles-array. Keeps the array in alphabetical order.
     */
    function createRole() {
        roleName = document.roleForm.roleName.value;
        if ( roleName == null || roleName == '' ) {
            alert( "Bitte geben Sie einen Namen ein." );
            return;
        }
        for ( i = 0; i < roles.length; i++ ) {
            if ( roleName == roles[i].name ) {
                alert( "Es existiert bereits eine Rolle namens '" + roleName + "'!" );
                return;
            }
        }
        var roleIdx = roles.length;
        roles[roleIdx] = new Role( -1, roleName, new Array (), true, true );
        roles.sort( namesort );
        refreshRolesListBox( roleIdx );
        refreshGroupsListBox();
        refreshAllGroupsListBox();
        changed = true;
        document.roleForm.roleName.value = "";
    }

    /**
     * Deletes the selected roles.
     */
    function deleteRole() {
        var roleIdx = document.roleForm.roleSelect.selectedIndex;
        if ( roleIdx == -1 ) {
            alert( "W\u00E4hlen Sie bitte zuerst eine Rolle aus." );
            return;
        }
        if ( !roles[roleIdx].isDeletable ) {
            alert( "Sie haben nicht die Berechtigung, diese Rolle zu l\u00F6schen." );
            return;
        }
        changed = true;
        for ( i = roleIdx + 1; i < roles.length; i++ ) {
            roles[i - 1] = roles[i];
        }
        roles.length = roles.length - 1;
        initForm();
    }

    /**
     * Sets the currently selected groups to be associated with the
     * selected role.
     */
    function associateGroups() {
        var roleIdx = document.roleForm.roleSelect.options.selectedIndex;
        var selected = getSelectedOptions( document.groupForm.groupSelect2.options );
        if ( selected.length == 0 || roleIdx == -1 ) {
            return;
        }
        if ( !roles [roleIdx].isGrantable ) {
            alert( "Sie haben nicht die Berechtigung, diese Rolle zuzuweisen." );
            return;
        }
        var groups = roles[roleIdx].groups;
        var lookup = roles[roleIdx].lookup;
        for ( i = 0; i < selected.length; i++ ) {
            var groupId = selected [i].value;
            for ( j = 0; j < allGroups.length; j++ ) {
                if ( allGroups[j].id == groupId ) {
                    var newGroup = allGroups[j];
                    groups[groups.length] = newGroup;
                    lookup["ID" + newGroup.id] = newGroup.name;
                }
            }
        }
        groups.sort( namesort );
        refreshGroupsListBox();
        refreshAllGroupsListBox();
        changed = true;
    }

    /**
     * Withdraws the currently selected role from the selected groups.
     */
    function withdrawRole() {
        var roleIdx = document.roleForm.roleSelect.options.selectedIndex;
        var selected = getSelectedOptions( document.groupForm.groupSelect1.options );
        if ( selected.length == 0 || roleIdx == -1 ) {
            return;
        }
        if ( !roles[roleIdx].isGrantable ) {
            alert( "Sie haben nicht die Berechtigung, die Zuweisung dieser Rolle zu \u00E4ndern." );
            return;
        }
        var lookup = roles[roleIdx].lookup;
        var groups = roles[roleIdx].groups;
        for ( i = 0; i < selected.length; i++ ) {
            lookup["ID" + selected[i].value] = null;
        }
        selected = getSelectedOptionsIdx( document.groupForm.groupSelect1.options );
        for ( i = 0; i < selected.length; i++ ) {
            var groupIdx = selected[i];
            var nextIdx;
            if ( i != selected.length - 1 ) {
                nextIdx = selected[i + 1];
            } else {
                nextIdx = groups.length;
            }
            for ( j = groupIdx + 1; j < nextIdx; j++ ) {
               groups[j - (i + 1)] = groups[j];
            }
        }
        groups.length = groups.length - selected.length;
        refreshGroupsListBox();
        refreshAllGroupsListBox();
        changed = true;
    }

    function init() {
        changed = false
<%
        out.println( "        allGroups = new Array (" + groups.length + " );" );
        for ( int i = 0; i < groups.length; i++ ) {
            out.println( "        allGroups[" + i + "] = new Group( " + groups [i].getID() + ", '"
                + StringTools.replace( groups[i].getName(), "'", "\\'", true) + "' );" );
        }
        out.println( "        allGroups.sort( namesort );" );
        out.println( "        roles = new Array( " + roles.length + " );" );
        for ( int i = 0; i < roles.length; i++ ) {
            Group[] groups1 = roles[i].getGroups( access );
            out.println( "        groups" + i + "= new Array( " + groups1.length + " );" );
            for ( int j = 0; j < groups1.length; j++ ) {
                out.println( "        groups" + i + " [" + j + "] = new Group( " + groups1[j].getID() + ", '"
                    + StringTools.replace( groups1[j].getName(), "'", "\\'", true ) + "' );" );
            }
            out.println( "        groups" + i + ".sort( namesort );" );
            boolean isGrantable = access.getUser().hasRight( access, RightType.GRANT, roles [i] );
            boolean isDeletable = access.getUser().hasRight( access, RightType.DELETE, roles [i] );
            boolean isUpdatable = access.getUser().hasRight( access, RightType.UPDATE, roles [i] );
            out.println( "        roles[" + i + "] = new Role( " + roles[i].getID() + ", '"
                + StringTools.replace( roles[i].getName(), "'", "\\'", true ) + "', groups" + i + ", "
                + isGrantable + "," + isDeletable + "," + isUpdatable + " );" );
        }
        out.println( "        roles.sort( namesort );" );
%>
        changed = false;
        initForm();
    }

    function editRights() {
        var roleIdx = document.roleForm.roleSelect.options.selectedIndex;
        if ( roleIdx == -1 ) {
            alert( "W\u00E4hlen Sie bitte eine Rolle aus." );
        } else if ( changed ) {
            alert( "Es gibt nichtgespeicherte \u00C4nderungen. Sie m\u00FCssen '\u00C4nderungen speichern' oder " +
                   "'\u00C4nderungen verwerfen' w\u00E4hlen, bevor Sie eine Rolle editieren k\u00F6nnen.");
        } else {
            if ( !roles[roleIdx].isUpdatable ) {
                alert( "Sie haben nicht die Berechtigung, diese Rolle zu editieren." );
            } else {
                editRightsRPC( roles[roleIdx].id );
            }
        }
    }

    function editServiceRights() {
        var roleIdx = document.roleForm.roleSelect.options.selectedIndex
        if ( roleIdx == -1 ) {
            alert( "W\u00E4hlen Sie bitte eine Rolle aus." )
        } else if ( changed ) {
            alert( "Es gibt nichtgespeicherte \u00C4nderungen. Sie m\u00FCssen '\u00C4nderungen speichern' oder " +
                   "'\u00C4nderungen verwerfen' w\u00E4hlen, bevor Sie eine Rolle editieren k\u00F6nnen.")
        } else {
            if ( !roles[roleIdx].isUpdatable ) {
                alert( "Sie haben nicht die Berechtigung, diese Rolle zu editieren." )
            } else {
                editServiceRightsRPC( roles[roleIdx].id )
            }
        }
    }

    function perform() {
        if ( confirm( "Wollen Sie die vorgenommenen \u00C4nderungen wirklich speichern?" ) ) {
            storeRoles(roles);
        }
    }

//-->
</script>

<table class="maintable">
  <tr>
    <td valign="top">
      <h2>Rollen-Editor</h2>
      <table border="0" cellpadding="3" cellspacing="0">
        <tr>
          <td valign="top">
            <form action="javascript:createRole()" name="roleForm">
              <table border="0">
                <tr>
                  <td class="caption">Rollen</td>
                </tr>
                <tr>
                  <td>
                    <select class="largeselect" style="width:280px" name="roleSelect" size="17" onchange="refreshGroupsListBox();refreshAllGroupsListBox();">
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
                                <a href="javascript:createRole()">neue Rolle</a>
                              </td>
                            </tr>
                          </table>
                        </td>
                        <td>
                          <input type="text" name="roleName"/>
                        </td>
                      </tr>
                      <tr>
                        <td colspan="2">
                          <table border="0" cellspacing="5" cellpadding="2">
                            <tr>
                              <td class="menu">
                                <a href="javascript:deleteRole()">Rolle l&ouml;schen</a>
                              </td>
                              <td class="menu">
                                <a href="javascript:editRights()">Rechte editieren</a>
                              </td>
                            </tr>
                            <%
                                if(manyServices){
                            %>
                            <tr>
                              <td></td>
                              <td class="menu">
                                <a href="javascript:editServiceRights()">Dienste zuordnen</a>
                              </td>
                            </tr>
                            <%
                                }
                            %>
                          </table>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </form>
          </td>
          <td valign="top">
            <table border="0">
              <tr>
                <td>
                  <form action="" name="groupForm">
                    <table border="0">
                      <tr>
                        <td class="caption">zugewiesene Gruppen</td>
                        <td></td>
                        <td class="caption">verf&uuml;gbare Gruppen</td>
                      </tr>
                      <tr>
                        <td>
                          <select class="largeselect" style="width:280px" name="groupSelect1" size="17" multiple="multiple">
                            <option>Formularinitialisierung...</option>
                          </select>
                        </td>
                        <td valign="middle" align="center">
                          <a href="javascript:associateGroups()">
                            <img src="images/admin_bt_add.gif" alt="+" border="0"/>
                          </a>
                          <br/>
                          <a href="javascript:withdrawRole()">
                            <img src="images/admin_bt_remove.gif" alt="-" border="0"/>
                          </a>
                        </td>
                        <td>
                          <select class="largeselect" style="width:280px" name="groupSelect2" size="17" multiple="multiple">
                            <option>Formularinitialisierung...</option>
                          </select>
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
    </td>
  </tr>
</table>

<jsp:include page="submittable.jsp" flush="true"/>
<jsp:include page="footer.jsp" flush="true"/>
