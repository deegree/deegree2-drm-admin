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
var services
var selectedService

function appendService(table, service, nr){
  var mytr = tr(table)
  td(mytr, nr).className = "servicesBorder"
  td(mytr, service.title).className = "servicesBorder"
  td(mytr, service.address).className = "servicesBorder"
  td(mytr, service.type).className = "servicesBorder"
  var act = td(mytr)
  act.className = "servicesBorderRight"
  var remove = a(act, "Löschen")
  remove.href = "javascript:deleteService('" + service.address + "')"
  remove.className = "normalLink"

  addText(act, " ")

  var update = a(act, "Aktualisieren")
  update.href = "javascript:updateService('" + service.address + "', '" + service.type + "')"
  update.className = "normalLink"

  addText(act, " ")

  var edit = a(act, "Bearbeiten")
  edit.href = "javascript:editService('" + service.address + "')"
  edit.className = "normalLink"

  highlightTableRow(mytr)
}

function updateServicesTable(sortFunc){
  var table = tableBody(document.getElementById("servicesTable"))
  var header = document.getElementById("servicesTableHeader")
  while(table.firstChild) table.removeChild(table.firstChild)
  table.appendChild(header)

  var servs = []

  for(var s in services) servs[servs.length] = services[s]

  if(sortFunc){
    servs.sort(sortFunc)
  }

  var idx = 1
  for(var i = 0; i < servs.length; ++i){
    appendService(table, servs[i], idx++)
  }
}

function deleteService(address){
  if(confirm("Soll der Dienst mit der Adresse '" + address + "' und die dazugehörigen Informationsebenen wirklich gelöscht werden?")){
    removeService(address)
  }
}

function clickedRadio(){
  if(document.serviceSelectForm.serviceType[0].checked){
    if(document.serviceSelectForm.serviceAddress.value == 'http://demo.deegree.org/deegree-wfs/services'){
      document.serviceSelectForm.serviceAddress.value = 'http://demo.deegree.org/deegree-wms/services'
    }
  }else{
    if(document.serviceSelectForm.serviceAddress.value == 'http://demo.deegree.org/deegree-wms/services'){
      document.serviceSelectForm.serviceAddress.value = 'http://demo.deegree.org/deegree-wfs/services'
    }
  }
}

function selectService(){
  var select = document.serviceSelectForm.serviceSelect
  selectedService = select.options[select.selectedIndex]
}

function importService(){
  var form = document.serviceSelectForm
  addService(form.serviceAddress.value, form.serviceType[0].checked ? "wms" : "wfs")
}
