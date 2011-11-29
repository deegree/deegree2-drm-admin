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
<script language="JavaScript1.2" type="text/javascript">
<!--
    controllers.push( new ConstraintController( "bgcolor", bgcolor_getConstraint, bgcolor_setConstraint, bgcolor_maximizeConstraint ) );
  
    function bgcolor_getConstraint() {
        if ( document.bgcolor_form.bgcolor_choice[0].checked ) {
            return null;
        }
        var values = document.bgcolor_form.bgcolor_list.value.split( "," );
        for ( var i = 0; i < values.length; i++ ) {          
            var value = values[i].replace( /^[ ]*/, "" ).replace( /[ ]*$/, "" );
            var result = value.match( "^0x[0-9a-fA-F]{6,6}$" );            
            if ( !result ) {
               alert( "'" + value + "' ist kein gültiger Farbwert.\n\nErwartet wird eine Liste von Farbwerten, z.B. '0x000000,0xffffff'." );
               return null;
            }
            values[i] = result[0];
        }       
        return values;
    }

    function bgcolor_setConstraint( constraint ) {
        if ( constraint == null ) {
            document.bgcolor_form.bgcolor_choice[0].checked = true;
            document.bgcolor_form.bgcolor_list.value = "";
        } else {
            document.bgcolor_form.bgcolor_choice[1].checked = true;
            var listValue = "";
            for ( var i = 0; i < constraint.length; i++ ) {
                listValue += constraint[i];
                if ( i != constraint.length - 1 ) {
                    listValue += ",";
                }
            }
            document.bgcolor_form.bgcolor_list.value = listValue;
        }
    }
    
    function bgcolor_maximizeConstraint() {
        bgcolor_setConstraint( new Array( "0xffffff" ) );
    }
//-->
</script>
<fieldset>
  <legend>
    <b>Hintergrundfarbe(n)</b>
  </legend>
  <form class="control" name="bgcolor_form" action="javascript:assignConstraints()">
	  <table border="0">
	    <tr>
	      <td colspan="2">
	        <input type="radio" name="bgcolor_choice" checked="checked" onclick="bgcolor_form.bgcolor_list.value=''"/>unbeschr&auml;nkt</td>
	    </tr>
	    <tr>
	      <td>
	        <input type="radio" name="bgcolor_choice"/>nur die folgende(n):</td>
	      <td>
	        <input type="text" name="bgcolor_list" size="10" onfocus="form.bgcolor_choice[1].checked=true"/>
	      </td>
	    </tr>
	  </table>
  </form>
</fieldset>
