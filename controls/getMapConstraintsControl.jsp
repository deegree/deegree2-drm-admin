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

<script language="JavaScript1.2" type="text/javascript">

    var controllers = new Array();
    
    function ConstraintController( constraintName, getConstraint, setConstraint, maximizeConstraint ) {    
        this.constraintName = constraintName;
        this.getConstraint = getConstraint;
        this.setConstraint = setConstraint;
        this.maximizeConstraint = maximizeConstraint;
    }

    function clearControls() {
        for ( var i = 0; i < controllers.length; i++ ) {
            controllers [i].setConstraint( null );
        }
    }

    function clearConstraints() {
        selected = getSelectedOptions( document.layerSelectForm.layersSelected.options );
        if ( selected.length == 0 ) {
            alert( "W\u00E4hlen Sie bitte zuerst einen Layer aus." );
            return;
        }    
        clearControls();
        assignConstraints();
    }

    function maximizeConstraints() {
        selected = getSelectedOptions( document.layerSelectForm.layersSelected.options );
        if ( selected.length == 0 ) {
            alert( "W\u00E4hlen Sie bitte zuerst einen Layer aus." );
            return;
        }    
        for ( var i = 0; i < controllers.length; i++ ) {
            controllers [i].maximizeConstraint ();
        }
        assignConstraints();        
    }

    function assignConstraints() {    	
        selected = getSelectedOptions( document.layerSelectForm.layersSelected.options );
        if ( selected.length == 0 ) {
            alert( "W\u00E4hlen Sie bitte zuerst einen Layer aus." );
            return;
        }
        for ( i = 0; i < selected.length; i++ ) {
            rights = layers [selected [i].value];
            constraints = new Array ();
            for ( j = 0; j < controllers.length; j++ ) {
                constraints[controllers[j].constraintName] = controllers[j].getConstraint();
            }
            rights.constraints = constraints;
        }
    }
    
    function displayConstraints() {
        selected = getSelectedOptions( document.layerSelectForm.layersSelected.options );
        if ( selected.length == 1 ) {
            rights = layers[selected[0].value];
            if ( rights.constraints != null ) {
	            for ( i = 0; i < controllers.length; i++ ) {
	                controllers[i].setConstraint( rights.constraints[controllers[i].constraintName] );
	            }
            } else {
                for ( i = 0; i < controllers.length; i++ ) {
                    controllers[i].setConstraint( null );
                }
            }
        }
    }

    function checkNumber( value ) {
        value = value.replace( /^[ ]*/, "" ).replace( /[ ]*$/, "" );
        var result = value.match( "^[0-9]*[\.0-9][0-9]*$" );
        if ( !result ) {
           alert( "'" + value + "' ist keine g\u00FCltige Zahl." );
           return null;
        }
        return result[0];
    }

    function checkInteger( value ) {
        value = value.replace( /^[ ]*/, "" ).replace( /[ ]*$/, "" );
        var result = value.match( "^[0-9]*[0-9]*$" );
        if ( !result ) {
           alert( "'" + value + "' ist keine g\u00FCltige Ganzzahl." );
           return null;
        }
        return result[0];
    }    

</script>

<table border="0" cellpadding="5" cellspacing="10">
  <tr>
    <td colspan="3" class="caption">Zugriffsbeschr&auml;nkungen des gew&auml;hlten Layers</td>
  </tr>
  <tr>
    <td valign="top">
      <table border="0" width="300">
        <tr>
          <td>
            <jsp:include page="bgcolorConstraintControl.jsp" flush="true"/>
          </td>
        </tr>
        <tr>
          <td>
            <jsp:include page="transparentConstraintControl.jsp" flush="true"/>            
          </td>
        </tr>
        <tr>
          <td>
            <jsp:include page="formatConstraintControl.jsp" flush="true"/>
          </td>
        </tr>
      </table>
    </td>
    <td valign="top">
      <table border="0" width="300">
        <tr>
          <td>
            <jsp:include page="bboxConstraintControl.jsp" flush="true"/>
          </td>
        </tr>
        <tr>
          <td>
            <jsp:include page="resolutionConstraintControl.jsp" flush="true"/>
          </td>
        </tr>
      </table>
    </td>
    <td valign="top">
      <table border="0" width="300">
        <tr>
          <td>
            <jsp:include page="mapsizeConstraintControl.jsp" flush="true"/>
          </td>
        </tr>
        <tr>
          <td>
            <jsp:include page="exceptionConstraintControl.jsp" flush="true"/>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td colspan="3">
      <table border="0" cellspacing="10" cellpadding="2">
        <tr>
          <td class="menu">
            <a href="javascript:clearConstraints()">keine Beschr&auml;nkungen</a>
          </td>
          <td class="menu">
            <a href="javascript:maximizeConstraints()">maximale Beschr&auml;nkungen</a>
          </td>
          <td class="menu">
            <a href="javascript:assignConstraints()">Beschr&auml;nkungen zuweisen</a>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
