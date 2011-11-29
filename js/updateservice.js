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
var oldservice, newservice

function generateComparison(){
  if(oldservice.address != newservice.address){
    alert("The two services' addresses may not differ, please help the programmer!")
    return
  }

  var servicesDifferent = false

  var div = document.getElementById("comparison")
  h3(div, "Serviceadresse: " + newservice.address)
  h4(div, "Gelöschte Objekte:")
  var deletedList = ul(div)
  deletedList.style.paddingLeft = "5px"

  for(var name in oldservice.objects){
    var title = oldservice.objects[name]
    if(!containsKey(newservice.objects,name)) li(deletedList, name + " (" + titleFun(title) + ")")
  }

  if(!deletedList.firstChild){
    div.removeChild(deletedList)
    p(i(div, "Keine gelöschten Objekte"))
  }else servicesDifferent = true

  h4(div, "Modifizierte Objekte:")
  var modifiedList = ul(div)
  modifiedList.style.paddingLeft = "5px"

  for(name in oldservice.objects){
    var title = oldservice.objects[name]
    var newTitle = newservice.objects[name]
    if(newTitle && title != newTitle) li(modifiedList, name + ": " + titleFun(title) + " -> " + titleFun(newTitle))
  }

  if(!modifiedList.firstChild){
    div.removeChild(modifiedList)
    p(i(div, "Keine modifizierten Objekte"))
  }else servicesDifferent = true

  h4(div, "Neue Objekte:")
  var addedList = ul(div)
  addedList.style.paddingLeft = "5px"

  for(name in newservice.objects){
    var title = newservice.objects[name]
    if(!containsKey(oldservice.objects, name)) li(addedList, name + " (" + titleFun(title) + ")")
  }

  if(!addedList.firstChild){
    div.removeChild(addedList)
    p(i(div, "Keine neuen Objekte"))
  }else servicesDifferent = true

  if(servicesDifferent){
    var link = a(div, "Datenbank aktualisieren")
    link.href = "javascript:reallyUpdate(newservice.address, newservice.type)"
    link.className = "normalLink"
  }
}

function titleFun(title){
  return title ? title : "kein Titel"
}