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
    SecuredObject[] layers = ( SecuredObject[] ) request.getAttribute( ClientHelper.TYPE_LAYER );
    SecuredObject[] featureTypes = ( SecuredObject[] ) request.getAttribute( ClientHelper.TYPE_FEATURETYPE );
%>                          

<script language="JavaScript1.2" type="text/javascript">
<!--
    var layers, featureTypes;

    /**
     * Constructs a new SecuredObject-object, consisting of:
     *
     * - id:          unique identifier (-1 means: new)
     * - name:        display name
     * - type:        Layer / Featuretype / ...
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
        refreshLayerListBox();
        refreshFeatureTypeListBox();
    }
    
     /**
      * Fills the Layer listbox with the data from the layers-Array.
      */
    function refreshLayerListBox() {
        var oldCount = document.layerForm.layerSelect.length;
        for ( i = oldCount - 1; i >= 0 ; i-- ) {
            document.layerForm.layerSelect.options[i] = null;
        }    
        for ( i = 0; i < layers.length; i++ ) {
            document.layerForm.layerSelect.options[document.layerForm.layerSelect.length] =
                new Option( layers[i].name, layers[i].id );
        }
     }

     /**
      * Fills the FeatureType listbox with the data from the featureType-Array.
      */
    function refreshFeatureTypeListBox() {
        var oldCount = document.featureTypeForm.featureTypeSelect.length;
        for ( i = oldCount - 1; i >= 0 ; i-- ) {
            document.featureTypeForm.featureTypeSelect.options [i] = null;
        }    
        for ( i = 0; i < featureTypes.length; i++ ) {
            document.featureTypeForm.featureTypeSelect.options[document.featureTypeForm.featureTypeSelect.length] =
                new Option( featureTypes[i].name, featureTypes[i].id );
        }
     }

    /**
     * Adds a new Layer to the layers-array. Keeps the array in alphabetical order.
     */
    function createLayer() {
        var layerName = document.layerForm.layerName.value;
        if ( layerName == null || layerName == '' ) {
            alert( "Bitte geben Sie einen Namen ein." );
            return;
        }    
        for ( i = 0; i < layers.length; i++ ) {
            if ( layerName == layers[i].name ) {
                alert( "Es existiert bereits ein Layer namens '" + layerName + "'!" );
                return;
            }
        }
        var layerIdx = layers.length;
        layers[layerIdx] = new SecuredObject( -1, layerName, "<%= ClientHelper.TYPE_LAYER %>" );
        layers.sort( namesort );
        refreshLayerListBox();
        document.layerForm.layerName.value = "";
        changed = true
    }

    /**
     * Deletes the selected Layers from the layers-Array.
     */
    function deleteLayers() {
        selected = getSelectedOptionsIdx( document.layerForm.layerSelect.options );
        if ( selected.length == 0 ) {
            alert( "W\u00E4hlen Sie bitte zuerst einen Layer aus." );
            return;
        }
        // remove from layers-Array
        for ( i = 0; i < selected.length; i++ ) {
            layerId = selected[i];
            if ( i != selected.length - 1 ) {
                nextId = selected[i + 1];
            } else {
                nextId = layers.length;
            }
            for ( j = layerId + 1; j < nextId; j++ ) {
                layers[j - (i + 1)] = layers[j];
            }
        }
        layers.length = layers.length - selected.length;
        refreshLayerListBox();
        changed = true
    }

    /**
     * Adds a new FeatureType to the featureTypes-array. Keeps the array in alphabetical order.
     */
    function createFeatureType () {
        var featureTypeName = document.featureTypeForm.featureTypeName.value;
        if ( featureTypeName == null || featureTypeName == '' ) {
            alert( "Bitte geben Sie einen Namen ein." );
            return;
        }    
        for ( i = 0; i < featureTypes.length; i++ ) {
            if ( featureTypeName == featureTypes[i].name ) {
                alert( "Es existiert bereits ein FeatureType namens '" + featureTypeName + "'!" );
                return;
            }
        }
        var featureTypeIdx = featureTypes.length;
        featureTypes[featureTypeIdx] = new SecuredObject( -1, featureTypeName, "<%= ClientHelper.TYPE_FEATURETYPE %>" );
        featureTypes.sort( namesort );
        refreshFeatureTypeListBox();
        document.featureTypeForm.featureTypeName.value = "";
        changed = true
    }

    /**
     * Deletes the selected FeatureTypes from the featureTypes-Array.
     */
    function deleteFeatureTypes() {
        selected = getSelectedOptionsIdx( document.featureTypeForm.featureTypeSelect.options );
        if ( selected.length == 0 ) {
            alert( "W\u00E4hlen Sie bitte zuerst einen FeatureType aus." );
            return;
        }
        // remove from featureTypes-Array
        for ( i = 0; i < selected.length; i++ ) {
            featureTypeId = selected[i];
            if ( i != selected.length - 1 ) {
                nextId = selected[i + 1];
            } else {
                nextId = featureTypes.length;
            }
            for ( j = featureTypeId + 1; j < nextId; j++ ) {
                featureTypes[j - (i + 1)] = featureTypes[j];
            }
        }
        featureTypes.length = featureTypes.length - selected.length;
        refreshFeatureTypeListBox();
        changed = true
    }

    function init() {
<%
        out.println( "        layers = new Array( " + layers.length + " );" );
        for ( int i = 0; i < layers.length; i++ ) {
            out.println( "        layers[" + i + "] = new SecuredObject( " + layers [i].getID () + ", '"
                + StringTools.replace( layers[i].getName(), "'", "\\'", true ) + "', '" +  ClientHelper.TYPE_LAYER + "' );" );
        }
        out.println( "        layers.sort( namesort );" );
        out.println( "        featureTypes = new Array( " + featureTypes.length + " );" );
        for ( int i = 0; i < featureTypes.length; i++ ) {
            out.println( "        featureTypes[" + i + "] = new SecuredObject( " + featureTypes [i].getID () + ", '"
                + StringTools.replace( featureTypes[i].getName(), "'", "\\'", true ) + "', '" +  ClientHelper.TYPE_FEATURETYPE + "' );" );
        }
        out.println( "        featureTypes.sort( namesort );" );
%>
        changed = false;
        initForm();
    }

    function perform() {
        if ( confirm( "Wollen Sie die vorgenommenen \u00C4nderungen wirklich speichern?" ) ) {
            objectTypes = new Array(2);
            objectTypes[0] = layers;
            objectTypes[1] = featureTypes;
            storeSecuredObjects( objectTypes );
        }
    }

