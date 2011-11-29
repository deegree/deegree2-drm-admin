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
<script>

controllers.push( new ConstraintController( "layers", layers_getConstraint, layers_setConstraint ) );

	function layers_getConstraint() {
	
	  var layerOptions = document.templateLayerSelectForm.templateLayersSelected.options;	  
	  var layerArray = new Array();
	  var i = 0;
	  for( i = 0; i < layerOptions.length; i++ ) {
	  		var name = layerOptions[i].text;	
	  		layerArray.push( new SecuredObject( i, name, true, new Array() ) );	  			
	  }
	  layerOptions = document.templateLayerSelectForm.templateLayersAvailable.options;
	  i = 0;
	  for( i = 0; i < layerOptions.length; i++ ) {
	  		var name = layerOptions[i].text;	 
	  		layerArray.push( new SecuredObject( i, name, false, new Array() ) );	  			
	  }	  	  
	  return layerArray;
	}

	function layers_setConstraint( constraint ) {		
	}	
	

     /**
     * Sets the access rights for the currently selected layers.
     * value: the direction of the arrow pressed (selected <-> available)
     */
    function setTemplateLayerRights( value ) {

		var templateSelected = getSelectedOptions( document.templateSelectForm.templatesSelected.options );
        if ( templateSelected.length == 0 ) {
            alert( "W\u00E4hlen Sie bitte zuerst einen Template aus." );
            return;
        }
        var template;
        if ( templateSelected.length == 1 ){
        	var it = templateSelected[0].value;
	    	if ( it != document.templateSelectForm.templatesSelected.options.selectedIndex ) {
				it = document.templateSelectForm.templatesSelected.options.selectedIndex;
			}
			template = templates[it];
		}
		              
        var layerNames = new Array();
        if ( value ) {
            var selected = getSelectedOptions( document.templateLayerSelectForm.templateLayersAvailable.options );
	        var i = 0; 
            for ( i = 0; i < selected.length; i++ ) {               
            	var name = document.templateLayerSelectForm.templateLayersAvailable.options[selected[i].value].text;
				layerNames[i] = name;
			}    
        } else {
            var selected = getSelectedOptions( document.templateLayerSelectForm.templateLayersSelected.options );            
            var i = 0; 
            for ( i = 0; i < selected.length; i++ ) {       
            	var name = document.templateLayerSelectForm.templateLayersSelected.options[selected[i].value].text;
				layerNames[i] = name;
			} 			
        }
        
        var selectedLayers = getSelectedLayers();
    	var availableLayers = getAvailableLayers();
    	    	
        var i = 0;
        for ( i = 0; i < layerNames.length; i++ ) {
        	 var obj = getPdfLayer( layerNames[i] );
             if ( value ) {    		
	    		selectedLayers.push( new SecuredObject( obj.id, obj.name, value, new Array() ) ); 
		    	availableLayers = removeLayers( availableLayers, obj );
    		} else {
	   			availableLayers.push( new SecuredObject( obj.id, obj.name, value, new Array() ) );
	    		selectedLayers = removeLayers( selectedLayers, obj );	 	
	    	}    	  
        }          
        
        availableLayers.sort( namesort );
        selectedLayers.sort( namesort );
        refreshAvailableListBox( document.templateLayerSelectForm.templateLayersAvailable, availableLayers );
        refreshSelectedListBox( document.templateLayerSelectForm.templateLayersSelected, selectedLayers );
    }
    
     function removeLayers( array, obj ) {    	
    
    	var choosenLayer = new Array();
    	var i = 0;
    	for( i = 0; i < array.length; i++ ) {    		
			if( array[i].name != obj.name ) {
				choosenLayer.push( new SecuredObject( array[i].id, array[i].name, array[i].isAccessible, array[i].constraints ) );
			}
    	}
    	return choosenLayer;
    }
    
    function getSelectedLayers() {
    	var selectedLayers = new Array();    	
    	var j = 0;    	
   		for ( j = 0; j < document.templateLayerSelectForm.templateLayersSelected.options.length; j++ ){
   	   		var tmp =  document.templateLayerSelectForm.templateLayersSelected.options[j].text ;		
    		var obj = getPdfLayer( tmp );
	    	selectedLayers.push(new SecuredObject( obj.id, obj.name, true, obj.constraints ) );		    
    	}    		
    	return selectedLayers;
    }
    
        
    function getAvailableLayers() {
    	var availableLayers = new Array();
		var j = 0;
    	for( j = 0; j < document.templateLayerSelectForm.templateLayersAvailable.options.length; j++ ){
	    	var tmp =  document.templateLayerSelectForm.templateLayersAvailable.options[j].text ;		    	
    		var obj = getPdfLayer( tmp );	    		
  			availableLayers.push(new SecuredObject( obj.id, obj.name, false, obj.constraints ) );	
    	}    	    		    	
    	return availableLayers;
    }	
    
    
    function getPdfLayer( name )  {    	
    	var layer;
    	var i = 0;
    	for ( i = 0; i < pdfLayers.length; i++ ) {    		
    		if ( pdfLayers[i].name == name ) {
    			layer = pdfLayers[i];
    			break;
    		}
    	}
    	return layer;
    }
	
</script>
<fieldset>
    <legend>
        <b>Layers</b>
    </legend>
    <form class="control" action="javascript:assignTemplateConstraints()" name="templateLayerSelectForm">
        <table border="0">
        	<tr>
        		<td valign="top" colspan="3">&nbsp;</td>
        	<tr>
        		<td class="caption">zugreifbare Layer</td>
        		<td>&nbsp;</td>
        		<td class="caption">gesperrte Layer</td>
        	</tr>
        	<tr>
        		<td>
                    <select class="largeselect" name="templateLayersSelected" size="10" multiple="multiple">
                        <option>Formularinitialisierung...</option>
                    </select>
                </td>
        		<td valign="middle" align="center">
                    <a href="javascript:setTemplateLayerRights (false)"><img src="bilder/admin_bt_remove.gif" alt="-" border="0" /></a><br />
        		    <a href="javascript:setTemplateLayerRights (true)"><img src="bilder/admin_bt_add.gif" alt="+" border="0" /></a>
                </td>
        		<td>
                    <select class="largeselect" name="templateLayersAvailable" size="10" multiple="multiple">
                        <option>Formularinitialisierung...</option>
                    </select>
                </td>
        	</tr>
        </table>
    </form>
</fieldset>
