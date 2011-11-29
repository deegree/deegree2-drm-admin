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

    controllers.push( new ConstraintController( "bbox", bbox_getConstraint, bbox_setConstraint, bbox_maximizeConstraint ) );
  
    function bbox_getConstraint () {
    
        if ( document.bbox_form.bbox_choice[0].checked ) {
            constraint = null;
        } else if ( document.bbox_form.bbox_choice[1].checked ) {
            constraint = "definedBbox";
        } else {
	        constraint = new Array();
	        var checkedNumber = checkNumber( document.bbox_form.bbox_minx.value );
	        if ( checkedNumber != null ) {
	            constraint[0] = checkedNumber;
	        } else {
	            return null;
	        }
            checkedNumber = checkNumber( document.bbox_form.bbox_miny.value );
            if ( checkedNumber != null ) {
                constraint[1] = checkedNumber;
            } else {
                return null;
            }
            checkedNumber = checkNumber( document.bbox_form.bbox_maxx.value );
            if ( checkedNumber != null ) {
                constraint[2] = checkedNumber;
            } else {
                return null;
            }
            checkedNumber = checkNumber( document.bbox_form.bbox_maxy.value );
            if (checkedNumber != null) {
                constraint[3] = checkedNumber;
            } else {
                return null;
            }           
            if ( constraint[0] >= constraint[2] ) {
                alert( "minx muss kleiner als maxx sein." );
                return null;
            }
            if (constraint[1] >= constraint[3]) {
                alert( "miny muss kleiner als maxy sein." );
                return null;
            }
        }
        return constraint;
    }

    function bbox_setConstraint( constraint ) {

        if ( constraint == null ) {
            document.bbox_form.bbox_choice[0].checked = true;
            document.bbox_form.bbox_minx.value = "";
            document.bbox_form.bbox_miny.value = "";
            document.bbox_form.bbox_maxx.value = "";
            document.bbox_form.bbox_maxy.value = "";        
        } else if ( constraint == "definedBbox" ){
            document.bbox_form.bbox_choice[1].checked = true;
            document.bbox_form.bbox_minx.value = "";
            document.bbox_form.bbox_miny.value = "";
            document.bbox_form.bbox_maxx.value = "";
            document.bbox_form.bbox_maxy.value = "";        
        } else {
            document.bbox_form.bbox_choice[2].checked = true;
            document.bbox_form.bbox_minx.value = constraint[0];
            document.bbox_form.bbox_miny.value = constraint[1];
            document.bbox_form.bbox_maxx.value = constraint[2];
            document.bbox_form.bbox_maxy.value = constraint[3];            
        }
    }

    function bbox_maximizeConstraint() {
        bbox_setConstraint("definedBbox");
    }
    
    function bbox_clearFields() {
        document.bbox_form.bbox_minx.value = "";
        document.bbox_form.bbox_miny.value = "";
        document.bbox_form.bbox_maxx.value = "";
        document.bbox_form.bbox_maxy.value = "";
    }
    
    /*
    * sets values for predefined bbox
    */
    function setBox() {
	    document.bbox_form.bbox_minx.value = "7";
        document.bbox_form.bbox_miny.value = "51";
        document.bbox_form.bbox_maxx.value = "8";
        document.bbox_form.bbox_maxy.value = "51.5";
        document.bbox_form.bbox_choice[1].checked = true;
    }

</script>
<fieldset>
  <legend>
    <b>Bounding Box</b>
  </legend>
  <form class="control" action="javascript:assignConstraints()" name="bbox_form">
	  <table border="0">
	  	<tr>
	      <td>
	        <input type="button" onclick="setBox()" value="predefined bbox"></input>
	      </td>
	    </tr>
	    <tr>
	      <td>
	        <input type="radio" name="bbox_choice" checked="checked" onclick="bbox_clearFields()"/>unbeschr&auml;nkt
	      </td>
	    </tr>
	    <tr>
	      <td>
	        <input type="radio" name="bbox_choice" onclick="bbox_clearFields()"/>predefined bbox
	      </td>
	    </tr>
	    <tr>
	      <td>
	        <input type="radio" name="bbox_choice"/>folgende:</td>
	    </tr>
	    <tr>
	      <td>
	        <table border="0">
	          <tr>
	            <td colspan="2" align="center">maxy:<input type="text" size="7" name="bbox_maxy" onfocus="bbox_form.bbox_choice[2].checked=true"/>
	            </td>
	          </tr>
	          <tr>
	            <td align="left">minx:<input type="text" size="7" name="bbox_minx" onfocus="bbox_form.bbox_choice[2].checked=true"/>
	            </td>
	            <td align="right">maxx:<input type="text" size="7" name="bbox_maxx" onfocus="bbox_form.bbox_choice[2].checked=true"/>
	            </td>
	          </tr>
	          <tr>
	            <td colspan="2" align="center">miny:<input type="text" size="7" name="bbox_miny" onfocus="bbox_form.bbox_choice[2].checked=true"/>
	            </td>
	          </tr>
	        </table>
	      </td>
	    </tr>
	  </table>
  </form>
</fieldset>