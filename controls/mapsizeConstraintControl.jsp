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
    controllers.push( new ConstraintController( "width", width_getConstraint, width_setConstraint, width_maximizeConstraint ) );
    controllers.push( new ConstraintController( "height", height_getConstraint, height_setConstraint, height_maximizeConstraint ) );

    function width_getConstraint() {
        if ( document.mapsize_form.width_choice[0].checked ) {
            return null;
        }
        return checkInteger( document.mapsize_form.width_value.value );
    }

    function width_setConstraint( constraint ) {
        if ( constraint == null ) {
            document.mapsize_form.width_choice[0].checked = true;
            document.mapsize_form.width_value.value = "";
        } else {
            document.mapsize_form.width_choice[1].checked = true;
            document.mapsize_form.width_value.value = constraint;
        }
    }

    function width_maximizeConstraint() {
        width_setConstraint(550);
    }

    function height_getConstraint() {
        if ( document.mapsize_form.height_choice[0].checked ) {
            return null;
        }
        return checkInteger( document.mapsize_form.height_value.value );
    }

    function height_setConstraint( constraint ) {
        if ( constraint == null ) {
            document.mapsize_form.height_choice[0].checked = true;
            document.mapsize_form.height_value.value = "";
        } else {
            document.mapsize_form.height_choice[1].checked = true;
            document.mapsize_form.height_value.value = constraint;
        }
    }

    function height_maximizeConstraint() {
        height_setConstraint(550);
    }
//-->
</script>
<fieldset>
  <legend>
    <b>maximale Kartengr&ouml;&szlig;e (Pixel)</b>
  </legend>
  <form class="control" action="javascript:assignConstraints ()" name="mapsize_form">
          <table border="0">
            <tr>
              <td colspan="2">
                <input type="radio" name="width_choice" checked="checked" onclick="mapsize_form.width_value.value=''"/>unbeschr&auml;nkte Breite
              </td>
            </tr>
            <tr>
              <td>
                <input type="radio" name="width_choice" />Breite:
              </td>
              <td>
                <input type="text" name="width_value" size="5" onfocus="form.width_choice[1].checked=true"/>
              </td>
            </tr>
            <tr>
              <td colspan="2">
                <input type="radio" name="height_choice" checked="checked" onclick="mapsize_form.height_value.value=''"/>unbeschr&auml;nkte H&ouml;he
              </td>
            </tr>
            <tr>
              <td>
                <input type="radio" name="height_choice" />H&ouml;he:
              </td>
              <td>
                <input type="text" name="height_value" size="5" onfocus="form.height_choice[1].checked=true" />
              </td>
            </tr>
          </table>
  </form>
</fieldset>
