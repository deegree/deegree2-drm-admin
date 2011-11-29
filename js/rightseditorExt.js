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
var services = {}
var optionsToServices = {}

var nonAccessibleLayersOrig = []
var nonAccessibleFiLayersOrig = []
var nonAccessibleFeatureTypesOrig = []
var accessibleLayersOrig = []
var accessibleFiLayersOrig = []
var accessibleFeatureTypesOrig = []

var nonAccessibleLayers = []
var nonAccessibleFiLayers = []
var nonAccessibleFeatureTypes = []
var accessibleLayers = []
var accessibleFiLayers = []
var accessibleFeatureTypes = []

var sortfun1, sortfun2

var lastIndex, lastRightTypeIndex

var lastRight

function initFirst(){
  changed = false
  nonAccessibleLayers = []
  nonAccessibleFiLayers = []
  accessibleLayers = []
  accessibleFiLayers = []
  nonAccessibleFeatureTypes = []
  accessibleFeatureTypes = []
  document.getElementById("leftDiv").style.height = (calcWindowSize("Height") - 260) + "px"
  document.getElementById("rightDiv").style.height = (calcWindowSize("Height") - 260) + "px"
}

function initGui(){
  var table1 = document.getElementById("leftTable")
  var table2 = document.getElementById("rightTable")

  var servs = document.getElementById("services")
  servs.options.length = 0
  optionsToServices = {}
  for(var s in services){
    var o = new Option(services[s].title + " (" + services[s].type + ")")
    servs.options[servs.options.length] = o
    optionsToServices[o.firstChild.nodeValue] = services[s]
  }

  if(servs.options.length == 0) servs.options[0] = Option("(keine Dienste vorhanden)")

  lastIndex = document.getElementById("services").selectedIndex
  lastRightTypeIndex = document.getElementById("rightTypes").selectedIndex
  updateTables()
  nonAccessibleLayersOrig = clone(nonAccessibleLayers)
  nonAccessibleFiLayersOrig = clone(nonAccessibleFiLayers)
  accessibleLayersOrig = clone(accessibleLayers)
  accessibleFiLayersOrig = clone(accessibleFiLayers)
  nonAccessibleFeatureTypesOrig = clone(nonAccessibleFeatureTypes)
  accessibleFeatureTypesOrig = clone(accessibleFeatureTypes)
}

function switchService(){
  if(changed && !confirm("Wenn Sie fortfahren, werden Sie alle \u00C4nderungen auf dieser Seite verlieren.\n"
                         + "Wirklich weitermachen?")){
    document.getElementById("services").selectedIndex = lastIndex
    return
  }

  if(changed){
    nonAccessibleFiLayers = clone(nonAccessibleFiLayersOrig)
    accessibleFiLayers = clone(accessibleFiLayersOrig)
    nonAccessibleLayers = clone(nonAccessibleLayersOrig)
    accessibleLayers = clone(accessibleLayersOrig)
    nonAccessibleFeatureTypes = clone(nonAccessibleFeatureTypesOrig)
    accessibleFeatureTypes = clone(accessibleFeatureTypesOrig)
    changed = false
  }

  updateTables()
  lastIndex = document.getElementById("services").selectedIndex
}

function switchRightType(){
  if(changed && !confirm("Wenn Sie fortfahren, werden Sie alle \u00C4nderungen auf dieser Seite verlieren.\n"
                         + "Wirklich weitermachen?")){
    document.getElementById("rightTypes").selectedIndex = lastRightTypeIndex
    return
  }

  if(changed){
    nonAccessibleFiLayers = clone(nonAccessibleFiLayersOrig)
    accessibleFiLayers = clone(accessibleFiLayersOrig)
    nonAccessibleLayers = clone(nonAccessibleLayersOrig)
    accessibleLayers = clone(accessibleLayersOrig)
    nonAccessibleFeatureTypes = clone(nonAccessibleFeatureTypesOrig)
    accessibleFeatureTypes = clone(accessibleFeatureTypesOrig)
    changed = false
  }

  lastRightTypeIndex = document.getElementById("rightTypes").selectedIndex
  updateTables()
}

function updateTables(){
  var opt = document.getElementById("services")
  var service = optionsToServices[opt.options[opt.selectedIndex].firstChild.nodeValue]

  if(!service) return

  if(service.type == 'WMS') {
    document.getElementById("leftHeader").firstChild.nodeValue = "Freigeschaltete Layer"
    document.getElementById("rightHeader").firstChild.nodeValue = "Gesperrte Layer"
    document.getElementById("maxWidth").style.visibility = 'visible'
    document.getElementById("maxWidthLabel").style.visibility = 'visible'
    document.getElementById("maxHeight").style.visibility = 'visible'
    document.getElementById("maxHeightLabel").style.visibility = 'visible'
    document.getElementById("sldSwitch").style.visibility = 'visible'
    document.getElementById("sldSwitchLabel").style.visibility = 'visible'
    document.getElementById("rightTypes").style.visibility = 'visible'
    document.getElementById("sldSwitch").checked = service.sldallowed
    document.getElementById("maxWidth").value = service.constraints.maxWidth
    document.getElementById("maxHeight").value = service.constraints.maxHeight
  } else {
    document.getElementById("maxWidth").style.visibility = 'hidden'
    document.getElementById("maxWidthLabel").style.visibility = 'hidden'
    document.getElementById("maxHeight").style.visibility = 'hidden'
    document.getElementById("maxHeightLabel").style.visibility = 'hidden'
    document.getElementById("sldSwitch").style.visibility = 'hidden'
    document.getElementById("sldSwitchLabel").style.visibility = 'hidden'
    document.getElementById("leftHeader").firstChild.nodeValue = "Freigeschaltete Featuretypes"
    document.getElementById("rightHeader").firstChild.nodeValue = "Gesperrte Featuretypes"
    document.getElementById("rightTypes").style.visibility = 'hidden'
  }

  var table1 = tableBody(document.getElementById("leftTable"))
  var table2 = tableBody(document.getElementById("rightTable"))
  var head1 = document.getElementById("leftHeaderRow")
  var head2 = document.getElementById("rightHeaderRow")

  while(table1.firstChild) table1.removeChild(table1.firstChild)
  table1.appendChild(head1)
  while(table2.firstChild) table2.removeChild(table2.firstChild)
  table2.appendChild(head2)

  appendObjects(service, table1, table2)

  // to prevent moving the tables down in ff3 at least
  var p1 = table1.parentNode
  var p2 = table2.parentNode
  p1.removeChild(table1)
  p2.removeChild(table2)
  p1.appendChild(table1)
  p2.appendChild(table2)
}

