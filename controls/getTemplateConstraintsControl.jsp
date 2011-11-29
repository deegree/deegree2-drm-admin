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
<%@ page contentType="text/html"%>
<script language="JavaScript1.2" type="text/javascript">
	
	//var controllers = new Array ();
    
    function ConstraintController( constraintName, getConstraint, setConstraint ) {    
        this.constraintName = constraintName;
        this.getConstraint = getConstraint;
        this.setConstraint = setConstraint;        
    }
  	
    function clearTemplateConstraints() {
    
        selected = getSelectedOptions( document.templateSelectForm.templatesSelected.options );
        if ( selected.length == 0 ) {
            alert( "W\u00E4hlen Sie bitte zuerst einen Template aus." );
            return;
        }    
       
       clearTemplateControls( selected );        
    }

   function clearTemplateControls( selected ) {
 		
 		if( selected.length == 1 ){
        	var item = selected[0].value;
	    	if( item != document.templateSelectForm.templatesSelected.options.selectedIndex ) {
				item = document.templateSelectForm.templatesSelected.options.selectedIndex;
			}
			var name = document.templateSelectForm.templatesSelected.options[item].text;			
			var template = getTemplate( name )
			
			var layerArray = template.constraints["layers"];
			var i = 0;
			for( i = 0; i < layerArray.length; i++ ) {
				layerArray[i].isAccessible = false;
			}
			
			var scalesArray = template.constraints["scales"];
			i = 0;
			for( i = 0; i < scalesArray.length; i++ ) {
				scalesArray[i].isAccessible = false;
			}	
		}
		templates.sort( namesort );
		refreshAvailableListBox( document.templateSelectForm.templatesAvailable, templates );
        refreshSelectedListBox( document.templateSelectForm.templatesSelected, templates );
    }
    
    function assignTemplateConstraints() {
    
        selected = getSelectedOptions( document.templateSelectForm.templatesSelected.options );
        if ( selected.length == 0 ) {
            alert( "W\u00E4hlen Sie bitte zuerst einen Template aus." );
            return;
        }
           	
        if( selected.length == 1 ){
        	var item = selected[0].value;
	    	if( item != document.templateSelectForm.templatesSelected.options.selectedIndex ) {
				item = document.templateSelectForm.templatesSelected.options.selectedIndex;
			}
			var name = document.templateSelectForm.templatesSelected.options[item].text;			
			template = getTemplate( name );
			constraints = new Array();
			var i = 0;			
	 		for ( i = 0; i < controllers.length; i++ ) {
               constraints [controllers[i].constraintName] = controllers[i].getConstraint ();
	        }
        	template.constraints["layers"] = constraints["layers"];
            template.constraints["scales"] = constraints["scales"];
		}
		
		templates.sort( namesort );
		refreshAvailableListBox( document.templateSelectForm.templatesAvailable, templates );
        refreshSelectedListBox( document.templateSelectForm.templatesSelected, templates );
    }

	function displayTemplateConstraints() {	
	
		selected = getSelectedOptions(document.templateSelectForm.templatesSelected.options );
        
	    if ( selected.length == 1 ) {		    
    		if( selected[0].value != document.templateSelectForm.templatesSelected.options.selectedIndex ) {
				selected[0].value = document.templateSelectForm.templatesSelected.options.selectedIndex;
			}
			var name = document.templateSelectForm.templatesSelected.options[selected[0].value].text;
			template = getTemplate( name );			
			
	        if ( template.constraints != null ) {    
			    var tmp_layers = template.constraints[ "layers" ];	
			    if( tmp_layers.length == 0 ) {
			    	tmp_layers = new Array( pdfLayers.length );
			    	var i = 0;
			    	for( i = 0; i < pdfLayers.length; i++ ) {
			    		tmp_layers[i] = pdfLayers[i];
			    		tmp_layers[i].isAccessible = false;
			    	}
			    }
			    var tmp_scales = template.constraints[ "scales" ]; 					
			    if( tmp_scales.length == 0 ) {
			    	tmp_scales = new Array( templateScales.length );
			    	var j = 0;
			    	for( j = 0; j < templateScales.length; j++ ) {
			    		tmp_scales[j] = templateScales[j];
			    		tmp_scales[j].isAccessible = false;
			    	}
			    }		    
			    showConstraints( tmp_layers, "layers" );			    
			    showConstraints( tmp_scales, "scales" );	    
	        }
    	}     	     
	}
	
	function getTemplate( name ) {		
		var i = 0;
		for( i = 0; i < templates.length; i++ ) {
			if( templates[i].name == name ) {
				return templates[i];
			}
		}
	}
	
	function showConstraints( constraints, type ) {		
		
		var selectedConstraints = new Array(); 
		var availableConstraints = new Array(); 	
		
		if( type == "layers" ) {
			selectedConstraints = getSelectedLayers();
			availableConstraints = getAvailableLayers();			
		}
		
		if( type == "scales" ) {			
			selectedConstraints = getSelectedScales();
			availableConstraints = getAvailableScales();
		}
		if( constraints.length > 0 ) {		
			var c = 0;
			for ( c = 0; c < selectedConstraints.length; c++ ) {
				var selConst = selectedConstraints[c];
				if ( !( isPresent( constraints, selConst.name ) ) ) {
					var tmp = removeFromConstraints( selectedConstraints, selConst.name );
					availableConstraints.push( new SecuredObject( selConst.id, selConst.name, false, selConst.constraints ) );
					selectedConstraints = tmp; 		
					c = -1;
				} 
			}	
			var i = 0;
			for( i = 0; i < constraints.length; i++ ) {			
				var constraint = constraints[i];				
				if( constraint.isAccessible ) {		
					if ( !( isPresent( selectedConstraints, constraint.name ) ) ) {																
						selectedConstraints.push( new SecuredObject( constraint.id, constraint.name, constraint.isAccessible, new Array() ) );						
						if ( isPresent( availableConstraints, constraint.name ) ) {
							var tmp = removeFromConstraints( availableConstraints, constraint.name ) ;
							availableConstraints = tmp;
						}
					}												
				}  else {
					if ( !( isPresent(availableConstraints, constraint.name ) ) ) {
						availableConstraints.push( new SecuredObject( constraint.id, constraint.name, constraint.isAccessible, new Array() ));
						if ( isPresent( selectedConstraints, constraint.name ) ) {
							var tmp = removeFromConstraints( selectedConstraints, constraint.name ) ;
							selectedConstraints = tmp;							
						}
					}										
				}				
			}
							
		} else {
			var j = 0;
			for ( j = 0; j < selectedConstraints.length; j++ ) {
				var selectedConstraint = selectedConstraints[j];
				if ( !( isPresent( availableConstraints, selectedConstraint.name ) ) ) {
					var obj = new SecuredObject( selectedConstraint.id, selectedConstraint.name, false, selectedConstraint.constraints );
					availableConstraints.push( obj );							
					selectedConstraints[j].isAccessible = false;
				}									
			}				
		}		
	

		if( type == "layers" ) {
			availableConstraints.sort( namesort );
			selectedConstraints.sort( namesort );			
			refreshAvailableListBox( document.templateLayerSelectForm.templateLayersAvailable, availableConstraints );            
    		refreshSelectedListBox( document.templateLayerSelectForm.templateLayersSelected, selectedConstraints );             
		} else if ( type == "scales" ) {
			availableConstraints.sort( numbersort );
			selectedConstraints.sort( numbersort );
			refreshAvailableListBox( document.scalesSelectForm.scalesAvailable, availableConstraints );    
			refreshSelectedListBox( document.scalesSelectForm.scalesSelected, selectedConstraints );	        
		}
	}   
	
	function removeFromConstraints( array, name ) {
		var tmp = new Array();
		var count = 0;
		for( count = 0; count < array.length; count++ ) {
			if( !(array[count].name == name ) ) {
				tmp.push( new SecuredObject( array[count].id, array[count].name, array[count].isAccessible, array[count].constraints ) );
			}
		}
		return tmp;
	}
	
	function isPresent( constraints, name ) {		
		var k = 0;
		for ( k = 0; k < constraints.length; k++ ) {
			if ( constraints[k].name == name ) {
				return true;
			}
		}
		return false;
	}
	       
</script>

<table border="0" cellpadding="5" cellspacing="10">
	<tr>
		<td colspan="3" class="caption">Zugriffsbeschr&auml;nkungen des gew&auml;hlten Templates</td>
	</tr>
	<tr>
		<td valign="top">
		<table border="0" width="300">
			<tr>
				<td><jsp:include page="layersConstraintControl.jsp" flush="true" />
				</td>
			</tr>
			<tr>
				<td><jsp:include page="scalesConstraintControl.jsp" flush="true" />
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td colspan="3">
		<table border="0" cellspacing="10" cellpadding="2">
			<tr>
				<td class="menu"><a href="javascript:clearTemplateConstraints ()">keine	Beschr&auml;nkungen</a></td>
				<td class="menu"><a href="javascript:assignTemplateConstraints()">Beschr&auml;nkungenn zuweisen</a></td>
			</tr>
		</table>
		</td>
	</tr>
</table>