//-->
</script>

<table class="maintable">
  <tr>
    <td valign="top">
      <h2>Layer-/FeatureType-Editor</h2>
      <table border="0" cellpadding="3" cellspacing="0">
        <tr>
          <td align="left">
            <form action="javascript:createLayer()" name="layerForm">
              <table border="0">
                <tr>
                  <td class="caption">Layers</td>
                </tr>
                <tr>
                  <td colspan="2">
                    <select class="largeselect" name="layerSelect" size="17" multiple="multiple">
                      <option>Formularinitialisierung...</option>
                    </select>
                  </td>
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
                              <td class="menu">
                                <a href="javascript:createLayer()">neuer Layer</a>
                              </td>
                            </tr>
                          </table>
                        </td>
                        <td>
                          <input type="text" name="layerName"/>
                        </td>
                      </tr>
                      <tr>
                        <td colspan="2">
                          <table border="0" cellspacing="5" cellpadding="2">
                            <tr>
                              <td class="menu">
                                <a href="javascript:deleteLayers()">Layer l&ouml;schen</a>
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
          <td width="80"/>
          <td align="left">
            <form action="javascript:createFeatureType()" name="featureTypeForm">
              <table border="0">
                <tr>
                  <td class="caption">FeatureTypes</td>
                </tr>
                <tr>
                  <td colspan="2">
                    <select class="largeselect" name="featureTypeSelect" size="17" multiple="multiple">
                      <option>Formularinitialisierung...</option>
                    </select>
                  </td>
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
                              <td class="menu">
                                <a href="javascript:createFeatureType()">neuer FeatureType</a>
                              </td>
                            </tr>
                          </table>
                        </td>
                        <td>
                          <input type="text" name="featureTypeName" />
                        </td>
                      </tr>
                      <tr>
                        <td colspan="2">
                          <table border="0" cellspacing="5" cellpadding="2">
                            <tr>
                              <td class="menu">
                                <a href="javascript:deleteFeatureTypes()">FeatureType(s) l&ouml;schen</a>
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

<jsp:include page="submittable.jsp" flush="true"/>
<jsp:include page="footer.jsp" flush="true"/>

