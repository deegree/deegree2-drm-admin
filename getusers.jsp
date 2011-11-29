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
<%@ page import="org.deegree.security.drm.model.*" %>
<%@ page import="org.deegree.framework.util.StringTools" %>
<%
    User [] users = (User []) request.getAttribute ("USERS");
%>

<html>
  <head>
    <script src="js/menufunctions.js" type="text/javascript"></script>
    <script type="text/javascript">
    <!--
      function User (id, name) {
        this.id = id;
        this.name = name;
      }

      function getUsersProxy (regex) {
        getUsers (regex);
      }

      function init () {
        users = new Array (<%= users.length %>);
<%
    for (int i = 0; i < users.length; i++) {
        out.println ("        users [" + i + "] = new User (" + users [i].getID () + ",'"
            + StringTools.replace (users [i].getName (), "'", "\\'", true) + "');");
    }
%>
        users.sort (namesort);
        parent.setGetUsersWindow (this);
        parent.setUsers (users);
      }
    //-->
    </script>
  </head>
  <body onload="init ()">
  </body>
</html>
