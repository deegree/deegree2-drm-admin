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
<%@ page contentType="text/html"%>
<jsp:include page="header.jsp" flush="true" />
<jsp:include page="logotable.jsp" flush="true" />
<jsp:include page="menutable.jsp" flush="true" />

<%
    String s = (String) request.getAttribute( "supportManyServices" );
    boolean manyServices = false;
    if ( s != null ) {
        manyServices = s.equalsIgnoreCase( "true" );
    }
%>

<script language="JavaScript1.2" type="text/javascript">
        function init() {
        }
</script>

<table class="maintable">
    <tr>
        <td valign="top">
        <h2>Administrationsmen&uuml;</h2>
        <table border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td height="5"></td>
            </tr>
        </table>
        <table border="0" cellpadding="0" cellspacing="5">
            <%
                if ( manyServices ) {
            %>
            <tr>
                <td><a href="javascript:initServicesEditor()">Services</a></td>
                <td width="20">&nbsp;</td>
                <td>Services definieren / l&ouml;schen</td>
            </tr>
            <%
                } else {
            %>
            <tr>
                <td><a href="javascript:initSecuredObjectsEditor()">Layers/FeatureTypes</a></td>
                <td width="20">&nbsp;</td>
                <td>Layers + FeatureTypes definieren / l&ouml;schen</td>
            </tr>
            <%
                }
            %>
            <tr>
                <td><a href="javascript:initUserEditor()">Benutzer</a></td>
                <td width="20">&nbsp;</td>
                <td>Benutzer definieren / l&ouml;schen</td>
            </tr>
            <tr>
                <td><a href="javascript:initGroupEditor()">Gruppen</a></td>
                <td width="20">&nbsp;</td>
                <td>Gruppen definieren / l&ouml;schen</td>
            </tr>
            <tr>
                <td><a href="javascript:initRoleEditor()">Rollen</a></td>
                <td width="20">&nbsp;</td>
                <td>Rollen definieren / l&ouml;schen</td>
            </tr>
        </table>
        </td>
    </tr>
</table>

<jsp:include page="footer.jsp" flush="true" />
