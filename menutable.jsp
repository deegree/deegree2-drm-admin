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
<%@ page import="org.deegree.portal.standard.security.control.ClientHelper"%>

<%
    String s = (String) request.getAttribute( "supportManyServices" );
    boolean manyServices = false;
    if ( s != null ) {
        manyServices = s.equalsIgnoreCase( "true" );
    }
%>

<table class="menutable" cellpadding="2" cellspacing="0">
    <tr>
        <%
            if ( manyServices ) {
        %>
        <td class="menu" align="center"><a href="javascript:initServicesEditor()">Services</a></td>
        <td class="menu" width="23" />
        <%
            } else {
        %>
        
        <td class="menu" align="center"><a href="javascript:initSecuredObjectsEditor()">Layers/FeatureTypes</a></td>
        <td class="menu" width="23" />
        <%
            }
        %>
        
        <td class="menu" align="center"><a href="javascript:initUserEditor()">Benutzer</a></td>
        <td class="menu" width="23">&nbsp;</td>
        <td class="menu" align="center"><a href="javascript:initGroupEditor()">Gruppen</a></td>
        <td class="menu" width="23">&nbsp;</td>
        <td class="menu" align="center"><a href="javascript:initRoleEditor()">Rollen</a></td>
        <td class="menu" width="23">&nbsp;</td>
        <td class="menu" align="center"><a href="javascript:logoutUser()"> <%
     if ( session.getAttribute( ClientHelper.KEY_USERNAME ) == null ) {
         out.println( "Login" );
     } else {
         out.println( "Logout (" + session.getAttribute( ClientHelper.KEY_USERNAME ) + ")" );
     }
 %> </a></td>
        <td class="menu" width="23">&nbsp;</td>
    </tr>
</table>
