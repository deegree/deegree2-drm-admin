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
        Group[] groups = (Group[]) request.getAttribute( "GROUPS" );
    SecurityAccess access = ( SecurityAccess ) request.getAttribute( "ACCESS" );
%>

<script language="JavaScript1.2" type="text/javascript">
<!--
    var groups = new Array(<%= groups.length %>);
    var users = new Array(0);
    var getUsersWindow;

    /**
     * Constructs a new User-object, consisting of:
     *
     * - id:      unique identifier
     * - name:    display name
     */
    function User( id, name ) {
        this.id = id;
        this.name = name;
    }

    /**
     * Constructs a new Group-object, consisting of:
     *
     * - id:           unique identifier
     * - name:         display name
     * - userMembers:  Array of users (members of this group)
     * - userLookup:   lookup-Array for userMembers
     * - groupMembers: Array of groups (members of this group)
     * - groupLookup:  lookup-Array for groupMembers
     */
    function Group( id, name, userMembers, groupMembers ) {
        this.id = id;
        this.name = name;
        if ( userMembers == null ) {
            userMembers = new Array(0);
        }
        if ( groupMembers == null ) {
            groupMembers = new Array(0);
        }
        this.userMembers = userMembers;
        this.userLookup = new Array ();
        for ( i = 0; i < userMembers.length; i++ ) {
            this.userLookup["ID" + userMembers[i].id] = userMembers[i].name;
        }
        this.groupMembers = groupMembers;
        this.groupLookup = new Array ();
        for ( i = 0; i < groupMembers.length; i++ ) {
            this.groupLookup["ID" + groupMembers[i].id] = groupMembers[i].name;
        }
    }

    /**
     * Fills the group listbox with all groups from the groups-Array.
     */
    function refreshGroupListBox( groupId ) {
        groupCount = document.groupSelectForm.groupSelect.length;
        for ( i = groupCount - 1; i >=0 ; i-- ) {
            document.groupSelectForm.groupSelect.options[i] = null;
        }
        for ( i = 0; i < groups.length; i++ ) {
           document.groupSelectForm.groupSelect.options[document.groupSelectForm.groupSelect.length] =
              new Option( groups[i].name, groups[i].id );
        }
        if ( groups.length > 0 ) {
           document.groupSelectForm.groupSelect.selectedIndex = groupId;
        }
    }

    function initForms() {
        refreshGroupListBox(0);
        selectGroup();
    }

    function selectGroup() {
        refreshAvailableUsersListBox();
        refreshMemberUsersListBox();
        refreshAvailableGroupsListBox();
        refreshMemberGroupsListBox();
    }

        function setUsers( newUsers ) {
        users = newUsers;
        refreshAvailableUsersListBox();
          }

          function setGetUsersWindow( win ) {
              getUsersWindow = win;
          }

          function getUsersProxy( chars ) {
              getUsersWindow.getUsersProxy( chars );
          }

    /**
     * Adds a new group to the groups-array. Keeps the array in alphabetical order.
     */
    function createGroup() {
        groupName = document.groupSelectForm.groupName.value;
        if ( groupName == null || groupName == '' ) {
            alert( "Bitte geben Sie einen Namen ein." );
            return;
        }
        for ( i = 0; i < groups.length; i++ ) {
            if ( groupName == groups[i].name ) {
                alert( "Es existiert bereits eine Gruppe namens '" + groupName + "'." );
                return;
            }
        }
        groupId = groups.length;
        groups[groupId] = new Group( -1, groupName, new Array(), new Array() );
        groups.sort( namesort );

        refreshGroupListBox( groupId );
        selectGroup();
        changed = true
    }

    /**
     * Deletes the currently selected group from the groups-array. This includes 2 steps:
     * 1. Remove group as group member
     * 2. Remove the group from groups array
     */
    function deleteGroups() {
        selectedIdx = document.groupSelectForm.groupSelect.selectedIndex;
        if ( selectedIdx == -1 ) {
            alert( "W\u00E4hlen Sie bitte zuerst eine Gruppe aus." );
            return;
        }
        groupId = groups[selectedIdx].id;
        for ( i = 0; i < groups.length; i++ ) {
            if ( groups[i].groupLookup["ID" + groupId] != null ) {
                groups[i].groupLookup["ID" + groupId] = null;
                members = groups[i].groupMembers;
                found = false;
                for ( j = 0; j < members.length; j++ ) {
                    if ( found ) {
                        members[j - 1] = members[j];
                    } else if ( members[j].id == groupId ) {
                        found = true;
                    }
                }
                if ( found ) {
                    members.length = members.length - 1;
                }
            }
        }
        for ( i = selectedIdx + 1; i < groups.length; i++ ) {
            groups[i - 1] = groups[i];
        }
        groups.length = groups.length - 1;
        initForms();
        changed = true
    }

    /**
     * Adds the currently selected users to the members array of the currently selected group.
     */
    function addUserMembers() {
        groupId = document.groupSelectForm.groupSelect.options.selectedIndex;
        selected = getSelectedOptions( document.userMemberForm.availableUserSelect.options );
        if ( selected.length == 0 || groupId == -1 ) {
            return;
        }
        memberLookup = groups[groupId].userLookup;
        for ( i = 0; i < selected.length; i++ ) {
            userId = selected[i].value;
            for ( j = 0; j < users.length; j++ ) {
                if ( users[j].id == userId ) {
                    newUser = users[j];
                    members = groups[groupId].userMembers;
                    members[members.length] = newUser;
                    memberLookup["ID" + users[j].id] = users[j].name;
                }
            }
        }
        members.sort( namesort );
        refreshMemberUsersListBox();
        refreshAvailableUsersListBox();
        changed = true
    }

    /**
     * Removes the currently selected users from the members array of the currently selected group.
     */
    function removeUserMembers() {
        groupId = document.groupSelectForm.groupSelect.options.selectedIndex;
        selected = getSelectedOptions( document.userMemberForm.userMemberSelect.options );
        if ( selected.length == 0 || groupId == -1 ) {
            return;
        }
        memberLookup = groups[groupId].userLookup;
        // remove from memberLookup array
        for ( i = 0; i < selected.length; i++ ) {
            memberLookup["ID" + selected[i].value] = null;
        }
        selected = getSelectedOptionsIdx( document.userMemberForm.userMemberSelect.options );
        members = groups[groupId].userMembers;
        // remove from members array
        for ( i = 0; i < selected.length; i++ ) {
            memberId = selected[i];
            if ( i != selected.length - 1 ) {
                nextId = selected[i + 1];
            } else {
                nextId = members.length;
            }
            for ( j = memberId + 1; j < nextId; j++ ) {
                members[j - (i + 1)] = members[j];
            }
        }
        members.length = members.length - selected.length;
        refreshMemberUsersListBox();
        refreshAvailableUsersListBox();
        changed = true
    }

    /**
     * Adds the currently selected groups to the members array of the currently selected group.
     */
    function addGroupMembers() {
        groupId = document.groupSelectForm.groupSelect.options.selectedIndex;
        selected = getSelectedOptions( document.groupMemberForm.availableGroupSelect.options );
        if ( selected.length == 0 || groupId == -1 ) {
            return;
        }
        memberLookup = groups[groupId].groupLookup;
        for ( i = 0; i < selected.length; i++ ) {
            for ( j = 0; j < groups.length; j++ ) {
                if ( groups[j].id == selected[i].value ) {
                    newGroup = groups[j];
                    members = groups[groupId].groupMembers;
                    members[members.length] = newGroup;
                    memberLookup["ID" + groups[j].id] = groups[j].name;
                }
            }
        }
        members.sort( namesort );
        refreshMemberGroupsListBox();
        refreshAvailableGroupsListBox();
        changed = true
    }

    /**
     * Removes the currently selected groups from the members array of the currently selected group.
     */
    function removeGroupMembers() {
        groupId = document.groupSelectForm.groupSelect.options.selectedIndex;
        selected = getSelectedOptions( document.groupMemberForm.groupMemberSelect.options );
        if ( selected.length == 0 || groupId == -1 ) {
            return;
        }
        memberLookup = groups[groupId].groupLookup;
        // remove from memberLookup array
        for ( i = 0; i < selected.length; i++ ) {
            memberLookup["ID" + selected [i].value] = null;
        }
        selected = getSelectedOptionsIdx( document.groupMemberForm.groupMemberSelect.options );
        members = groups[groupId].groupMembers;
        // remove from members array
        for ( i = 0; i < selected.length; i++ ) {
            memberId = selected[i];
            if ( i != selected.length - 1 ) {
                nextId = selected[i + 1];
            } else {
                nextId = members.length;
            }
            for ( j = memberId + 1; j < nextId; j++ ) {
                members[j - (i + 1)] = members[j];
            }
        }
        members.length = members.length - selected.length;
        refreshMemberGroupsListBox();
        refreshAvailableGroupsListBox();
        changed = true
    }

    /**
     * Fills the available user listbox with all users from the users-array that are
     * not members of the currently selected group.
     */
    function refreshAvailableUsersListBox() {
        groupId = document.groupSelectForm.groupSelect.selectedIndex;
        userCount = document.userMemberForm.availableUserSelect.length;
        for ( i = userCount - 1; i >=0 ; i-- ) {
            document.userMemberForm.availableUserSelect.options[i] = null;
        }
        if ( groupId == -1 ) return;
        for ( i = 0; i < users.length; i++ ) {
            userId = users[i].id;
            found = false;
            userLookup = groups[groupId].userLookup;
            if ( userLookup["ID" + userId] == null ) {
                document.userMemberForm.availableUserSelect.options[document.userMemberForm.availableUserSelect.length] =
                new Option( users[i].name, users[i].id );
            }
        }
    }

    /**
     * Fills the user members listbox with all members of the currently
     * selected group.
     */
    function refreshMemberUsersListBox() {
        groupId = document.groupSelectForm.groupSelect.selectedIndex;
        lastMemberCount = document.userMemberForm.userMemberSelect.length;
        for ( i = lastMemberCount - 1; i >=0 ; i-- ) {
            document.userMemberForm.userMemberSelect.options[i] = null;
        }
        if ( groupId == -1 ) return;
        members = groups[groupId].userMembers;
        for ( i = 0; i < members.length; i++ ) {
            document.userMemberForm.userMemberSelect.options[document.userMemberForm.userMemberSelect.length] =
                new Option( members[i].name, members[i].id );
        }
    }

    /**
     * Fills the available groups listbox with all groups from the groups-array that are
     * not members of the currently selected group.
     */
    function refreshAvailableGroupsListBox() {
        groupId = document.groupSelectForm.groupSelect.selectedIndex;
        groupCount = document.groupMemberForm.availableGroupSelect.length;
        for ( i = groupCount - 1; i >=0 ; i-- ) {
            document.groupMemberForm.availableGroupSelect.options[i] = null;
        }
        if ( groupId == -1 ) return;
        for ( i = 0; i < groups.length; i++ ) {
            found = false;
            groupLookup = groups[groupId].groupLookup;
            if ( groupLookup["ID" + groups[i].id] == null ) {
                document.groupMemberForm.availableGroupSelect.options[document.groupMemberForm.availableGroupSelect.length] =
                    new Option( groups[i].name, groups[i].id );
            }
        }
    }

    /**
     * Fills the group members listbox with all members of the currently
     * selected group.
     */
    function refreshMemberGroupsListBox() {
        groupId = document.groupSelectForm.groupSelect.selectedIndex;
        lastMemberCount = document.groupMemberForm.groupMemberSelect.length;
        for( i = lastMemberCount - 1; i >= 0 ; i-- ) {
            document.groupMemberForm.groupMemberSelect.options[i] = null;
        }
        if ( groupId == -1 ) return;
        members = groups[groupId].groupMembers;
        for ( i = 0; i < members.length; i++ ) {
            document.groupMemberForm.groupMemberSelect.options[document.groupMemberForm.groupMemberSelect.length] =
                new Option( members[i].name, members[i].id );
        }
    }

        function init() {
            changed = false
<%
    for ( int i = 0; i < groups.length; i++ ) {
        User[] userMembers = groups[i].getUsers( access );
        Group[] groupMembers = groups[i].getGroups (access);
        out.println("    userMembers" + i + " = new Array( " + userMembers.length + " );" );
        for ( int j = 0; j < userMembers.length; j++ ) {
            out.println( "    userMembers" + i + "[" + j + "] = new User( " + userMembers[j].getID () + ",'"
                + StringTools.replace( userMembers[j].getName(), "'", "\\'", true ) + "' );" );
        }
        if ( userMembers.length > 0 ) {
            out.println("    userMembers" + i + ".sort( namesort );" );
        }
        out.println( "    groupMembers" + i + " = new Array( " + groupMembers.length + " );" );
        for ( int j = 0; j < groupMembers.length; j++ ) {
            out.println( "    groupMembers" + i + "[" + j + "] = new Group( " + groupMembers [j].getID() + ",'"
                + StringTools.replace( groupMembers[j].getName(), "'", "\\'", true ) + "' );" );
        }
        if ( userMembers.length > 0 ) {
            out.println( "    groupMembers" + i + ".sort( namesort );" );
        }
        out.println( "    groups[" + i + "] = new Group( " + groups[i].getID () + ",'"
                       + StringTools.replace( groups[i].getName(), "'", "\\'", true ) + "', userMembers" + i +
                       ", groupMembers" + i + " );" );
    }
    out.println( "    groups.sort( namesort );" );
%>
            initForms();
        }

  function perform() {
      if ( confirm( "Wollen Sie die vorgenommenen \u00C4nderungen wirklich speichern?" ) ) {
          storeGroups( groups );
      }
        }
