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
var target = "SecurityRequestDispatcher"
var changed = false

function isUnchanged(){
  return ((changed && confirm("Wenn Sie fortfahren, werden Sie alle \u00C4nderungen auf dieser Seite verlieren.\n"
                              + "Wirklich weitermachen?")) || !changed)
}

/**
 * Execute the given XML encoded RPC.
 */
function executeRPC (rpc) {
  var form = document.createElement ("form")
  form.setAttribute("action", target)
  form.setAttribute("className", "hidden")
  form.setAttribute("method", "POST")
  var input = document.createElement ("input")
  input.setAttribute("name", "rpc")
  input.setAttribute("type", "hidden")
  input.setAttribute("value", "s")
  form.appendChild (input)
  document.body.appendChild (form)
  input.setAttribute("value", encodeURIComponent(rpc))
  form.submit()
}

function initUserEditor() {
  if(isUnchanged()){
    var s = "<?xml version='1.0'?>";
    s = s + "<methodCall>";
    s = s + "<methodName>initUserEditor</methodName>";
    s = s + "</methodCall>";
    executeRPC (s);
  }
}

function initServicesEditor() {
  if(isUnchanged()){
    var s = "<?xml version='1.0'?><methodCall><methodName>initServicesEditor</methodName></methodCall>"
    executeRPC(s)
  }
}

function addService(address, type){
  address = trim(address)
  if(!address.indexOf("http://") == 0){
    alert("Die Dienstadresse muss mit http:// beginnen!")
    return
  }
  var s = "<?xml version='1.0'?><methodCall><methodName>addService</methodName>"
    + "<params><param><value><string>" + xmlenc(address) + "</string></value></param><param><value><string>"
    + type + "</string></value></param></params></methodCall>"
  executeRPC(s)
}

function removeService(address){
  var s = "<?xml version='1.0'?><methodCall><methodName>removeService</methodName>"
    + "<params><param><value><string>" + xmlenc(address) + "</string></value></param></params></methodCall>"
  executeRPC(s)
}

function updateService(address, type){
  var s = "<?xml version='1.0'?><methodCall><methodName>updateService</methodName>"
    + "<params><param><value><string>" + xmlenc(address) + "</string></value></param><param><value><string>"
    + type + "</string></value></param></params></methodCall>"
  executeRPC(s)
}

function editService(address){
  var s = "<?xml version='1.0'?><methodCall><methodName>editService</methodName>"
    + "<params><param><value><string>" + xmlenc(address) + "</string></value></param></params></methodCall>"
  executeRPC(s)
}

function reallyUpdate(address, type){
  if(confirm("Wollen Sie die Datenbank wirklich aktualisieren?\nGelöschte Datenbankobjekte sind unwiederbringlich verloren!")){
    var s = "<?xml version='1.0'?><methodCall><methodName>reallyUpdateService</methodName>"
      + "<params><param><value><string>" + xmlenc(address) + "</string></value></param><param><value><string>"
      + type + "</string></value></param></params></methodCall>"
    executeRPC(s)
  }
}

function rpcheader(name){
  return "<?xml version='1.0'?><methodCall><methodName>" + xmlenc(name) + "</methodName><params>"
}

function rpcstring(string){
  return "<value><string>" + xmlenc(string) + "</string></value>"
}

function rpcparam(string){
  return "<param>" + string + "</param>"
}

function rpcarray(array, typefun){
  var s = "<value><array><data>"
  for(var i in array) s += typefun(array[i])
  return s + "</data></array></value>"
}

function rpcstruct(names, values){
  if(names.length == 0) return ""
  var s = "<value><struct>"

  while(names.length > 0) s += "<member><name>" + xmlenc(names.pop()) + "</name>" + rpcstring(values.pop()) + "</member>"

  return s += "</struct></value>"
}

function updateObjects(service, objects, title, address){
  address = trim(address)
  if(!address.indexOf("http://") == 0){
    alert("Die Dienstadresse muss mit http:// beginnen!")
    return
  }
  if(changed){
    var s = rpcheader("updateObjects") + rpcparam(rpcstring(service.address))

    var objs = []
    for(var o in objects) {
      objs.push(o)
      objs.push(objects[o])
    }
    s += rpcparam(rpcarray(objs, rpcstring))

    var names = [], values = []
    if(title){
      names[names.length] = "title"
      values[values.length] = title
    }
    if(address){
      names[names.length] = "address"
      values[values.length] = address
    }
    var str = rpcstruct(names, values)
    if(str != "") s += rpcparam(str)

    s += "</params></methodCall>"
    executeRPC(s)
  }
}

