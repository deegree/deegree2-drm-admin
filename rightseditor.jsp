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
    String s = (String) request.getAttribute( "supportManyServices" );
    boolean manyServices = false;
    if ( s != null ) {
        manyServices = s.equalsIgnoreCase( "true" );
    }

    Role role = (Role) request.getAttribute( "ROLE" );
    SecuredObjectRight[] getMapRights = (SecuredObjectRight[]) request.getAttribute( "RIGHTS_GET_MAP" );
    SecuredObjectRight[] getFeatureInfoRights = (SecuredObjectRight[]) request.getAttribute( "RIGHTS_GET_FEATURE_INFO" );
    SecuredObjectRight[] getFeatureRights = (SecuredObjectRight[]) request.getAttribute( "RIGHTS_GET_FEATURE" );
    boolean[] deleteFeatureRights = (boolean[]) request.getAttribute( "RIGHTS_DELETE_FEATURE" );
    boolean[] insertFeatureRights = (boolean[]) request.getAttribute( "RIGHTS_INSERT_FEATURE" );
    boolean[] updateFeatureRights = (boolean[]) request.getAttribute( "RIGHTS_UPDATE_FEATURE" );
    Map<Service, Boolean> serviceRights = (Map) request.getAttribute( "SERVICES_RIGHTS" );
    Map<Service, String> serviceConstraints = (Map) request.getAttribute( "CONSTRAINTS" );

    if ( manyServices ) {
%>
<script language="JavaScript1.2" type="text/javascript" src="js/rightseditorExt.js"></script>
<%
    } else {
%>
<script language="JavaScript1.2" type="text/javascript" src="js/rightseditor.js"></script>
<%
    }
%>
<script language="JavaScript1.2" type="text/javascript">
var linkmap1 = {sort1: "sortfun2 = sortFun(true, 'name'); updateTables()",
                sort2: "sortfun2 = sortFun(false, 'name'); updateTables()",
                sort3: "sortfun2 = sortFun(true, 'title'); updateTables()",
                sort4: "sortfun2 = sortFun(false, 'title'); updateTables()"}
var linkmap2 = {sort5: "sortfun1 = sortFun(true, 'name'); updateTables()",
                sort6: "sortfun1 = sortFun(false, 'name'); updateTables()",
                sort7: "sortfun1 = sortFun(true, 'title'); updateTables()",
                sort8: "sortfun1 = sortFun(false, 'title'); updateTables()"}
