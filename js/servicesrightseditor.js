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
var selectedOrig, availableOrig

var sortfun1, sortfun2

var lastIndex

var lastRight

function initFirst(){
  changed = false
  document.getElementById("leftDiv").style.height = (calcWindowSize("Height") - 260) + "px"
  document.getElementById("rightDiv").style.height = (calcWindowSize("Height") - 260) + "px"
}

function initGui(){
  var table1 = document.getElementById("leftTable")
  var table2 = document.getElementById("rightTable")

  updateTables()
  selectedOrig = clone(selected)
  availableOrig = clone(available)
}

function updateTables(){
  var table1 = tableBody(document.getElementById("leftTable"))
  var table2 = tableBody(document.getElementById("rightTable"))
  var head1 = document.getElementById("leftHeaderRow")
  var head2 = document.getElementById("rightHeaderRow")

  while(table1.firstChild) table1.removeChild(table1.firstChild)
  table1.appendChild(head1)
  while(table2.firstChild) table2.removeChild(table2.firstChild)
  table2.appendChild(head2)

  if(sortfun1) selected.sort(sortfun1)
  if(sortfun2) available.sort(sortfun2)

  appendObjects(selected, table1)
  appendObjects(available, table2)

  // to prevent moving the tables down in ff3 at least
  var p1 = table1.parentNode
  var p2 = table2.parentNode
  p1.removeChild(table1)
  p2.removeChild(table2)
  p1.appendChild(table1)
  p2.appendChild(table2)
}

function findObject(list, value, field){
  for(var i in list) if(list[i][field] == value) return list[i]
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

function noop(){
	return false
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
  node.onselectstart = noop
  node.onmousedown = noop
  node.className = "servicesBorder"
  node = td(mytr, obj.type)
  node.onselectstart = noop
  node.onmousedown = noop
  node.className = "servicesBorder"
  node = td(mytr, obj.title)
  node.onselectstart = noop
  node.onmousedown = noop
  node.className = "servicesBorder"
  node = td(mytr, obj.address)
  node.onselectstart = noop
  node.onmousedown = noop
  node.className = "servicesBorder"
}

function appendObjects(list, table){
  var index = 0
  for(var o in list) appendObject(table, list[o], ++index)
}

function move(dir){
  changed = true
  var left = tableBody(document.getElementById(dir == 'right' ? "leftTable" : "rightTable"))
  var right = tableBody(document.getElementById(dir == 'right' ? "rightTable" : "leftTable"))

  var leftList = dir == 'right' ? selected : available
  var rightList = dir == 'left' ? selected : available

  var list = left.getElementsByTagName("tr")
  for(var i = 0; i < list.length; ++i){
    var row = list.item(i)
    if(row.marked){
      var address = row.getElementsByTagName("td").item(3).firstChild.nodeValue
      var o = findObject(leftList, address, 'address')
      remove(leftList, o)
      rightList[rightList.length] = o
    }
  }

  updateTables()
}