function initGroupEditor()  {
  if(isUnchanged()){
    var s = "<?xml version='1.0'?>";
    s = s + "<methodCall>";
    s = s + "<methodName>initGroupEditor</methodName>";
    s = s + "</methodCall>";
    executeRPC (s);
  }
}

function initRoleEditor()  {
  if(isUnchanged()){
    var s = "<?xml version='1.0'?>";
    s = s + "<methodCall>";
    s = s + "<methodName>initRoleEditor</methodName>";
    s = s + "</methodCall>";
    executeRPC (s);
  }
}

function initSecuredObjectsEditor() {
  if(isUnchanged()){
    var s = "<?xml version='1.0'?>";
    s = s + "<methodCall>";
    s = s + "<methodName>initSecuredObjectsEditor</methodName>";
    s = s + "</methodCall>";
    executeRPC (s);
  }
}

function initSubadminEditor()  {
  alert( "Diese Funktion ist noch nicht implementiert." );
  return;
  var s = "<?xml version='1.0'?>";
  s = s + "<methodCall>";
  s = s + "<methodName>initSubadminRoleEditor</methodName>";
  s = s + "</methodCall>";
  executeRPC (s);
}

/**
 * Executes a 'loginUsers'-RPC built using the given parameters.
 */
function loginUser( userName, password ) {
  var rpc = "<?xml version=\"1.0\"?>"
    + "<methodCall><methodName>loginUser</methodName><params>";
  rpc += "<param><value><string>" + xmlenc(userName) + "</string></value></param>";
  rpc += "<param><value><string>" + xmlenc(password) + "</string></value></param>";
  rpc += "</params></methodCall>";
  executeRPC (rpc);
}

/**
 * Executes a 'logoutUser'-RPC.
 */
function logoutUser() {
  if(isUnchanged()){
    var s = "<?xml version='1.0'?>";
    s = s + "<methodCall><methodName>logoutUser</methodName></methodCall>";
    executeRPC (s);
  }
}

/**
 * Executes a 'storeUsers'-RPC built using the given parameters.
 *
 * changed interface for context chooser
 */
function storeUsers( users, usersDirectory, defaultContext ) {
  var found = false
  for ( var i = 0; i < users.length; ++i ) {
    if ( users[i].name == 'default' ) {
      found = true
    }
  }
  if( !found ) {
    var msg = "Es wurde kein Benutzer namens 'default' gefunden.\n"
    msg += "Dieser wird jedoch normalerweise von deegree als 'anonymer'\n"
    msg += "Benutzer verwendet. Wollen Sie dennoch fortfahren?"
    if ( !confirm( msg ) ) {
      return
    }
  }

  var rpc = "<?xml version=\"1.0\"?>"
    + "<methodCall><methodName>storeUsers</methodName><params>";
  for (i = 0; i < users.length; i++) {
    rpc += "<param><value><struct>";
    rpc += "<member><name>userId</name><value><string><![CDATA["
      + users[i].id + "]]></string></value></member>";
    rpc += "<member><name>userName</name><value><string><![CDATA["
      + users[i].name + "]]></string></value></member>";
    rpc += "<member><name>email</name><value><string><![CDATA["
      + users[i].email + "]]></string></value></member>";
    if ( users[i].password != null ) {
      rpc += "<member><name>password</name><value><string><![CDATA["
        + users[i].password + "]]></string></value></member>";
    }
    if ( users[i].firstName != null ) {
      rpc += "<member><name>firstName</name><value><string><![CDATA["
        + users[i].firstName + "]]></string></value></member>";
    }
    if ( users[i].lastName != null ) {
      rpc += "<member><name>lastName</name><value><string><![CDATA["
        + users[i].lastName + "]]></string></value></member>";
    }

    // added for context chooser
    if ( isReadContextsSuccess ) {
      //Assigning the value of the start context to the user

      if ( users[i].contextName != null ) {
        rpc += "<member><name>contextName</name><value><string><![CDATA["
          + users[i].contextName + "]]></string></value></member>";
      }

      if ( users[i].contextPath != null) {
        rpc += "<member><name>contextPath</name><value><string><![CDATA["
          + users[i].contextPath + "]]></string></value></member>";
      }
    }

    rpc += "</struct></value></param>";
  }

  // added for context chooser: Writing the users directory
  if ( usersDirectory != null ) {
    rpc += "<param><value><struct>";
    rpc += "<member><name>usersDirectory</name><value><string><![CDATA["
      + usersDirectory + "]]></string></value></member>";
    rpc += "<member><name>defaultContextName</name><value><string><![CDATA["
      + defaultContext.name + "]]></string></value></member>";
    rpc += "<member><name>defaultContextPath</name><value><string><![CDATA["
      + defaultContext.path + "]]></string></value></member>";
    rpc += "</struct></value></param>";
  }

  rpc += "</params></methodCall>";
  executeRPC( rpc );
}