//-->
</script>

<table class="maintable">
  <tr>
    <td valign="top">
      <h2>Gruppen-Editor</h2>
      <table border="0" cellpadding="3" cellspacing="0">
        <tr>
          <td valign="top">
            <form action="javascript:createGroup()" name="groupSelectForm">
              <table border="0">
                <tr>
                  <td class="caption">Gruppen</td>
                </tr>
                <tr>
                  <td>
                    <select class="largeselect" style="width:280px" name="groupSelect" size="17" onchange="selectGroup();">
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
                                <a href="javascript:createGroup()">neue Gruppe</a>
                              </td>
                            </tr>
                          </table>
                        </td>
                        <td>
                          <input type="text" name="groupName"/>
                        </td>
                      </tr>
                      <tr>
                              <td colspan="2">
                              <table border="0" cellspacing="5" cellpadding="2">
                                  <tr>
                                                  <td class="menu">
                                                      <a href="javascript:deleteGroups()">Gruppe l&ouml;schen</a>
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
          <td valign="top">
            <table border="0">
              <tr>
                <td>
                  <form action="" name="groupMemberForm">
                    <table border="0">
                      <tr>
                        <td class="caption">Mitglieder (Gruppen)</td>
                        <td>&nbsp;</td>
                        <td class="caption">verf&uuml;gbare Gruppen</td>
                      </tr>
                      <tr>
                        <td>
                          <select class="largeselect" style="width:280px" name="groupMemberSelect" size="8" multiple="multiple">
                            <option>Formularinitialisierung...</option>
                          </select>
                        </td>
                        <td valign="middle" align="center">
                          <a href="javascript:addGroupMembers()">
                            <img src="images/admin_bt_add.gif" alt="+" border="0"/>
                          </a>
                          <br/>
                          <a href="javascript:removeGroupMembers()">
                            <img src="images/admin_bt_remove.gif" alt="-" border="0"/>
                          </a>
                        </td>
                        <td>
                          <select class="largeselect" style="width:280px" name="availableGroupSelect" size="8" multiple="multiple">
                            <option>Formularinitialisierung...</option>
                          </select>
                        </td>
                      </tr>
                    </table>
                  </form>
                </td>
              </tr>
              <tr>
                <td>
                  <form action="" name="userMemberForm">
                    <table border="0">
                      <tr>
                        <td class="caption">Mitglieder (Benutzer)</td>
                        <td>&nbsp;</td>
                        <td class="caption">verf&uuml;gbare Benutzer</td>
                      </tr>
                      <tr>
                        <td>
                          <select class="largeselect" style="width:280px" name="userMemberSelect" size="8" multiple="multiple">
                            <option>Formularinitialisierung...</option>
                          </select>
                        </td>
                        <td valign="middle" align="center">
                          <a href="javascript:addUserMembers()">
                            <img src="images/admin_bt_add.gif" alt="+" border="0"/>
                          </a>
                          <br/>
                          <a href="javascript:removeUserMembers()">
                            <img src="images/admin_bt_remove.gif" alt="-" border="0"/>
                          </a>
                        </td>
                        <td>
                          <select class="largeselect" style="width:280px" name="availableUserSelect" size="8" multiple="multiple">
                            <option>Formularinitialisierung...</option>
                          </select>
                        </td>
                      </tr>
                      <tr>
                        <td colspan="2"/>
                        <td align="center">
                          <table cellpadding="1" cellspacing="3">
                            <tr>
                              <td class="tinymenu">
                                <a href="javascript:getUsersProxy('[a-dA-D].*');">A-D</a>
                              </td>
                              <td class="tinymenu">
                                <a href="javascript:getUsersProxy('[e-gE-G].*');">E-G</a>
                              </td>
                              <td class="tinymenu">
                                <a href="javascript:getUsersProxy('[h-kH-K].*');">H-K</a>
                              </td>
                              <td class="tinymenu">
                                <a href="javascript:getUsersProxy('[l-qL-Q].*');">L-Q</a>
                              </td>
                              <td class="tinymenu">
                                <a href="javascript:getUsersProxy('[r-uR-U].*');">R-U</a>
                              </td>
                              <td class="tinymenu">
                                <a href="javascript:getUsersProxy('[v-zV-Z].*');">V-Z</a>
                              </td>
                              <td class="tinymenu">
                                <a href="javascript:getUsersProxy('[äöüÄÖÜ].*');">&Auml;&Ouml;&Uuml;</a>
                              </td>
                              <td class="tinymenu">
                                <a href="javascript:getUsersProxy('[0-9].*');">0-9</a>
                              </td>
                              <td class="tinymenu">
                                <a href="javascript:getUsersProxy('[^a-zäöüA-ZÄÖÜ0-9].*');">Sonderz.</a>
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
    </td>
  </tr>
</table>

<jsp:include page="submittable.jsp" flush="true"/>
<iframe frameborder="0" height="0" width="0" src="SecurityRequestDispatcher?rpc=%3CmethodCall%3E%3CmethodName%3EgetUsers%3C%2FmethodName%3E%3Cparams%3E%3Cparam%3E%3Cvalue%3E%3Cstring%3E%5Ba-dA-D%5D%3C%2Fstring%3E%3C%2Fvalue%3E%3C%2Fparam%3E%3C%2Fparams%3E%3C%2FmethodCall%3E" name="userFrame"/>
<jsp:include page="footer.jsp" flush="true"/>
