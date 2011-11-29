<jsp:include page="header.jsp" flush="true" />
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
<jsp:include page="logotable.jsp" flush="true" />
<jsp:include page="menutable.jsp" flush="true" />

<%@ page import="org.deegree.security.drm.model.*"%>
<%@ page import="org.deegree.portal.standard.security.control.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.deegree.framework.util.*"%>

<script language="JavaScript1.2" type="text/javascript" src="js/updateservice.js"></script>
<script language="JavaScript1.2" type="text/javascript">
function init() {
    services = {}
<%
    Service oldService = (Service)request.getAttribute("OLDSERVICE");
    Service newService = (Service)request.getAttribute("NEWSERVICE");
    out.println("oldservice = {}");
    out.println("oldservice[\"title\"] = '" + (oldService.getServiceTitle() == null ? "(kein Titel)" : oldService.getServiceTitle()) + "'");
    out.println("oldservice.objects = {}");
    out.println("oldservice.type = '" + oldService.getServiceType() + "'");
    out.println("oldservice.address = '" + oldService.getAddress() + "'");
    for(StringPair pair : oldService.getObjects()){
        out.println("oldservice.objects[\"" + pair.first + "\"] = '" + pair.second.replace("'", "\\'") + "'");
    }

    out.println("newservice = {}");
    out.println("newservice[\"title\"] = '" + (newService.getServiceTitle() == null ? "(kein Titel)" : newService.getServiceTitle()) + "'");
    out.println("newservice.objects = {}");
    out.println("newservice.type = '" + newService.getServiceType() + "'");
    out.println("newservice.address = '" + newService.getAddress() + "'");
    for(StringPair pair : newService.getObjects()){
        out.println("newservice.objects[\"" + pair.first + "\"] = '" + pair.second.replace("'", "\\'") + "'");
    }

%>

    generateComparison()
}
</script>
<table class="maintablebig">
    <tr>
        <td valign="top">
        <h2>Service aktualisieren</h2>
        <div id="comparison">
        </div>
        </td>
    </tr>
</table>
<jsp:include page="footer.jsp" flush="true" />