/**
 * Executes a 'storeGroups'-RPC built using the given parameters.
 */
function storeGroups( groups ) {
  var rpc = "<?xml version=\"1.0\"?>"
    + "<methodCall><methodName>storeGroups</methodName><params>";

  for ( i = 0; i < groups.length; i++ ) {
    rpc += "<param><value><struct>";
    if ( groups[i].id != -1 ) {
      rpc += "<member><name>groupId</name><value><string><![CDATA["
        + groups[i].id + "]]></string></value></member>";
    } else {
      rpc += "<member><name>groupName</name><value><string><![CDATA["
        + groups[i].name + "]]></string></value></member>";
    }
    members = groups[i].userMembers;
    rpc += "<member><name>userMembers</name><value><array><data>";
    for ( j = 0; j < members.length; j++ ) {
      rpc += "<value><string><![CDATA[" + members[j].id + "]]></string></value>";
    }
    rpc += "</data></array></value></member>";
    members = groups[i].groupMembers;
    rpc += "<member><name>groupMembers</name><value><array><data>";
    for ( j = 0; j < members.length; j++ ) {
      rpc += "<value><string><![CDATA[" + members[j].id + "]]></string></value>";
    }
    rpc += "</data></array></value></member></struct></value></param>";
  }
  rpc += "</params></methodCall>";
  executeRPC( rpc );
}

/**
 * Executes a 'getUsers'-RPC built using the given parameter
 * (which is a Java regular expression).
 */
function getUsers( regex ) {
  var rpc = "<?xml version=\"1.0\"?>"
    + "<methodCall>"
    + "<methodName>getUsers</methodName>"
    + "<params>"
    + "<param><value><string><![CDATA[" + regex + "]]></string></value></param>";
  rpc += "</params></methodCall>";
  executeRPC( rpc );
}

/**
 * Executes a 'storeRoles'-RPC built using the given parameters.
 */
function storeRoles( roles ) {
  var rpc = "<?xml version=\"1.0\"?>"
    + "<methodCall><methodName>storeRoles</methodName><params>";

  for ( i = 0; i < roles.length; i++ ) {
    rpc += "<param><value><struct>";
    if ( roles[i].id != -1 ) {
      rpc += "<member><name>roleId</name><value><string><![CDATA["
        + roles[i].id + "]]></string></value></member>";
    } else {
      rpc += "<member><name>roleName</name><value><string><![CDATA["
        + roles[i].name + "]]></string></value></member>";
    }
    groups = roles[i].groups;
    rpc += "<member><name>groups</name><value><array><data>";
    for (j = 0; j < groups.length; j++) {
      rpc += "<value><string><![CDATA[" + groups[j].id + "]]></string></value>";
    }
    rpc += "</data></array></value></member></struct></value></param>";
  }

  rpc += "</params></methodCall>";
  executeRPC( rpc );
}

/**
 * Executes a 'storeSubadminRoles'-RPC built using the given parameters.
 */
function storeSubadminRoles( roles ) {
  var rpc = "<?xml version=\"1.0\"?>"
    + "<methodCall><methodName>storeSubadminRoles</methodName><params>";

  for ( i = 0; i < roles.length; i++ ) {
    rpc += "<param><value><struct>";
    if ( roles[i].id != -1 ) {
      rpc += "<member><name>roleId</name><value><string><![CDATA["
        + roles[i].id + "]]></string></value></member>";
    } else {
      rpc += "<member><name>roleName</name><value><string><![CDATA["
        + roles[i].name + "]]></string></value></member>";
    }
    groups = roles[i].groups;
    rpc += "<member><name>groups</name><value><array><data>";
    for ( j = 0; j < groups.length; j++ ) {
      rpc += "<value><string><![CDATA[" + groups[j].id + "]]></string></value>";
    }
    rpc += "</data></array></value></member></struct></value></param>";
  }

  rpc += "</params></methodCall>";
  return rpc;
}

/**
 * Executes a 'storeRights'-RPC built using the given parameters.
 */