function findObject(list, name){
  for(var i in list) if(list[i].name == name) return list[i]
  return false
}

function rowListener(table, row){
  return function(event) {
    event = event ? event : window.event
    if(event.shiftKey){
      var up
      var cur = row
      var found = false
      while(cur.nextSibling){
        cur = cur.nextSibling
        if(cur == lastRight){
          up = false
          found = true
        }
      }
      cur = row
      while(cur.previousSibling){
        cur = cur.previousSibling
        if(cur == lastRight){
          up = true
          found = true
        }
      }

      if(!found) return

      var dir = up ? "previousSibling" : "nextSibling"

      cur = row
      while(cur != lastRight){
        cur.marked = true
        cur.className = 'highlightedCell'
        cur = cur[dir]
      }
    }else{
      if(row.marked){
        row.marked = false
      }else{
        row.marked = true
        lastRight = row
        row.className = 'highlightedCell'
      }
    }
  }
}

function appendObject(table, obj, idx){
  var mytr = tr(table)

  // special case highlight handling
  highlightTableRow(mytr)
  mytr.onclick = rowListener(table, mytr)
  mytr.onmouseout = function(){
    if(mytr.marked) mytr.className = 'highlightedCell'
    else mytr.className = null
  }

  var node = td(mytr, idx)
  node.onselectstart = function(){return false}
  node.onmousedown = function(){return false}
  node.className = "servicesBorder"
  node = td(mytr, obj.realname)
  node.onselectstart = function(){return false}
  node.onmousedown = function(){return false}
  node.className = "servicesBorder"
  node = td(mytr, obj.title ? obj.title : "(kein Titel)")
  node.className = "servicesBorder"
  node.onselectstart = function(){return false}
  node.onmousedown = function(){return false}
}

function appendObjects(service, left, right){
  var accessible, nonaccessible

  var aindex = 0
  var nindex = 0

  if(service.type == 'WMS' && document.getElementById('rightTypes').options[lastRightTypeIndex].value == 'GetMap'){
    accessible = accessibleLayers
    nonaccessible = nonAccessibleLayers
  }else if(service.type == 'WMS'){
    accessible = accessibleFiLayers
    nonaccessible = nonAccessibleFiLayers
  }else{
    accessible = accessibleFeatureTypes
    nonaccessible = nonAccessibleFeatureTypes
  }

  var leftobjs = [], rightobjs = []

  for(var o in service.objects){
    var obj = findObject(accessible, "[" + service.address + "]:" + o)
    if(obj){
      obj.realname = o
      leftobjs[leftobjs.length] = obj
    }
    obj = findObject(nonaccessible, "[" + service.address + "]:" + o)
    if(obj){
      obj.realname = o
      rightobjs[rightobjs.length] = obj
    }
  }

  if(sortfun1) leftobjs.sort(sortfun1)
  if(sortfun2) rightobjs.sort(sortfun2)

  for(var i in leftobjs) appendObject(left, leftobjs[i], ++aindex)
  for(i in rightobjs) appendObject(right, rightobjs[i], ++nindex)
}

function move(dir){
  changed = true
  var left = tableBody(document.getElementById(dir == 'right' ? "leftTable" : "rightTable"))
  var right = tableBody(document.getElementById(dir == 'right' ? "rightTable" : "leftTable"))

  var services = document.getElementById("services")
  var service = optionsToServices[services.options[services.selectedIndex].firstChild.nodeValue]

  var leftList, rightList

  if(service.type == 'WMS' && document.getElementById('rightTypes').options[lastRightTypeIndex].value == 'GetMap'){
    leftList = dir == 'right' ? accessibleLayers : nonAccessibleLayers
    rightList = dir == 'left' ? accessibleLayers : nonAccessibleLayers
  }else if(service.type == 'WMS'){
    leftList = dir == 'right' ? accessibleFiLayers : nonAccessibleFiLayers
    rightList = dir == 'left' ? accessibleFiLayers : nonAccessibleFiLayers
  }else{
    leftList = dir == 'right' ? accessibleFeatureTypes : nonAccessibleFeatureTypes
    rightList = dir == 'left' ? accessibleFeatureTypes : nonAccessibleFeatureTypes
  }

  var list = left.getElementsByTagName("tr")
  for(var i = 0; i < list.length; ++i){
    var row = list.item(i)
    if(row.marked){
      var name = row.getElementsByTagName("td").item(1).firstChild.nodeValue
      var dbname = "[" + service.address + "]:" + name
      var o = findObject(leftList, dbname)
      remove(leftList, o)
      rightList[rightList.length] = o
    }
  }

  updateTables()
}
