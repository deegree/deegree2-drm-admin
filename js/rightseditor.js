//$HeadURL$
/*----------------------------------------------------------------------------
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
----------------------------------------------------------------------------*/
var layers = []
var featureTypes = []
var featureConstraints = []

/**
 * Constructs a new SecuredObject, consisting of:
 *
 * - id:          unique identifier
 * - name:        display name
 * - isAccessible right to be accessed (boolean)
 * - constraints  key/value-pairs specific to the certain SecuredObject type
 *                (may be null)
 */
function SecuredObject( id, name, isAccessible, constraints ) {
  this.id = id
  this.name = name
  this.isAccessible = isAccessible
  this.constraints = constraints
}


function toRPCParam( constraints ) {
  var rpc = "<value><struct>"

  for ( var constraint in constraints ) {
    if ( constraints[constraint] != null ) {
      rpc += "<member><name>" + constraint + "</name><value>"
      if ( typeof( constraints[constraint] ) == "boolean" ||
           typeof( constraints[constraint] ) == "string" ||
           typeof( constraints[constraint] ) == "number" ) {
             // literal
             rpc += "<string><![CDATA[" + constraints[constraint] + "]]></string>"
           } else if (constraints[constraint].isAssociative) {
             // associative array
             rpc += "<array><data>"
             for ( var value in constraints[constraint] ) {
               if ( value != "isAssociative" ) {
                 rpc += "<value><string><![CDATA[" + value + "]]></string></value>"
               }
             }
             rpc += "</data></array>"
           } else {
             // normal array
             rpc += "<array><data>"
             for (var i = 0; i < constraints[constraint].length; i++) {
               rpc += "<value><string><![CDATA[" + constraints[constraint][i] + "]]></string></value>"
             }
             rpc += "</data></array>"
           }
      rpc += "</value></member>"
    }
  }
  rpc += "</struct></value>"
  return rpc
}

/**
 * Initializes the four listboxes with the data from the layers /
 * featureTypes arrays.
 */
function initForms() {
	if ( document.layerSelectForm ) {
		refreshAvailableListBox( document.layerSelectForm.layersAvailable, layers )
  		refreshSelectedListBox( document.layerSelectForm.layersSelected, layers )
	}
	if ( document.featureTypeSelectForm ) {
		refreshAvailableListBox( document.featureTypeSelectForm.featureTypesAvailable, featureTypes )
  		refreshSelectedListBox( document.featureTypeSelectForm.featureTypesSelected, featureTypes )
	}
}

/**
 * Fills the given 'available'-listbox with all SecuredObjects from the given
 * SecuredObjects array that are not enabled (selected=false).
 */
function refreshAvailableListBox( selectedForm, securedObjects ) {
  var oldCount = selectedForm.length
  for ( i = oldCount - 1; i >= 0 ; i-- ) {
    selectedForm.options[i] = null
  }
  for ( i = 0; i < securedObjects.length; i++ ) {
    if ( !securedObjects[i].isAccessible ) {
      selectedForm.options[selectedForm.length] = new Option( securedObjects[i].name, i )
    }
  }
}

/**
 * Fills the given 'selected'-listbox with all SecuredObjects from the given
 * SecuredObjects array that are enabled (selected=true).
 */
function refreshSelectedListBox( selectedForm, securedObjects ) {
  var oldCount = selectedForm.length
  for ( i = oldCount - 1; i >= 0; i-- ) {
    selectedForm.options[i] = null
  }
  for ( i = 0; i < securedObjects.length; i++ ) {
    if ( securedObjects[i].isAccessible ) {
      selectedForm.options[selectedForm.length] = new Option( securedObjects[i].name, i )
    }
  }
}

/**
 * Sets the access rights for the currently selected layers.
 */
function setGetMapRights( value ) {
  var selected;
  if ( value ) {
    selected = getSelectedOptions( document.layerSelectForm.layersAvailable.options )
  } else {
    selected = getSelectedOptions( document.layerSelectForm.layersSelected.options )
  }
  for ( i = 0; i < selected.length; i++ ) {
    layers[selected[i].value].isAccessible = value
  }
  refreshAvailableListBox( document.layerSelectForm.layersAvailable, layers )
  refreshSelectedListBox( document.layerSelectForm.layersSelected, layers )
  clearControls()
}

/**
 * Sets the access right for the currently selected FeatureTypes.
 */
function setFeatureTypeRights( value ) {
  var selected;
  if ( value ) {
    selected = getSelectedOptions( document.featureTypeSelectForm.featureTypesAvailable.options )
  } else {
    selected = getSelectedOptions( document.featureTypeSelectForm.featureTypesSelected.options )
  }
  for ( i = 0; i < selected.length; i++ ) {
    featureTypes[selected[i].value].isAccessible = value
  }
  refreshAvailableListBox( document.featureTypeSelectForm.featureTypesAvailable, featureTypes )
  refreshSelectedListBox( document.featureTypeSelectForm.featureTypesSelected, featureTypes )
}

/**
 * Sets the modification rights (insert / update / delete) for the currently selected
 * FeatureType according to the state of the featureTypeModifications-checkboxes.
 */
function setFeatureTypeModificationRights() {
  var selected = getSelectedOptions( document.featureTypeSelectForm.featureTypesSelected.options )
  if ( selected.length == 0 ) {
    alert( "W\u00E4hlen Sie bitte zuerst einen FeatureType aus." )
    document.featureTypeSelectForm.featureTypeModifications[0].checked = false
    document.featureTypeSelectForm.featureTypeModifications[1].checked = false
    document.featureTypeSelectForm.featureTypeModifications[2].checked = false
    return
  }

  var txt = selected[0].text
  for ( var i = 0; i < featureTypes.length; i++ ) {
    if ( txt == featureTypes[i].name ) {
      featureTypes[i].constraints["DELETE"] =
        document.featureTypeSelectForm.featureTypeModifications[0].checked
      featureTypes[i].constraints["INSERT"] =
        document.featureTypeSelectForm.featureTypeModifications[1].checked
      featureTypes[i].constraints["UPDATE"] =
        document.featureTypeSelectForm.featureTypeModifications[2].checked
      break;
    }
  }
}

function displayModificationRights() {
  var selected = getSelectedOptions( document.featureTypeSelectForm.featureTypesSelected.options )

  var txt = selected[0].text
  for ( var i = 0; i < featureTypes.length; i++ ) {
    if ( txt == featureTypes[i].name ) {
      document.featureTypeSelectForm.featureTypeModifications[0].checked =
        featureTypes[i].constraints["DELETE"]
      document.featureTypeSelectForm.featureTypeModifications[1].checked =
        featureTypes[i].constraints["INSERT"]
      document.featureTypeSelectForm.featureTypeModifications[2].checked =
        featureTypes[i].constraints["UPDATE"]
    }
  }
}
