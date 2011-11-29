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
    controllers.push( new ConstraintController( "exceptions", exceptions_getConstraint, exceptions_setConstraint, exceptions_maximizeConstraint ) );
  
    function exceptions_getConstraint() {
        if ( document.exceptions_form.exceptions_choice[0].checked ) {
            return null;
        }
        constraint = new Array();
        constraint.isAssociative = true;        
        constraint["application/vnd.ogc.se_xml"] = true;
        if ( document.exceptions_form.exceptions[1].checked ) {
            constraint["application/vnd.ogc.se_inimage"] = true;
        }
        if ( document.exceptions_form.exceptions [2].checked ) {
            constraint["application/vnd.ogc.se_blank"] = true;
        }
        return constraint;
    }

    function exceptions_setConstraint( constraint ) {
		    if ( constraint == null ) {
    		    document.exceptions_form.exceptions_choice[0].checked = true; 
		        document.exceptions_form.exceptions[0].checked = false;
		        document.exceptions_form.exceptions[1].checked = false;
		        document.exceptions_form.exceptions[2].checked = false;                                                            
		    } else {
            document.exceptions_form.exceptions_choice[1].checked = true; 
		        if ( constraint["application/vnd.ogc.se_xml"]) {
		            document.exceptions_form.exceptions[0].checked = true;
		        } else {
                document.exceptions_form.exceptions[0].checked = false;
		        }
		        if ( constraint["application/vnd.ogc.se_inimage"] ) {
		            document.exceptions_form.exceptions[1].checked = true;
		        } else {
                document.exceptions_form.exceptions[1].checked = false;
		        }
		        if ( constraint ["application/vnd.ogc.se_blank"] ) {
		            document.exceptions_form.exceptions[2].checked = true;
		        } else {
                    document.exceptions_form.exceptions[2].checked = false;
		        }
		    }
    }

    function exceptions_maximizeConstraint() {
        var constraint = new Array();
        constraint["application/vnd.ogc.se_xml"] = true;
        exceptions_setConstraint( constraint );
    }
    
    function exceptions_validate() {
        document.exceptions_form.exceptions[0].checked=false;
        document.exceptions_form.exceptions[1].checked=false;
        document.exceptions_form.exceptions[2].checked=false;                        
    }

    function exceptions_validate2() {
        document.exceptions_form.exceptions_choice[1].checked = true;
        document.exceptions_form.exceptions[0].checked = true;
    }    
//-->
</script>
<fieldset>
  <legend>
    <b>Exception-Formate</b>
  </legend>
  <form class="control" action="javascript:assignConstraints()" name="exceptions_form">
	  <table border="0">
      <tr>
        <td>
          <input type="radio" name="exceptions_choice" checked="checked" onclick="exceptions_validate()"/>unbeschr&auml;nkt
        </td>
      </tr>
      <tr>
        <td>
          <input type="radio" name="exceptions_choice" onclick="exceptions_validate2()"/>folgende:
        </td>
      </tr>	  
	    <tr>
	      <td>
	        &nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="exceptions" onclick="exceptions_validate2()"/>application/vnd.ogc.se_xml(fix)	        
	      </td>
	    </tr>
	    <tr>
	      <td>
	        &nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="exceptions" onclick="exceptions_validate2()"/>application/vnd.ogc.se_inimage
	      </td>
	    </tr>
	    <tr>
	      <td>
	        &nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="exceptions" onclick="exceptions_validate2()"/>application/vnd.ogc.se_blank
	      </td>
	    </tr>
	  </table>
  </form>
</fieldset>
