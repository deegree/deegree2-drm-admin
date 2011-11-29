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

controllers.push( new ConstraintController( "scales", scales_getConstraint, scales_setConstraint ) );

	function scales_getConstraint() {
	 	var scales = new Array();
		var scaleOptions = document.scalesSelectForm.scalesSelected.options;
		var i = 0;
		for ( i = 0; i < scaleOptions.length; i++ ){
			var scale = scaleOptions[i].text;
			var obj = new SecuredObject( i, scale, true, new Array() );
			scales.push( obj );
		}	
		scaleOptions = document.scalesSelectForm.scalesAvailable.options;
		var j = 0;
		for ( j = 0; j < scaleOptions.length; j++){
			var scale = scaleOptions[j].text;
			var obj = new SecuredObject( j, scale, false, new Array() );
			scales.push( obj );
		}
  	    return scales;
	}

	function scales_setConstraint( constraint ) {		
	}	
		
	function addNewScale() {
	    var templateSelected = getSelectedOptions( document.templateSelectForm.templatesSelected.options );
        if ( templateSelected.length == 0 ) {
            alert( "W\u00E4hlen Sie bitte zuerst einen Template aus." );
            return;
        }
        
		var scale = validateValue();	
		var scales = document.scalesSelectForm.scalesSelected.options;	   
		var i = 0;
        for ( i = 0; i < scales.length; i++ ) {        	
            if ( scale == scales[i].text ) {
                alert( "Please enter a unique scale. The scale '" + scale + "' exists.!" );
                return;
            }
        }
        scales = document.scalesSelectForm.scalesAvailable.options;	   
        i = 0;
        for ( i = 0; i < scales.length; i++ ) {
        	if ( scale == scales[i].text ) {
                alert( "Please enter a unique scale. The scale '" + scale + "' is already available. Please use the buttons to move the value you require from the right hand list box.!" );
                return;
            }
        }
        var scaleIdx = scales.length;
        addOption( document.scalesSelectForm.scalesSelected, scale, scale );
        document.scalesSelectForm.newScale.value = "";
	}
	
	function addOption( selectbox,text,value ) {
		var optn = document.createElement( "OPTION" );
		optn.text = text;
		optn.value = value;
		selectbox.options.add( optn );
	}
	
	function validateValue() {
		var checkedNumber = checkNumber( document.scalesSelectForm.newScale.value );
		if ( checkedNumber != null ) {
	    	var value = checkInteger(  checkedNumber );
	    	if ( value != null ) {
	    		return value;
	    	}
	    }      
	}

	function deleteScale() {
		selectbox = document.scalesSelectForm.scalesSelected;
		var i;
		for ( i = selectbox.options.length-1; i >= 0; i-- )	{
			if ( selectbox.options[i].selected ) {
				selectbox.remove(i);
			}
		}
	}
	
	/**
     * Sets the access rights for the currently selected scales.
     */
    function setTemplateScaleRights( status ) {
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
				        
        var scales = new Array();
        if ( status ) {
            var selected = getSelectedOptions( document.scalesSelectForm.scalesAvailable.options );	        
            var i = 0; 
            for ( i = 0; i < selected.length; i++ ) {               
				scales[i] = document.scalesSelectForm.scalesAvailable.options[selected[i].value].text;
			}            
        } else {
            var selected = getSelectedOptions( document.scalesSelectForm.scalesSelected.options );
            var i = 0; 
            for ( i = 0; i < selected.length; i++ ) {               
				scales[i] = document.scalesSelectForm.scalesSelected.options[selected[i].value].text;
			}         
        }        
        
        var selectedScales = getSelectedScales();
    	var availableScales = getAvailableScales();
        
        var i = 0;
        for ( i = 0; i < scales.length; i++ ) {
        	 var value = scales[i];
        	 if ( status ) {
        	 	selectedScales.push( new SecuredObject( i, value, status, new Array() ) ); 
	    	    availableScales = removeScale( availableScales, value );
        	 } else {
   	 	   		availableScales.push( new SecuredObject( i, value , status, new Array() ) );
		    	selectedScales = removeScale( selectedScales, value );	    	
        	 }    
        }        
        
        availableScales.sort( numbersort );
    	selectedScales.sort( numbersort );
    	refreshAvailableListBox( document.scalesSelectForm.scalesAvailable, availableScales );    
		refreshSelectedListBox( document.scalesSelectForm.scalesSelected, selectedScales );	           
    }
   
    function removeScale( scaleArray, scaleValue ) {    	
    	var choosenScale = new Array();
    	var i = 0;
    	for ( i = 0; i < scaleArray.length; i++ ) {    		
			if ( scaleArray[i].name != scaleValue ) {
				choosenScale.push( new SecuredObject( scaleArray[i].id, scaleArray[i].name, scaleArray[i].isAccessible, scaleArray[i].constraints ) );
			}
    	}
    	return choosenScale;
    }
    
    function getSelectedScales() {
    	var selectedScales = new Array();    
    	var i = 0;	
    	for( i = 0; i < document.scalesSelectForm.scalesSelected.options.length; i++ ){
    		var tmp =  document.scalesSelectForm.scalesSelected.options[i].text ;
    		if( isNumber ( tmp )) {
	    		selectedScales.push( new SecuredObject( i, tmp , true, new Array() ) );
	    	}
    	}
    	return selectedScales;
    }
    
    function getAvailableScales() {
   		var scalesAvailable = new Array();
    	var i = 0;
    	for ( i = 0; i < document.scalesSelectForm.scalesAvailable.options.length; i++ ){
    		var tmp =  document.scalesSelectForm.scalesAvailable.options[i].text;
    		if ( isNumber( tmp ) ) {
	    		scalesAvailable.push( new SecuredObject( i, tmp , false, new Array() ) );
	    	}
    	}
    	return scalesAvailable;
    }
    
    // Checks that a string contains only numbers
	function isNumber( str ) {
  		for ( var position = 0; position < str.length; position++ ) {
			var chr = str.charAt(position)
	    	if  ( ( chr < "0" ) || ( chr > "9" ) )  {
    	          return false;
        	}
	  }      
	  return true;
	}
  
