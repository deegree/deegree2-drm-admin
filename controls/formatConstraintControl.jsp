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
    controllers.push( new ConstraintController( "format", format_getConstraint, format_setConstraint, format_maximizeConstraint ) );
  
    function format_getConstraint() {
        if ( document.format_form.format_choice[0].checked ) {
            constraint = null;
        } else {
            constraint = new Array ();
            constraint.isAssociative = true;
            if ( document.format_form.formats[0].checked ) {
                constraint["image/jpeg"] = true;
            }
            if ( document.format_form.formats[1].checked ) {
                constraint["image/png"] = true;
            }
            if ( document.format_form.formats[2].checked ) {
                constraint["image/gif"] = true;
            }                
        }
        return constraint;
    }

    function format_setConstraint( constraint ) {
        if ( constraint == null ) {
            document.format_form.format_choice[0].checked = true;
            document.format_form.formats[0].checked = false;
            document.format_form.formats[1].checked = false;
            document.format_form.formats[2].checked = false;                                                            
        } else {
            document.format_form.format_choice[1].checked = true;
            if ( constraint ["image/jpeg"] ) {
                document.format_form.formats[0].checked = true;
            } else {
                document.format_form.formats[0].checked = false;
            }
            if ( constraint ["image/png"] ) {
                document.format_form.formats[1].checked = true;
            } else {
                document.format_form.formats[1].checked = false;
            }
            if ( constraint ["image/gif"] ) {
                document.format_form.formats[2].checked = true;
            } else {
                document.format_form.formats[2].checked = false;
            }
        }
    }

    function format_maximizeConstraint() {    
        var constraint = new Array();
        constraint["image/gif"] = true;
        format_setConstraint( constraint );
    }
    
    function format_validate() {
        if ( document.format_form.format_choice[0].checked ) {
            document.format_form.formats[0].checked=false;
            document.format_form.formats[1].checked=false;
            document.format_form.formats[2].checked=false;                        
        }
    }        
//-->
</script>
<fieldset>
  <legend>
    <b>Formate</b>
  </legend>
  <form class="control" action="javascript:assignConstraints()" name="format_form">
	  <table border="0">
	    <tr>
	      <td>
	        <input type="radio" name="format_choice" checked="checked" onclick="format_validate()"/>unbeschr&auml;nkt
	      </td>
	    </tr>
	    <tr>
	      <td>
	        <input type="radio" name="format_choice"/>folgende:
	      </td>
	    </tr>
	    <tr>
	      <td>&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="formats" onclick="format_form.format_choice[1].checked=true"/>image/jpeg</td>
	    </tr>
	    <tr>
	      <td>&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="formats" onclick="format_form.format_choice[1].checked=true"/>image/png</td>
	    </tr>
	    <tr>
	      <td>&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="formats" onclick="format_form.format_choice[1].checked=true"/>image/gif</td>
	    </tr>
	  </table>
  </form>
</fieldset>
