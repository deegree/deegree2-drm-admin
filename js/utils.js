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
function compare(o1, o2){
  if(o1.toLowerCase() < o2.toLowerCase()) return -1
  if(o2.toLowerCase() < o1.toLowerCase()) return 1
  return 0
}

function sortFun(up, field){
  return function(o1, o2){
    return up ? compare(o1[field], o2[field])
      : compare(o2[field], o1[field])
  }
}

function dumpdoc(doc){
  var buf = new XMLSerializer().serializeToString(doc)
  dumpln(XML(buf.replace(/<\?(.*?)\?>/g,"")).toXMLString())
}

function newnode(node, name, text){
  if(!node.ownerDocument) node.ownerDocument = document
  var n = node.appendChild(node.ownerDocument.createElement(name))
  if(text) addText(n, text)
  return n
}

var tags = ["p", "a", "td", "tr", "th", "h1", "h2", "h3", "h4", "h5", "h6", "ul", "ol", "li", "table", "tbody", "b", "br", "i"]
// beware of the scope...
for(var tag in tags) {
  this[tags[tag]] = function(x){
    return function (node, text){
      return newnode(node, x, text)
    }
  }(tags[tag])
}

function addText(node, text){
  if(!node.ownerDocument) node.ownerDocument = document
  node.appendChild(node.ownerDocument.createTextNode(text))
}

function dumpln(x){
  (this.dump ? dump : alert)(x + "\n")
}

function dumpinterface(x){
  var sum = []
  var doit = function(str){
    if(this.dump) dumpln(str)
    else sum[sum.length] = str
  }
  for(var y in x) doit(y + " (" + (typeof x[y]) + ")")

  if(!this.dump) alert(sum.sort())
}

function remove(array, obj){
  for(var i in array){
    while(array[i] === obj){
      array.splice(i, 1)
    }
  }

  return array
}

function clone(array){
  var cloned = []
  for(var i in array) cloned[i] = array[i]
  return cloned
}

function xmlenc(text){
  return "<![CDATA[" + text + "]]>"
}

function tableBody(table){
  return table.firstChild.nodeName == 'TBODY' ? table.firstChild : table
}

function debug(){
  dumpln(document.compatMode)
}

function contains(xs, x){
  for(var i = 0; i < xs.length; ++i) if(xs[i] === x) return true

  return false
}

function containsKey(xs, x){
  for(var i in xs) if(i === x) return true

  return false
}

function highlightTableRow(row, cssclass){
  cssclass = cssclass ? cssclass : 'highlightedRow'
  var oldclass = row.className
  row.onmouseover = function(){
    row.className = cssclass
  }
  row.onmouseout = function(){
    row.className = oldclass
  }
}

function trim(str){
  if(!str) return str

  var as = []
  for(var i = 0; i < str.length; ++i) as[i] = str.charAt(i)

  while(as[0] == ' ' || as[0] == '\t') as.shift()
  while(as[as.length-1] == ' ' || as[as.length-1] == '\t') as.pop()

  str = ""
  for(i = 0; i < as.length; ++i) str += as[i]

  return str
}

function calcWindowSize(widthOrHeight){
  var client = "client" + widthOrHeight
  var inner = "inner" + widthOrHeight
  return window[inner] ? window[inner] :
    (document.documentElement[client] ? document.documentElement[client] : document.body[client])
}