<%if ( manyServices ) {
                out.println( "function init() {" );
                out.println( "initFirst()" );
                LinkedList<Service> services = (LinkedList<Service>) request.getAttribute( "SERVICES" );
                if ( services != null ) {
                    for ( Service service : services ) {
                        out.println( "services[\"" + service.getAddress() + "\"] = {}" );
                        out.println( "var service = services[\"" + service.getAddress() + "\"]" );
                        out.println( "service[\"title\"] = "
                                     + ( service.getServiceTitle() == null ? "'(kein Titel)'"
                                                                          : ( "'" + service.getServiceTitle() + "'" ) ) );
                        out.println( "service.objects = {}" );
                        out.println( "service.type = '" + service.getServiceType() + "'" );
                        out.println( "service.dbid = '" + service.getId() + "'" );
                        out.println( "service.sldallowed = " + serviceRights.get( service ) );
                        out.println( "service.address = '" + service.getAddress() + "'" );
                        out.println( "service.constraints = " + serviceConstraints.get( service ) );
                        for ( StringPair pair : service.getObjects() ) {
                            out.println( "service.objects[\"" + pair.first + "\"] = '" + pair.second.replace("'", "\\'") + "'" );
                        }
                    }
                }

                for ( SecuredObjectRight right : getMapRights ) {
                    SecuredObject o = right.getSecuredObject();
                    if ( right.isAccessible() ) {
                        out.print( "accessibleLayers[accessibleLayers.length] = " );
                    } else {
                        out.print( "nonAccessibleLayers[nonAccessibleLayers.length] = " );
                    }
                    out.println( "{name : '" + o.getName() + "', title : '" + o.getTitle().replace("'", "\\'") + "', id: " + o.getID()
                                 + "}" );
                }

                for ( SecuredObjectRight right : getFeatureInfoRights ) {
                    SecuredObject o = right.getSecuredObject();
                    if ( right.isAccessible() ) {
                        out.print( "accessibleFiLayers[accessibleFiLayers.length] = " );
                    } else {
                        out.print( "nonAccessibleFiLayers[nonAccessibleFiLayers.length] = " );
                    }
                    out.println( "{name : '" + o.getName() + "', title : '" + o.getTitle().replace("'", "\\'") + "', id: " + o.getID()
                                 + "}" );
                }

                for ( SecuredObjectRight right : getFeatureRights ) {
                    SecuredObject o = right.getSecuredObject();
                    if ( right.isAccessible() ) {
                        out.print( "accessibleFeatureTypes[accessibleFeatureTypes.length] = " );
                    } else {
                        out.print( "nonAccessibleFeatureTypes[nonAccessibleFeatureTypes.length] = " );
                    }
                    out.println( "{name : '" + o.getName() + "', title : '" + o.getTitle().replace("'", "\\'") + "', id: " + o.getID()
                                 + "}" );
                }

                out.println( "initGui()" );
                out.println( "}" );
            } else {
                out.println( "function init() {" );
                out.println( "changed = false" );
                out.println( "var getMapConstraints = new Array( " + getMapRights.length + ")" );
                for ( int i = 0; i < getFeatureRights.length; i++ ) {
                    SecuredObjectRight right = getFeatureRights[i];
                    out.println( "        featureConstraints[" + i + "] = []" );
                    out.println( "        featureConstraints[" + i + "] [\"ACCESS\"] = true;" );
                    out.println( "        featureConstraints[" + i + "] [\"INSERT\"] = " + insertFeatureRights[i] + ";" );
                    out.println( "        featureConstraints[" + i + "] [\"UPDATE\"] = " + updateFeatureRights[i] + ";" );
                    out.println( "        featureConstraints[" + i + "] [\"DELETE\"] = " + deleteFeatureRights[i] + ";" );
                    out.println( "        featureTypes[" + i + "] = new SecuredObject("
                                 + right.getSecuredObject().getID() + ",'"
                                 + StringTools.replace( right.getSecuredObject().getName(), "'", "\\'", true ) + "',"
                                 + right.isAccessible() + "," + "featureConstraints[" + i + "]);" );
                }

                for ( int i = 0; i < getMapRights.length; i++ ) {
                    SecuredObjectRight right = getMapRights[i];
                    out.println( "        getMapConstraints[" + i + "] = []" );
                    Map constraints = right.getConstraints();

                    String[] bgcolor = (String[]) constraints.get( "bgcolor" );
                    if ( bgcolor != null && bgcolor.length > 0 ) {
                        out.print( "        getMapConstraints[" + i + "] [\"bgcolor\"] = new Array(" );
                        for ( int j = 0; j < bgcolor.length; j++ ) {
                            out.print( "\"" + bgcolor[j] + "\"" );
                            if ( j == bgcolor.length - 1 ) {
                                out.println( ");" );
                            } else {
                                out.print( "," );
                            }
                        }
                    }

                    String[] transparent = (String[]) constraints.get( "transparent" );
                    if ( transparent != null && transparent.length == 1 ) {
                        out.println( "        getMapConstraints[" + i + "] [\"transparent\"] = " + transparent[0] + ";" );
                    }

                    String[] format = (String[]) constraints.get( "format" );
                    if ( format != null && format.length > 0 ) {
                        out.println( "        getMapConstraints[" + i + "] [\"format\"] = new Array();" );
                        for ( int j = 0; j < format.length; j++ ) {
                            out.println( "        getMapConstraints[" + i + "] [\"format\"] [\"" + format[j]
                                         + "\"] = true;" );
                        }
                    }

                    String[] bbox = (String[]) constraints.get( "bbox" );
                    if ( bbox != null && bbox.length > 0 ) {
                        out.print( "        getMapConstraints[" + i + "] [\"bbox\"] = new Array(" );
                        for ( int j = 0; j < bbox.length; j++ ) {
                            out.print( "\"" + bbox[j] + "\"" );
                            if ( j == bbox.length - 1 ) {
                                out.println( ");" );
                            } else {
                                out.print( "," );
                            }
                        }
                    }

                    String[] resolution = (String[]) constraints.get( "resolution" );
                    if ( resolution != null ) {
                        out.println( "        getMapConstraints[" + i + "] [\"resolution\"] = \"" + resolution[0]
                                     + "\";" );
                    }

                    String[] width = (String[]) constraints.get( "width" );
                    if ( width != null && width.length == 1 ) {
                        out.println( "        getMapConstraints[" + i + "] [\"width\"] = \"" + width[0] + "\";" );
                    }

                    String[] height = (String[]) constraints.get( "height" );
                    if ( height != null && height.length == 1 ) {
                        out.println( "        getMapConstraints[" + i + "] [\"height\"] = \"" + height[0] + "\";" );
                    }

                    String[] exceptions = (String[]) constraints.get( "exceptions" );
                    if ( exceptions != null && exceptions.length > 0 ) {
                        out.println( "        getMapConstraints[" + i + "] [\"exceptions\"] = []" );
                        for ( int j = 0; j < exceptions.length; j++ ) {
                            out.println( "        getMapConstraints[" + i + "] [\"exceptions\"] [\"" + exceptions[j]
                                         + "\"] = true;" );
                        }
                    }

                    out.println( "        layers[" + i + "] = new SecuredObject(" + right.getSecuredObject().getID()
                                 + ",'" + StringTools.replace( right.getSecuredObject().getName(), "'", "\\'", true )
                                 + "'," + right.isAccessible() + "," + "getMapConstraints[" + i + "]);" );
                    out.println( "layers.sort(namesort)" );
                    out.println( "featureTypes.sort(namesort)" );                    
                }
                out.println( "initForms()" );
                out.println( "}" );
            }%>

    function perform() {
        if ( confirm( "Wollen Sie die vorgenommenen \u00C4nderungen wirklich speichern?" ) ) {
<%if ( manyServices ) {
                out.println( "var opt = document.getElementById('services')" );
                out.println( "var service = optionsToServices[opt.options[opt.selectedIndex].firstChild.nodeValue]" );
                out.println( "service.sldallowed = document.getElementById('sldSwitch').checked" );
                out.println( "service.constraints = {maxWidth: document.getElementById('maxWidth').value," );
                out.println( "                       maxHeight: document.getElementById('maxHeight').value}" );
                //out.println( "storeRightsExt(accessibleLayers, accessibleFeatureTypes, " + role.getID() + ")" );
	            out.println( "storeFinegrainedRights(accessibleLayers, accessibleFiLayers, accessibleFeatureTypes, " + role.getID() + ", service.dbid, service.sldallowed, service.constraints)" );
            } else {
                out.println( "securedObjectTypes = []" );
                out.println( "securedObjectTypes[0] = layers" );
                out.println( "securedObjectTypes[1] = featureTypes" );
                out.println( "storeRights(securedObjectTypes, " + role.getID() + ")" );
            }%>
        }
    }
