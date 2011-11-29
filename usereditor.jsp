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
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="header.jsp" flush="true" />
<jsp:include page="logotable.jsp" flush="true" />
<jsp:include page="menutable.jsp" flush="true" />

<%@ page import="org.deegree.security.drm.model.*"%>
<%@ page import="org.deegree.framework.util.StringTools"%>
<!-- added for context chooser -->
<%@ page import="org.deegree.portal.standard.security.control.*"%>
<%@ page import="java.util.*"%>

<%
    User[] users = (User[]) request.getAttribute( "USERS" );

    // added for context chooser
    Map<?, ?> contextsListHT = (Map<?, ?>) request.getAttribute( "STARTCONTEXTSLIST" );
    Map<?, ?> usersListHT = (Map<?, ?>) request.getAttribute( "USERSCONTEXTLIST" );
    String usersDirectory = (String) request.getAttribute( "USERSDIRECTORY" );
    String contextChanged = (String) request.getAttribute( "DEFAULTCHANGED" );

    boolean isReadContextsSuccess = false;
    StartContext defaultContext = null;
    ArrayList<StartContext> usersList = null;
    ArrayList<StartContext> startContexts = null;

    if ( contextsListHT != null && usersListHT != null ) {
        isReadContextsSuccess = true;
    }
    if ( usersDirectory != null ) {
        usersDirectory = usersDirectory.replace( "\\", "/" );
    }

    if ( isReadContextsSuccess ) {
        usersList = new ArrayList<StartContext>( (Collection) usersListHT.values() );
        startContexts = new ArrayList<StartContext>( (Collection) contextsListHT.values() );

        for ( int i = 0; i < startContexts.size(); i++ ) {
            if ( startContexts.get( i ).isDefault() == true ) {
                defaultContext = startContexts.get( i );
                break;
            }
        }
    }
    // end (context chooser)
%>