function storeRights( securedObjectTypes, roleId ) {
  var rpc = "<?xml version=\"1.0\"?>"
    + "<methodCall>"
    + "<methodName>storeRights</methodName>"
    + "<params>"
    + "<param><value><string><![CDATA[" + roleId + "]]></string></value></param>";

  for ( var i = 0; i < securedObjectTypes.length; i++ ) {
    var securedObjectRights = securedObjectTypes[i];
    rpc += "<param><value><array><data>";
    for ( var j = 0; j < securedObjectRights.length; j++ ) {
      if ( securedObjectRights[j].isAccessible ) {
        if ( securedObjectRights[j].constraints == null ) {
          rpc += "<value><string><![CDATA[" + securedObjectRights[j].id + "]]></string></value>";
        } else {
          rpc += "<value><array><data>";
          rpc += "<value><string><![CDATA[" + securedObjectRights[j].id + "]]></string></value>";
          rpc += toRPCParam( securedObjectRights[j].constraints );
          rpc += "</data></array></value>";
        }
      }
    }
    rpc += "</data></array></value></param>";
  }

  rpc += "</params></methodCall>";
  executeRPC( rpc );
}

function storeServicesRights(selected, roleId) {
  var rpc = "<?xml version='1.0'?><methodCall><methodName>storeServicesRights</methodName><params><param><value><string>" + roleId + "</string></value></param>"

  rpc += "<param><value><array><data>"
  for(var o in selected) rpc += "<value><string>" + selected[o].id + "</string></value>"
  rpc += "</data></array></value></param>"

  rpc += "</params></methodCall>"
  executeRPC(rpc)
}

function storeRightsExt(layers, fts, roleId){
  var rpc = "<?xml version='1.0'?><methodCall><methodName>storeRights</methodName><params><param><value><string>" + roleId + "</string></value></param>"

  rpc += "<param><value><array><data>"
  for(var o in layers) rpc += "<value><string>" + layers[o].id + "</string></value>"
  rpc += "</data></array></value></param>"

  rpc += "<param><value><array><data>"
  for(o in fts) rpc += "<value><string>" + fts[o].id + "</string></value>"
  rpc += "</data></array></value></param>"

  rpc += "</params></methodCall>"
  executeRPC(rpc)
}

function storeFinegrainedRights(layers, fiLayers, fts, roleId, serviceId, sldAllowed, constraints){
  var rpc = "<?xml version='1.0'?><methodCall><methodName>storeRights</methodName><params><param><value><string>" + roleId + "</string></value></param>"

  rpc += "<param><value><array><data>"
  for(var o in layers) rpc += "<value><string>" + layers[o].id + "</string></value>"
  rpc += "</data></array></value></param>"

  rpc += "<param><value><array><data>"
  for(o in fiLayers) rpc += "<value><string>" + fiLayers[o].id + "</string></value>"
  rpc += "</data></array></value></param>"

  rpc += "<param><value><array><data>"
  for(o in fts) rpc += "<value><string>" + fts[o].id + "</string></value>"
  rpc += "</data></array></value></param>"

  rpc += "<param><value><string>" + serviceId + "</string></value></param>"
  rpc += "<param><value><string>" + sldAllowed + "</string></value></param>"
  rpc += "<param><value><string>{maxWidth: " + constraints.maxWidth + ", maxHeight: " + constraints.maxHeight + "}</string></value></param>"

  rpc += "</params></methodCall>"
  executeRPC(rpc)
}

/**
 * Executes a 'storeSubadminRole-RPC' built using the given parameters.
 */
function storeSubadminRole( datasets, roleId ) {
  var rpc = "<?xml version=\"1.0\"?>"
    + "<methodCall>"
    + "<methodName>storeSubadminRole</methodName>"
    + "<params>"
    + "<param><value><string><![CDATA[" + roleId + "]]></string></value></param>";

  rpc += "<param><value><array><data>";
  for (i = 0; i < datasets.length; i++) {
    if (datasets[i].grantRight) {
      rpc += "<value><string><![CDATA[" + datasets[i].id + "]]></string></value>";
    }
  }
  rpc += "</data></array></value></param>"
    + "</params></methodCall>";
  executeRPC( rpc );
}

/**
 * Executes a 'storeSecuredObjects'-RPC built using the given parameter.
 */
function storeSecuredObjects( objectTypes ) {
  var rpc = "<?xml version=\"1.0\"?>"
    + "<methodCall><methodName>storeSecuredObjects</methodName><params>";
  for ( i = 0; i < objectTypes.length; i++ ) {
    objects = objectTypes[i];
    for (j = 0; j < objects.length; j++) {
      rpc += "<param><value><struct>";
      rpc += "<member><name>id</name><value><string><![CDATA["
        + objects[j].id + "]]></string></value></member>";
      rpc += "<member><name>name</name><value><string><![CDATA["
        + objects[j].name + "]]></string></value></member>";
      rpc += "<member><name>type</name><value><string><![CDATA["
        + objects[j].type + "]]></string></value></member>";
      rpc += "</struct></value></param>";
    }
  }
  rpc += "</params></methodCall>";
  executeRPC( rpc );
}