</script>

<fieldset>
	<legend> 
		<b>Massst&auml;be</b> 
	</legend>
	<form class="control" action="javascript:assignTemplateConstraints()" name="scalesSelectForm">
		<table border="0">
			<tr>
				<td valign="top">
			<tr>
				<td class="caption">zugreifbare Massst&auml;be</td>
				<td />
				<td class="caption">gesperrte Massst&auml;be</td>
			</tr>
			<tr>
				<td>
					<select class="largeselect" name="scalesSelected" size="10" multiple="multiple">
						<option>Formularinitialisierung...</option>
					</select>
				</td>
				<td valign="middle" align="center">
					<a href="javascript:setTemplateScaleRights( false )"> 
						<img src="bilder/admin_bt_remove.gif" alt="-" border="0" /> 
					</a> 
					<br />
				<a href="javascript:setTemplateScaleRights( true )"> <img
					src="bilder/admin_bt_add.gif" alt="+" border="0" />
					 </a></td>
				<td><select class="largeselect" name="scalesAvailable" size="10" multiple="multiple">
					<option>Formularinitialisierung...</option>
				</select></td>
			</tr>
			<tr>
				<td class="caption">neuen Massstab eingeben <input type="text" name="newScale" size="10" />
				<table border="0" cellspacing="5" cellpadding="2">
					<tr>
						<td class="menu"><a href="javascript:addNewScale()">neuen Massstab eingeben</a></td>
					</tr>
				</table>
				<table border="0" cellspacing="5" cellpadding="2">
					<tr>
						<td class="menu"><a href="javascript:deleteScale()">Massstab l&ouml;schen</a></td>
					</tr>
				</table>
				</td>		
			</tr>	
		</table>
	</form>
</fieldset>
