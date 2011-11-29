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
var service
var renamedObjects = {}
var newTitle
var newAddress
var sortfun

var linkmap = {
  sort1: "sortfun = sortFun(true, 'name'); redisplayObjects()",
  sort2: "sortfun = sortFun(false, 'name'); redisplayObjects()",
  sort3: "sortfun = sortFun(true, 'title'); redisplayObjects()",
  sort4: "sortfun = sortFun(false, 'title'); redisplayObjects()"
}

function generateContent(){
  renamedObjects = {}
  newTitle = null
  newAddress = null
  changed = false

  redisplayObjects()
}

function redisplayObjects(){
  var div = document.getElementById("content")
  while(div.firstChild) div.removeChild(div.firstChild)

  var table = this.table(div)
  table.rules = "all"
  table.className = "centeredTable"
  if(!table.addEventListener) table = tbody(table)

  var tr = this.tr(table)
  highlightTableRow(tr)
  var node = td(tr)
  b(node, "Service-Titel:")
  node.className = "servicesBorder"
  node = td(tr, service.title)
  node.className = "servicesBorder"

  tr.onclick = function(cell, name){
    return function(){
      var newname = prompt("Bitte geben Sie den neuen Titel ein:", name)
      if(newname && newname != name){
        changed = true
        cell.firstChild.nodeValue = newname
        cell.className = 'highlightedCell'
        newTitle = newname
      }
    }
  }(node, service.title)

  if(newTitle){
    node.firstChild.nodeValue = newTitle
    node.className = 'highlightedCell'
  }

  tr = this.tr(table)
  highlightTableRow(tr)
  node = td(tr)
  b(node, "Service-Adresse:")
  node.className = "servicesBorder"
  node = td(tr, service.address)
  node.className = "servicesBorder"

  tr.onclick = function(cell, name){
    return function(){
      var newname = prompt("Bitte geben Sie die neue Adresse ein:", name)
      if(newname && newname != name){
        changed = true
        cell.firstChild.nodeValue = newname
        cell.className = 'highlightedCell'
        newAddress = newname
      }
    }
  }(node, service.address)

  if(newAddress){
    node.firstChild.nodeValue = newAddress
    node.className = 'highlightedCell'
  }

  br(div)

  table = this.table(div)
  table.rules = "all"
  table.className = "centeredTable"
  div.style.height = (calcWindowSize("Height") - 200) + "px"

  if(!table.addEventListener) table = tbody(table)

  var header = this.tr(table)
  header.id = "headerRow"
  th(header, "Nr.").className = "servicesBorderTop"

  node = th(header, "Name")
  node.className = "servicesBorderTop"
  var link = a(node, "‹")
  link.title = "Aufsteigend sortieren"
  link.id = 'sort1'
  link.href = "javascript:sortLinkClicked(linkmap, 'sort1')"
  link.className = "sorting"
  link = a(node, "›")
  link.title = "Absteigend sortieren"
  link.id = 'sort2'
  link.href = "javascript:sortLinkClicked(linkmap, 'sort2')"
  link.className = "sorting"

  node = th(header, "Titel")
  node.className = "servicesBorder"
  link = a(node, "‹")
  link.title = "Aufsteigend sortieren"
  link.id = 'sort3'
  link.href = "javascript:sortLinkClicked(linkmap, 'sort3')"
  link.className = "sorting"
  link = a(node, "›")
  link.title = "Absteigend sortieren"
  link.id = 'sort4'
  link.href = "javascript:sortLinkClicked(linkmap, 'sort4')"
  link.className = "sorting"

  var nr = 0

  var objs = []
  for(var i in service.objects) objs.push({name: i, title: service.objects[i]})
  if(sortfun) objs.sort(sortfun)

  for(i in objs){
    tr = this.tr(table)
    td(tr, ++nr).className = "servicesBorder"
    var name = objs[i].name
    if(renamedObjects[name]) name = renamedObjects[name]
    var namecell = td(tr, name)
    if(renamedObjects[objs[i].name]) namecell.className = "highlightedCell"
    else namecell.className = "servicesBorder"
    td(tr, objs[i].title ? objs[i].title : "(kein Titel)").className = "servicesBorder"
    highlightTableRow(tr)
    tr.onclick = function(cell, name){
      return function(){
        var newname = trim(prompt("Bitte geben Sie den neuen Namen ein:", name))
        if(service.objects[newname] != undefined){
          alert("Ein Objekt mit diesem Namen existiert bereits!")
          return
        }
        if(newname && newname != name){
          changed = true
          cell.firstChild.nodeValue = newname
          cell.className = 'highlightedCell'
          renamedObjects[name] = newname
        }
      }
    }(namecell, objs[i].name)
  }
}

function perform(){
  var a = newAddress ? newAddress : service.address
  var t = newTitle ? newTitle : service.title
  updateObjects(service, renamedObjects, t, a)
}