<script language="JavaScript1.2" type="text/javascript">
<!--
    var users = new Array( <%=users.length%> )
    // added for context chooser
    var usersContexts = null
    var startContexts = null
    var currentUserContext
        var defaultContext
        var isReadContextsSuccess = <%=isReadContextsSuccess%>
        var shownContextList = null
        var isFirstTime = true
        var usersDirectory = "<%=usersDirectory%>"

        if ( isReadContextsSuccess ) {

<%if ( defaultContext != null ) {
                defaultContext.setPath( defaultContext.getPath().replace( "\\", "/" ) );%>
                defaultContext = new Context( "<%=defaultContext.getContextName()%>",
                                              "<%=defaultContext.getPath()%>", null )
                defaultContext.isDefault = true
<%}%>
        }

    /**
     * Context
     * (added for context chooser)
     */
    function Context( name, path ) {
        this.name = name;
        this.path = path;
                this.isDefault = false;
                this.displayName;
    }

    /**
     * Constructs a new User-object, consisting of:
     *
     * - id:        unique identifier
     * - name:      unique name
     * - email:     email address
     * - password:  password
     * - firstName: first name
     * - lastName:  last name
     *
     * interface changed for context chooser
     */
    function User( id, name, email, password, firstName, lastName, contextName, contextPath ) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.password = password;
        this.firstName = firstName;
        this.lastName = lastName;

        // added for context chooser
        if ( isReadContextsSuccess ) {
            this.contextName = contextName;
            this.contextPath = contextPath;
            this.isDefaultContext = false;
            this.displayContextName;
        }
    }

    function checkUserFields() {
        if ( document.userEditForm.password.value != document.userEditForm.password2.value ) {
            alert( "Die eingegebenen Passworte stimmen nicht \u00FCberein." );
            document.userEditForm.password.value = "";
            document.userEditForm.password2.value = "";
            document.userEditForm.password.focus();
            return false;
        }
        if ( document.userEditForm.name.value == null || document.userEditForm.name.value == '' ) {
            alert( "Bitte geben Sie einen Namen ein." );
            document.userEditForm.name.focus();
            return false;
        }
        if ( document.userEditForm.email.value == null || document.userEditForm.email.value == '' ) {
            alert( "Bitte geben Sie eine eMail-Adresse ein." );
            document.userEditForm.email.focus();
            return false;
        }
        return true;
    }

    function buildDisplayName( user ) {
        var s = user.name;
        if ( user.lastName != null ) {
            if ( user.firstName != null ) {
                s += " (" + user.lastName + ", " + user.firstName + ")";
            } else {
                s += " (" + user.lastName + ")";
            }
        } else if ( user.firstName != null ) {
            s += " (" + user.firstName + ")";
        }
        return s;
    }

    /**
    * added for context chooser
    */
    function buildDisplayContextName( user ) {
        var s = user.name;
        s += ':';
        s += user.contextName;
        return s;
    }

    /**
     * Fills the user listbox with all users from the users-Array.
     */
    function refreshUserListBox( userId ) {
        userCount = document.userSelectForm.userSelect.length;
        for ( i = userCount - 1; i >=0 ; i-- ) {
            document.userSelectForm.userSelect.options [i] = null;
        }
        for ( i = 0; i < users.length; i++ ) {
            document.userSelectForm.userSelect.options[document.userSelectForm.userSelect.length] =
                new Option( buildDisplayName( users[i] ), users[i].id );
        }
        if ( users.length > 0 ) {
           document.userSelectForm.userSelect.selectedIndex = userId;
        }

        // added for context chooser
        if ( isReadContextsSuccess ) {
                if ( isFirstTime ) {
                    initContexts();
                    isFirstTime = false;
                }
        }

        selectUser();
    }

    function selectUser() {
        var selectedIdx = document.userSelectForm.userSelect.selectedIndex;
        var selectedUser = users[selectedIdx];
        if ( !selectedUser ) {
            return
        }
        document.userEditForm.name.value = selectedUser.name;
        document.userEditForm.email.value = selectedUser.email;

        if ( selectedUser.password != null ) {
            document.userEditForm.password.value = selectedUser.password;
            document.userEditForm.password2.value = selectedUser.password;
        } else {
            document.userEditForm.password.value = "";
            document.userEditForm.password2.value = "";
        }
        if ( selectedUser.firstName != null ) {
            document.userEditForm.firstName.value = selectedUser.firstName;
        } else {
            document.userEditForm.firstName.value = "";
        }
        if ( selectedUser.lastName != null ) {
            document.userEditForm.lastName.value = selectedUser.lastName;
        } else {
            document.userEditForm.lastName.value = "";
        }

        // added for context chooser
        fillContextList();
    }

    function initForms() {
        refreshUserListBox( 0 );
    }

    /**
     * Adds a new user to the users-array. Keeps the array in alphabetical order.
     */
    function createUser() {
        var name = document.userSelectForm.userName.value;
        if ( name == null || name == '' ) {
            alert( "Bitte geben Sie einen Namen ein." );
            return
        }
        isFound = false
        for ( i = 0; i < users.length; i++ ) {
            if ( users[i].name == name ) {
                isFound = true
                alert( "Ein Benutzer mit diesem Namen existiert bereits." )
                return
            }
        }
        userIdx = users.length

        // added for context chooser
        if ( isReadContextsSuccess ) {
            users[userIdx] = new User( -1, name, "", null, null, null, defaultContext.name, null );
            users[userIdx].isDefaultContext = true;
            users[userIdx].displayContextName = users[userIdx].name + ':' + users[userIdx].contextName  + '(isDefault)';
        } else {
            users[userIdx] = new User( -1, name, "", null, null, null, null, null );
        }
        // end

        refreshUserListBox( userIdx );
        document.userEditForm.email.focus();
        changed = true
    }

    /**
     * Deletes the currently selected user from the users-array.
     */
    function deleteUser() {
        selectedIdx = document.userSelectForm.userSelect.selectedIndex
        if ( selectedIdx == -1 ) {
            alert( "W\u00E4hlen Sie bitte zuerst einen Benutzer aus." )
            return
        }
        for ( i = selectedIdx + 1; i < users.length; i++ ) {
            users [i - 1] = users [i]
        }
        users.length = users.length - 1
        initForms()
        changed = true
    }

    /**
     * Changes the details of a user according to the input fields.
     */
    function modifyUser() {
        if ( !checkUserFields() ) {
            return
        }
        userIdx = document.userSelectForm.userSelect.selectedIndex
        user = users[userIdx]

        // check if a user with this (modified) name exists
        if ( user.name != document.userEditForm.name.value ) {
            for ( i = 0; i < users.length; i++ ) {
                if ( users[i].name == document.userEditForm.name.value ) {
                    alert( "Ein Benutzer mit diesem Namen existiert bereits.")
                    return
                }
            }
        }
        userIdx = document.userSelectForm.userSelect.selectedIndex
        user = users[userIdx]
        user.name = document.userEditForm.name.value
        user.email = document.userEditForm.email.value
        user.password = document.userEditForm.password.value != "" ? document.userEditForm.password.value : null
        user.firstName = document.userEditForm.firstName.value != "" ? document.userEditForm.firstName.value : null
        user.lastName = document.userEditForm.lastName.value != "" ? document.userEditForm.lastName.value : null
        users.sort( namesort )
        refreshUserListBox( userIdx )
        changed = true
    }

         function init() {
             changed = false
<%for ( int i = 0; i < users.length; i++ ) {
                out.println( "    users ["
                             + i
                             + "] = new User( "
                             + users[i].getID()
                             + ",'"
                             + StringTools.replace( users[i].getName(), "'", "\\'", true )
                             + "',"
                             + ( users[i].getEmailAddress() == null ? "null" : "'" + users[i].getEmailAddress() + "'" )
                             + ","
                             + ( users[i].getPassword() == null ? "null"
                                                               : "'"
                                                                 + StringTools.replace( users[i].getPassword(), "'",
                                                                                        "\\'", true ) + "'" )
                             + ","
                             + ( users[i].getFirstName() == null ? "null"
                                                                : "'"
                                                                  + StringTools.replace( users[i].getFirstName(), "'",
                                                                                         "\\'", true ) + "'" )
                             + ","
                             + ( users[i].getLastName() == null ? "null"
                                                               : "'"
                                                                 + StringTools.replace( users[i].getLastName(), "'",
                                                                                        "\\'", true ) + "'" ) + " )" );
            }
            out.println( "    users.sort( namesort )" );%>
        // added for context chooser
        isFirstTime = true
            initForms()
    }

    function perform() {
       if ( confirm( "Wollen Sie die vorgenommenen \u00C4nderungen wirklich speichern?" ) ) {
           // changed for context chooser
           if ( isReadContextsSuccess ) {
               storeUsers( users, usersDirectory, defaultContext );
           } else {
               storeUsers( users, null, null );
           }
       }
    }


    /**
     * read the lists from the java collections
     *
     * (added for context chooser)
     */
    function readContextLists() {

            if ( defaultContext == null ) {
                defaultContext = new Context( 'StartContext',null,'StartContext' );
            }
<%if ( isReadContextsSuccess ) {%>
                        usersContexts = new Array( <%usersList.size();%> );
<%if ( contextChanged != null && contextChanged.length() != 0 ) {
                    contextChanged = contextChanged.replace( "\\", "/" );%>
            alert( 'Der defaultContext wurde ge\u00E4ndert. Der neue Context ist: ' + '<%=contextChanged%>' );
<%}
                for ( int i = 0; i < usersList.size(); i++ ) {
                    StartContext context = usersList.get( i );
                    context.setPath( context.getPath().replace( "\\", "/" ) );%>
                    var contextName = "<%=context.getContextName()%>";
                usersContexts[<%=i%>] = new Context( "<%=context.getContextName()%>",
                                                     "<%=context.getPath()%>" );
<%}%>
                startContexts = new Array( <%=startContexts.size()%> );
<%for ( int i = 0; i < startContexts.size(); i++ ) {
                    StartContext context = startContexts.get( i );
                    context.setPath( context.getPath().replace( "\\", "/" ) );%>
                    startContexts[<%=i%>] = new Context( "<%=context.getContextName()%>",
                                                                                         "<%=context.getPath()%>" );
                    startContexts[<%=i%>].isDefault = <%=context.isDefault()%>;
                    startContexts[<%=i%>].displayName = startContexts[<%=i%>].name;
                    if ( startContexts[<%=i%>].isDefault ) {
                        startContexts[<%=i%>].displayName += ' (isDefault)';
                    }
<%}
            }%>
    }

    /**
     * Put the suitable contexts in the contexts list.
     * These are the startContexts, the defaultcontext and the userContext
     *
     * (added for context chooser)
     */
    function fillContextList() {

        var contextsNode = document.getElementById( 'contextsSelectList' );

            if ( isReadContextsSuccess ) {

                        // cleaning the list
                        contextsCount = contextsNode.length;
                for ( i = contextsCount - 1; i >= 0; i-- ) {
                    contextsNode.options[i] = null;
                }

                if ( document.userSelectForm.userSelect.selectedIndex == -1 ) {
                    return;
                        }
                //This size represents the number of available contexts + the user context
                shownContextList = new Array( startContexts.length+1 );

                //Adding the StartContexts of the xml file
                for ( i = 0; i < startContexts.length; i++ ) {
                        shownContextList[i] = startContexts[i];
                }

                //Adding a specified userContext
                //reading the user context
                        var selectedIdx = document.userSelectForm.userSelect.selectedIndex;
                        var selectedUser;
                        var userContext;

                if ( selectedIdx > -1 ) {
                        selectedUser = users[selectedIdx];

                        for ( i=0; i < shownContextList.length; i++ ) {
                                context = shownContextList[i];
                                if ( context == null ) continue;
                                contextsNode.options[contextsNode.length] =
                                    new Option( shownContextList[i].displayName,
                                                shownContextList[i].name,
                                                shownContextList[i].path );
                        }

                        contextsNode.options[contextsNode.length] =
                    new Option( selectedUser.displayContextName, selectedUser.name, selectedUser.path );
                        //We always highlight the context that contains the username:contextname
                    contextsNode.selectedIndex = shownContextList.length - 1
                    }
                }
        }

    /*
    * (added for context chooser)
    */
    function assignContextsToUsers2() {
<%if ( isReadContextsSuccess ) {%>
            for ( i = 0; i < users.length; i++ ) {
                if ( users[i] != null ) {
                //users[i].contextName = users[i].name + ':' + defaultContext.name;
                users[i].contextName = defaultContext.name;
                users[i].contextPath = null;
                users[i].isDefaultContext = true;
                users[i].displayContextName = users[i].name + ':' + users[i].contextName + ' (isDefault)';
                }
            }
<%for ( int i = 0; i < users.length; i++ ) {
                    StartContext context = (StartContext) usersListHT.get( users[i].getName() );

                    if ( context != null ) {%>
                    var userIndex = -1;
                    for ( i = 0; i < users.length; i++ ) {
                        if ( users[i].name == '<%=users[i].getName()%>' && users[i].name!= null ) {
                            userIndex = i;
                        }
                    }

                    //users[<%=i%>].contextName = users[i].name + ':' + '<%=context.getContextName()%>';
                    if ( userIndex != -1 ) {
                         users[userIndex].contextName = '<%=context.getContextName()%>';
                         users[userIndex].contextPath = '<%=context.getPath()%>';
                         users[userIndex].isDefaultContext = false;
                         users[userIndex].displayContextName = users[userIndex].name + ':' +
                         users[userIndex].contextName;
                    }
<%}
                }
            }%>
    }

    /**
     * This method is called when the Admin saves a certain context to a user
     *
     * (added for context chooser)
     */
    function saveContext() {

        var contextsNode = document.getElementById( 'contextsSelectList' );

                if ( isReadContextsSuccess ) {

                    selectedUserIdx = document.userSelectForm.userSelect.selectedIndex;
                if ( selectedUserIdx == -1 ) {
                    alert( "Bitte w\u00E4hlen Sie zuerst einen Benutzer aus." );
                    return;
                }
                selectedContextIdx = contextsNode.selectedIndex;
                if ( selectedContextIdx == -1 ) {
                    alert( "Bitte w\u00E4hlen Sie zuerst einen StartContext aus." );
                    return;
                }

                var selectedUser = users[selectedUserIdx];
                var selectedContext = shownContextList[selectedContextIdx];
                if ( selectedContext.isDefault == false ) {
                        selectedUser.contextName = selectedContext.name;
                        selectedUser.contextPath = selectedContext.path;
                        selectedUser.displayContextName = selectedUser.name + ':' + selectedUser.contextName;

                } else { //This is the default context
                        selectedUser.contextName = selectedContext.name;
                        selectedUser.contextPath = null;
                        selectedUser.displayContextName = selectedUser.name + ':' + selectedUser.contextName + ' (isDefault)';
                        //selectedUser.tempContext = new Context( selectedContext.name, null, selectedContext.contextFileName );
                }
                //selectedUser.tempContext.isDefault = selectedContext.isDefault;
                contextsNode.selectedIndex = selectedContextIdx;
                fillContextList();
                }
        }

    /**
     * Called one time to init the users and start contexts
     *
     * (added for context chooser)
     */
    function initContexts() {
        if ( isReadContextsSuccess ) {
            readContextLists();
            assignContextsToUsers2();
        }
    }
