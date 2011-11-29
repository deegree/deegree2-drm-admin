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
    controllers.push( new ConstraintController( "resolution", resolution_getConstraint, resolution_setConstraint, resolution_maximizeConstraint ) );
  
    function resolution_getConstraint() {
        if ( document.resolution_form.resolution_choice[0].checked ) {
            return null;
        }
        return checkNumber( document.resolution_form.resolution_value.value );
    }

    function resolution_setConstraint( constraint ) {
        if ( constraint == null ) {
            document.resolution_form.resolution_choice[0].checked = true;
            document.resolution_form.resolution_value.value = "";
        } else {
            document.resolution_form.resolution_choice[1].checked = true;
            document.resolution_form.resolution_value.value = constraint;
        }
    }

    function resolution_maximizeConstraint() {
        resolution_setConstraint( 10 );
    }    
//-->
</script>
<fieldset>
  <legend>
    <b>maximale Aufl&ouml;sung (Meter)</b>
  </legend>
  <form class="control" action="javascript:assignConstraints()" name="resolution_form">
	  <table border="0">
	    <tr>
	      <td colspan="2">
	        <input type="radio" name="resolution_choice" checked="checked" onclick="resolution_form.resolution_value.value=''"/>unbeschr&auml;nkt
	      </td>
	    </tr>
	    <tr>
	      <td>
	        <input type="radio" name="resolution_choice"/>beschr&auml;nkt:
	      </td>
	      <td>
	        <input type="text" name="resolution_value" onfocus="form.resolution_choice[1].checked=true"/>
	      </td>
	    </tr>
	  </table>
	</form>
</fieldset>