</script>
<%
    if ( manyServices ) {
%>

<table class="maintable">
    <tr>
        <td valign="top" colspan="3">
        <h2>Rechte-Editor</h2>
        <p><i>Definieren Sie hier, welche Informationsebenen für die Rolle '<%=role.getName()%>' freigeschaltet sein
        sollen</i></p><br>
        </td>
    </tr>
    <tr>
        <td colspan="3" class="caption">Service: <select name="service" id="services" onchange="switchService()">
        </select><select name="rightTypes" id="rightTypes" onchange="switchRightType()" >
        <option label="GetMap" value="GetMap">GetMap</option>
        <option label="GetFeatureInfo" value="GetFeatureInfo">GetFeatureInfo</option>
        </select>
        <input type="checkbox" id="sldSwitch" checked="checked" /><label id="sldSwitchLabel" for="sldSwitch">SLD-Requests erlauben</label>&nbsp;&#124;&nbsp;
        <label id="maxWidthLabel" for="maxWidth">Maximale Kartenbreite: </label><input type="text" size="5" id="maxWidth" />&nbsp;&#124;&nbsp;
        <label id="maxHeightLabel" for="maxHeight">Maximale Kartenhöhe: </label><input type="text" size="5" id="maxHeight" />
        </td>
    </tr>
    <tr>
        <td style="width: 40%; height: 75%; padding-bottom: 10px;" valign="top">
        <p id="leftHeader" class="caption">Freigeschaltete Layer</p>
        <div id="leftDiv" class="scrollable">
        <table id="leftTable" rules="all" class="centeredTable">
            <tr id="leftHeaderRow">
                <th class="servicesBorder">Nr.</th>
                <th class="servicesBorder">Name<a class="sorting" id="sort5" title="Aufsteigend sortieren"
                    href="javascript:sortLinkClicked(linkmap2, 'sort5')">&lsaquo;</a><a class="sorting" id="sort6"
                    title="Absteigend sortieren" href="javascript:sortLinkClicked(linkmap2, 'sort6')">&rsaquo;</a></th>
                <th class="servicesBorder">Titel<a class="sorting" href="javascript:sortLinkClicked(linkmap2, 'sort7')" id="sort7"
                    title="Aufsteigend sortieren">&lsaquo;</a><a class="sorting"
                    href="javascript:sortLinkClicked(linkmap2, 'sort8')" id="sort8" title="Absteigend sortieren">&rsaquo;</a></th>
            </tr>
        </table>
        </div>
        </td>
        <td valign="middle" align="center"><a href="javascript:move('left')"><img src="images/admin_bt_add.gif"
            alt="+" border="0" /></a> <br />
        <a href="javascript:move('right')"><img src="images/admin_bt_remove.gif" alt="-" border="0" /></a></td>
        <td style="width: 40%; height: 75%; padding-bottom: 10px;" valign="top">
        <p id="rightHeader" class="caption">Gesperrte Layer</p>
        <div id="rightDiv" class="scrollable">
        <table id="rightTable" rules="all" class="centeredTable">
            <tr id="rightHeaderRow">
                <th class="servicesBorder">Nr.</th>
                <th class="servicesBorder">Name<a id="sort1" class="sorting" title="Aufsteigend sortieren"
                    href="javascript:sortLinkClicked(linkmap1, 'sort1')">&lsaquo;</a><a id="sort2" class="sorting"
                    title="Absteigend sortieren" href="javascript:sortLinkClicked(linkmap1, 'sort2')">&rsaquo;</a></th>
                <th class="servicesBorder">Titel<a id="sort3" class="sorting" href="javascript:sortLinkClicked(linkmap1, 'sort3')"
                    title="Aufsteigend sortieren">&lsaquo;</a><a id="sort4" class="sorting"
                    href="javascript:sortLinkClicked(linkmap1, 'sort4')" title="Absteigend sortieren">&rsaquo;</a></th>
            </tr>
        </table>
        </div>
        </td>
    </tr>
</table>
<%
    } else {
%>
<table class="maintable">
    <tr>
        <td valign="top">
        <h2>Rechte-Editor</h2>
        <h3>Rolle: '<%=role.getName()%>'</h3>
        <table border="0" cellpadding="3" cellspacing="0">
            <tr>
                <td valign="top">
                <form action="" name="featureTypeSelectForm">
                <table border="0">
                    <tr>
                        <td class="caption">zugreifbare FeatureTypes</td>
                        <td>&nbsp;</td>
                        <td class="caption">gesperrte FeatureTypes</td>
                    </tr>
                    <tr>
                        <td><select class="largeselect" name="featureTypesSelected" size="10" multiple="multiple"
                            onchange="displayModificationRights()">
                            <option>Formularinitialisierung...</option>
                        </select></td>
                        <td valign="middle" align="center"><a href="javascript:setFeatureTypeRights(true)"><img
                            src="images/admin_bt_add.gif" alt="+" border="0" /></a> <br />
                        <a href="javascript:setFeatureTypeRights(false)"><img src="images/admin_bt_remove.gif"
                            alt="-" border="0" /></a></td>
                        <td><select class="largeselect" name="featureTypesAvailable" size="10" multiple="multiple">
                            <option>Formularinitialisierung...</option>
                        </select></td>
                    </tr>
                    <tr>
                        <td>
                        <table border="0" width="400">
                            <tr>
                                <td>
                                <fieldset><legend> <b>Modifikationsrechte f&uuml;r
                                gew&auml;hlten FeatureType</b> </legend>
                                <table border="0">
                                    <tr>
                                        <td>&nbsp;&nbsp;&nbsp;<input type="checkbox"
                                            name="featureTypeModifications" onclick="setFeatureTypeModificationRights()" />delete</td>
                                        <td>&nbsp;&nbsp;&nbsp;<input type="checkbox"
                                            name="featureTypeModifications" onclick="setFeatureTypeModificationRights()" />insert</td>
                                        <td>&nbsp;&nbsp;&nbsp;<input type="checkbox"
                                            name="featureTypeModifications" onclick="setFeatureTypeModificationRights()" />update</td>
                                    </tr>
                                </table>
                                </fieldset>
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
        <hr />
        <table border="0" cellpadding="3" cellspacing="0">
            <tr>
                <td valign="top">
                <form action="" name="layerSelectForm">
                <table border="0">
                    <tr>
                        <td class="caption">zugreifbare Layer (mit Beschr&auml;nkungen)</td>
                        <td>&nbsp;</td>
                        <td class="caption">gesperrte Layer</td>
                    </tr>
                    <tr>
                        <td><select class="largeselect" name="layersSelected" size="10"
                            onchange="displayConstraints()">
                            <option>Formularinitialisierung...</option>
                        </select></td>
                        <td valign="middle" align="center"><a href="javascript:setGetMapRights(true)"><img
                            src="images/admin_bt_add.gif" alt="+" border="0" /></a> <br />
                        <a href="javascript:setGetMapRights(false)"><img src="images/admin_bt_remove.gif" alt="-"
                            border="0" /></a></td>
                        <td><select class="largeselect" name="layersAvailable" size="10" multiple="multiple">
                            <option>Formularinitialisierung...</option>
                        </select></td>
                    </tr>
                </table>
                </form>
                </td>
            </tr>
        </table>
        <jsp:include page="controls/getMapConstraintsControl.jsp" flush="true" /></td>
    </tr>
</table>
<%
    }
%>
<jsp:include page="submittable.jsp" flush="true" />
<jsp:include page="footer.jsp" flush="true" />

