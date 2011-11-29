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
<%@ page contentType="text/html; charset=UTF-8"%>
<jsp:include page="header.jsp" flush="true" />
<jsp:include page="logotable.jsp" flush="true" />
<jsp:include page="menutable.jsp" flush="true" />

<%@ page import="java.util.*"%>
<%@ page import="org.deegree.security.drm.model.*"%>
<%@ page import="org.deegree.framework.util.*"%>
<%@ page import="org.deegree.portal.standard.security.control.SecuredObjectRight"%>

<%
    Role role = (Role) request.getAttribute( "ROLE" );
    LinkedList<Service> selectedServices = (LinkedList)request.getAttribute("SELECTED_SERVICES");
    LinkedList<Service> availableServices = (LinkedList)request.getAttribute("AVAILABLE_SERVICES");
%>

<script language="JavaScript1.2" type="text/javascript" src="js/menufunctions.js"></script>
<script language="JavaScript1.2" type="text/javascript" src="js/servicesrightseditor.js"></script>
<script language="JavaScript1.2" type="text/javascript">
var linkmap2 = {sort1: "sortfun1 = sortFun(true, 'type'); updateTables()",
                sort2: "sortfun1 = sortFun(false, 'type'); updateTables()",
                sort3: "sortfun1 = sortFun(true, 'title'); updateTables()",
                sort4: "sortfun1 = sortFun(false, 'title'); updateTables()",
                sort5: "sortfun1 = sortFun(true, 'address'); updateTables()",
                sort6: "sortfun1 = sortFun(false, 'address'); updateTables()"}
var linkmap1 = {sort7: "sortfun2 = sortFun(true, 'type'); updateTables()",
                sort8: "sortfun2 = sortFun(false, 'type'); updateTables()",
                sort9: "sortfun2 = sortFun(true, 'title'); updateTables()",
                sort10: "sortfun2 = sortFun(false, 'title'); updateTables()",
                sort11: "sortfun2 = sortFun(true, 'address'); updateTables()",
                sort12: "sortfun2 = sortFun(false, 'address'); updateTables()"}
var selected = []
var available = []
var roleId = '<%=role.getID()%>'
<%
                out.println( "function init() {" );
                out.println( "selected = []" );
                out.println( "available = []" );
                out.println( "initFirst()" );
                for ( Service service : selectedServices ) {
                    out.println( "var service = {}" );
                    out.println( "selected[selected.length] = service" );
                    out.println( "service[\"title\"] = "
                                 + ( service.getServiceTitle() == null ? "'(kein Titel)'"
                                                                      : ( "'" + service.getServiceTitle() + "'" ) ) );
                    out.println( "service.type = '" + service.getServiceType() + "'" );
                    out.println( "service.address = '" + service.getAddress() + "'" );
                    out.println( "service.id = '" + service.getId() + "'" );
                }

                for ( Service service : availableServices ) {
                    out.println( "var service = {}" );
                    out.println( "available[available.length] = service" );
                    out.println( "service[\"title\"] = "
                                 + ( service.getServiceTitle() == null ? "'(kein Titel)'"
                                                                      : ( "'" + service.getServiceTitle() + "'" ) ) );
                    out.println( "service.type = '" + service.getServiceType() + "'" );
                    out.println( "service.address = '" + service.getAddress() + "'" );
                    out.println( "service.id = '" + service.getId() + "'" );
                }

                out.println( "initGui()" );
                out.println( "}" );
%>

    function perform() {
        if ( confirm( "Wollen Sie die vorgenommenen \u00C4nderungen wirklich speichern?" ) ) {
            storeServicesRights(selected, roleId)
        }
    }
</script>

<table class="maintable">
    <tr>
        <td valign="top" colspan="3">
        <h2>Rechte-Editor</h2>
        <p><i>Definieren Sie hier, welche Dienste für die Rolle '<%=role.getName()%>' freigeschaltet sein
        sollen</i></p><br>
        </td>
    </tr>
    <tr>
        <td style="width: 40%; height: 75%; padding-bottom: 10px;" valign="top">
        <p id="leftHeader" class="caption">Freigeschaltete Dienste</p>
        <div id="leftDiv" class="scrollable">
        <table id="leftTable" rules="all" class="centeredTable">
            <tr id="leftHeaderRow">
                <th class="servicesBorder">Nr.</th>
                <th class="servicesBorder">Typ<a class="sorting" id="sort1" title="Aufsteigend sortieren"
                    href="javascript:sortLinkClicked(linkmap2, 'sort1')">&lsaquo;</a><a class="sorting" id="sort2"
                    title="Absteigend sortieren" href="javascript:sortLinkClicked(linkmap2, 'sort2')">&rsaquo;</a></th>
                <th>Titel<a class="sorting" href="javascript:sortLinkClicked(linkmap2, 'sort3')" id="sort3"
                    title="Aufsteigend sortieren">&lsaquo;</a><a class="sorting"
                    href="javascript:sortLinkClicked(linkmap2, 'sort4')" id="sort4" title="Absteigend sortieren">&rsaquo;</a></th>
                <th>Adresse<a class="sorting" href="javascript:sortLinkClicked(linkmap2, 'sort5')" id="sort5"
                    title="Aufsteigend sortieren">&lsaquo;</a><a class="sorting"
                    href="javascript:sortLinkClicked(linkmap2, 'sort6')" id="sort6" title="Absteigend sortieren">&rsaquo;</a></th>
            </tr>
        </table>
        </div>
        </td>
        <td valign="middle" align="center"><a href="javascript:move('left')"><img src="images/admin_bt_add.gif"
            alt="+" border="0" /></a> <br />
        <a href="javascript:move('right')"><img src="images/admin_bt_remove.gif" alt="-" border="0" /></a></td>
        <td style="width: 40%; height: 75%; padding-bottom: 10px;" valign="top">
        <p id="rightHeader" class="caption">Gesperrte Dienste</p>
        <div id="rightDiv" class="scrollable">
        <table id="rightTable" rules="all" class="centeredTable">
            <tr id="rightHeaderRow">
                <th class="servicesBorder">Nr.</th>
                <th class="servicesBorder">Typ<a id="sort7" class="sorting" title="Aufsteigend sortieren"
                    href="javascript:sortLinkClicked(linkmap1, 'sort7')">&lsaquo;</a><a id="sort8" class="sorting"
                    title="Absteigend sortieren" href="javascript:sortLinkClicked(linkmap1, 'sort8')">&rsaquo;</a></th>
                <th>Titel<a id="sort9" class="sorting" href="javascript:sortLinkClicked(linkmap1, 'sort9')"
                    title="Aufsteigend sortieren">&lsaquo;</a><a id="sort10" class="sorting"
                    href="javascript:sortLinkClicked(linkmap1, 'sort10')" title="Absteigend sortieren">&rsaquo;</a></th>
                <th>Adresse<a id="sort11" class="sorting" href="javascript:sortLinkClicked(linkmap1, 'sort11')"
                    title="Aufsteigend sortieren">&lsaquo;</a><a id="sort12" class="sorting"
                    href="javascript:sortLinkClicked(linkmap1, 'sort12')" title="Absteigend sortieren">&rsaquo;</a></th>
            </tr>
        </table>
        </div>
        </td>
    </tr>
</table>

<jsp:include page="submittable.jsp" flush="true" />
<jsp:include page="footer.jsp" flush="true" />