/**
 * Executes an 'editRights'-RPC built using the given parameters.
 */
function editRightsRPC( roleId ) {
  var rpc = "<?xml version=\"1.0\"?>"
    + "<methodCall>"
    + "<methodName>editRights</methodName>"
    + "<params><param><value><string>"
    + "<![CDATA[" + roleId + "]]>"
    + "</string></value></param></params>"
    + "</methodCall>";
  executeRPC( rpc );
}

function editServiceRightsRPC( roleId ) {
  var rpc = "<?xml version=\"1.0\"?>"
    + "<methodCall>"
    + "<methodName>editServiceRights</methodName>"
    + "<params><param><value><string>"
    + "<![CDATA[" + roleId + "]]>"
    + "</string></value></param></params>"
    + "</methodCall>"
  executeRPC( rpc )
}

/**
 * Executes an 'editSubadminRoles'-RPC built using the given parameters.
 */
function editSubadminRole( role ) {
  var rpc = "<?xml version=\"1.0\"?>"
    + "<methodCall>"
    + "<methodName>editSubadminRole</methodName>"
    + "<params><param><value><string>"
    + "<![CDATA[" + role.id + "]]>"
    + "</string></value></param></params>"
    + "</methodCall>";
  executeRPC( rpc );
}

/**
 * Executes a 'getServiceInfo'-RPC built using the given parameters.
 */
function getServiceInfo( catalogName, serviceId ) {
  var rpc = "<?xml version=\"1.0\"?>"
    + "<methodCall>"
    + "<methodName>getServiceInfo</methodName>"
    + "<params>"
    + "<param><value><string><![CDATA[" + catalogName + "]]></string></value></param>"
    + "<param><value><string><![CDATA[" + serviceId + "]]></string></value></param>"
    + "</params>"
    + "</methodCall>";
  executeRPC( rpc );
}

/**
 * Executes a 'deleteService'-RPC built using the given parameters.
 */
function deleteService( catalogName, serviceId, serviceURL, serviceType ) {
  var rpc = "<?xml version=\"1.0\"?>"
    + "<methodCall>"
    + "<methodName>deleteService</methodName>"
    + "<params>"
    + "<param><value><string><![CDATA[" + catalogName + "]]></string></value></param>"
    + "<param><value><string><![CDATA[" + serviceId + "]]></string></value></param>"
    + "<param><value><string><![CDATA[" + serviceURL + "]]></string></value></param>"
    + "<param><value><string><![CDATA[" + serviceType + "]]></string></value></param>"
    + "</params>"
    + "</methodCall>";
  return rpc;
}

/**
 * Executes a 'registerService'-RPC built using the given parameters.
 */
function registerService( catalogName, serviceURL, serviceType ) {
  var rpc = "<?xml version=\"1.0\"?>"
    + "<methodCall>"
    + "<methodName>registerService</methodName>"
    + "<params>"
    + "<param><value><string><![CDATA[" + catalogName + "]]></string></value></param>"
    + "<param><value><string><![CDATA[" + serviceURL + "]]></string></value></param>"
    + "<param><value><string><![CDATA[" + serviceType + "]]></string></value></param>"
    + "</params>"
    + "</methodCall>";
  executeRPC( rpc );
}

/**
 * Returns the selected options from an options-list as an options-array.
 */
function getSelectedOptions( options ) {
  var selected = new Array ();
  for ( i = 0; i < options.length; i++ ) {
    if ( options[i].selected ) {
      selected[selected.length] = options[i];
    }
  }
  return selected;
}

/**
 * Returns the selected options from an options-list as an index-array, i.e.
 * the list of indexes of the options that are selected.
 */
function getSelectedOptionsIdx( options ) {
  var selected = new Array();
  for ( i = 0; i < options.length; i++ ) {
    if ( options[i].selected ) {
      selected[selected.length] = i;
    }
  }
  return selected;
}

/**
 * Sort-function for objects that have 'name'-fields.
 */
function namesort( object1, object2 ) {
  if ( object1.name < object2.name ) return -1;
  if ( object1.name > object2.name ) return 1;
  return 0;
}

function fixIE(){
  if(!document.body.addEventListener){
    if(!document.compatMode) document.body.style.textAlign = "center"
  }
}

function sortLinkClicked(linkmap, cur){
  for(var i in linkmap){
    var el = document.getElementById(i)
    if(cur == i){
      eval(linkmap[i])
      document.getElementById(i).className = 'selectedSortingMethod'
    } else {
      el.className = 'sorting'
    }
  }
}