//-->
</script>

<table class="maintable">
    <tr>
        <td valign="top">
        <h2>Benutzer-Editor</h2>
        <table border="0" cellpadding="3" cellspacing="0">
            <tr>
                <td align="left">
                <form action="javascript:createUser()" name="userSelectForm">
                <table border="0">
                    <tr>
                        <td class="caption">Benutzerliste</td>
                    </tr>
                    <tr>
                        <td><select class="largeselect" name="userSelect" size="17" onchange="selectUser ();">
                            <option>Formularinitialisierung...</option>
                        </select></td>
                    </tr>
                    <tr>
                        <td height="10">&nbsp;</td>
                    </tr>
                    <tr>
                        <td>
                        <table border="0" cellspacing="5" cellpadding="2">
                            <tr>
                                <td>
                                <table border="0" cellspacing="5" cellpadding="2">
                                    <tr>
                                        <td class="menu"><a href="javascript:createUser()">neuer Benutzer</a></td>
                                    </tr>
                                </table>
                                </td>
                                <td><input type="text" name="userName" /></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                <table border="0" cellspacing="5" cellpadding="2">
                                    <tr>
                                        <td class="menu"><a href="javascript:deleteUser()">Benutzer
                                        l&ouml;schen</a></td>
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
                <td width="30">&nbsp;</td>
                <td width="400" align="center" valign="top">
                <form action="javascript:modifyUser()" name="userEditForm">
                <table border="0" cellspacing="5" cellpadding="5">
                    <tr>
                        <td colspan="2" class="caption" align="center">Benutzerdetails</td>
                    </tr>
                    <tr>
                        <td align="right">Benutzername:</td>
                        <td><input type="text" size="30" name="name" /></td>
                    </tr>
                    <tr>
                        <td align="right">eMail:</td>
                        <td><input type="text" size="30" name="email" onchange="checkUserFields()" /></td>
                    </tr>
                    <tr>
                        <td align="right">Nachname:</td>
                        <td><input type="text" size="30" name="lastName" /></td>
                    </tr>
                    <tr>
                        <td align="right">Vorname:</td>
                        <td><input type="text" size="30" name="firstName" /></td>
                    </tr>
                    <tr>
                        <td align="right">Passwort:</td>
                        <td><input type="password" size="30" name="password" /></td>
                    </tr>
                    <tr>
                        <td align="right">Passwort-Wiederholung:</td>
                        <td><input type="password" size="30" name="password2" /></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                        <table align="right" cellspacing="5" cellpadding="2">
                            <tr>
                                <td class="menu"><a href="javascript:modifyUser()">Benutzerdetails &auml;ndern</a></td>
                            </tr>
                        </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">&nbsp;</td>
                    </tr>
                </table>

                <!-- // added for context chooser --> <%
     if ( isReadContextsSuccess ) {
         // block is not empty, stupid
 %>

                <table border="0" cellspacing="5" cellpadding="5">
                    <tr>
                        <td class="caption" align="center">WebMapContext zuweisen</td>
                    </tr>
                    <tr>
                        <td><select id="contextsSelectList" class="largeselect" style="width: 370px" size="5">
                            <option>ContextsInitializierung...</option>
                        </select></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                        <table align="right" cellspacing="5" cellpadding="2">
                            <tr>
                                <td class="menu"><a href="javascript:saveContext()">BenutzerContext &auml;ndern</a></td>
                            </tr>
                        </table>
                        </td>
                    </tr>
                </table>
                <%
                    }
                %>
                </form>
                </td>
            </tr>
        </table>
        </td>
    </tr>
</table>

<jsp:include page="submittable.jsp" flush="true" />
<jsp:include page="footer.jsp" flush="true" />
