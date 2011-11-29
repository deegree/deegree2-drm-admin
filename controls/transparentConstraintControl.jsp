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
    controllers.push( new ConstraintController( "transparent", transparent_getConstraint, transparent_setConstraint, transparent_maximizeConstraint ) );
  
    function transparent_getConstraint() {    
        switch( document.transparent_form.transparent_select.selectedIndex ) {
	        case 0: {
	            return null;
	            break;
	        }
	        case 1: {
	            return true;
	            break;
	        }
	        case 2: {
	            return false;
	            break;                
	        }
	        default: {
	            alert( "Internal error." );
	        }
	    }
    }

    function transparent_setConstraint( constraint ) {
        if ( constraint == null ) {
            document.transparent_form.transparent_select.selectedIndex = 0;
        } else if ( constraint ) {
            document.transparent_form.transparent_select.selectedIndex = 1;
        } else {
            document.transparent_form.transparent_select.selectedIndex = 2;
        }
    }
    
    function transparent_maximizeConstraint() {
        transparent_setConstraint( false );
    }
//-->
</script>
<fieldset>
    <legend>
        <b>Transparenz</b>
    </legend>
    <form class="control" action="" name="transparent_form">
        <table border="0">
            <tr>
                <td>
                    <select name="transparent_select" size="1">
                        <option selected="selected">unbeschr&auml;nkt</option>
                        <option>true</option>
                        <option>false</option>
                    </select>
                </td>
            </tr>
        </table>
    </form>
</fieldset>

