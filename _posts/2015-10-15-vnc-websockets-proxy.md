---
layout: post
title: Implementing a noVNC websocket proxy
tags: websockets, noVNC, proxy
---

### A websockets noVNC proxy

In computer networks, a proxy server is a server (a computer system or an application) that acts as an intermediary for requests from clients seeking resources from other servers. A client connects to the proxy server, requesting some service, such as a file, connection, web page, or other resource available from a different server and the proxy server evaluates the request as a way to simplify and control its complexity. Proxies were invented to add structure and encapsulation to distributed systems.[1] Today, most proxies are web proxies, facilitating access to content on the World Wide Web and providing anonymity.

### The VNC dispatcher

The VNC dispatcher generated a random VNC password and a random socket identifier. Then uses the `cloudvnc` script to start the actual VNC server and deliver `Xvnc` process id along with the display number.

```javascript
var express = require('express');
var async = require('async');
var http = require('http');
var fs = require('fs');
var crypto = require('crypto');
var sequest = require('sequest');
var client = require('mongodb').MongoClient;

var app = express();
var mongodb = 'mongodb://localhost/vncDispatch';

app.get('/vncdispatch/:username/:remoteip', function(req, res) {
client.connect(mongodb, function(err, db) {
if (err) throw err;
var config = db.collection('config');
var tokenizer = db.collection('tokenizer');
tokenizer.findOne({username: req.params.username}, function(err, doc) {
if (err) throw(err);
if (doc) {
doc.remoteip = req.params.remoteip;
tokenizer.save(doc, function(err) {
if (err) throw(err);
res.json(doc);
});
} else {
async.waterfall([
function(done) {
config.findOne({}, function(err, doc) {
var next_blade = doc.blade_list [
(doc.last_blade+1) % doc.num_of_blades
];
crypto.randomBytes(30, function(err, buf) {
var token = buf.toString('hex');
done(err, next_blade, token);
});
});
},
function(next_blade, token, done) {
var key = fs.readFileSync(process.env.HOME + '/.ssh/id_rsa');
var re = /(.*) (.*) (.*)/;
var vncpasswd = Math.random().toString(36).slice(-8)
var command = 'su - ' +
req.params.username +
' -c "cloudvnc ' + vncpasswd + '" 2>/dev/null';
sequest(next_blade, {
command: command,
privateKey: key
}, function(err, stdout) {
if (err) throw err;
var match = re.exec(stdout);
var blade = match[1];
var pid = match[2];
var display = match[3];
var doc = {
'username': req.params.username,
'password': vncpasswd,
'token': token,
'blade': blade,
'display': display,
'vncpid': pid,
'remoteip': req.params.remoteip
};
tokenizer.save(doc, function(err) {
if (err) throw err;
done(err, doc);
});
});
},
function(doc) {
config.findOne({}, function(err, cdoc) {
if (err) throw err;
cdoc.last_blade += 1;
config.save(cdoc, function(err) {
if (err) throw err;
db.close();
res.json(doc);
});
});
}
]);
}
});
});
});

http.createServer(app).listen(3003);
```

### Starting the actual VNC server

Starting the VNC server is one of the application server's job. We need to receive the automaticaly generated random password, create the VNC password file and finally start the VNC server. We use the following python script:

```python
from os import environ
import sys
import subprocess
import psutil

vncpasswd = open(environ['HOME'] + '/.vncpasswd', 'w')
vncpasswd_cmd = 'echo %s | vncpasswd -f' % sys.argv[1]
subprocess.call(vncpasswd_cmd, shell=True, stdout=vncpasswd)

vncserver_cmd = 'vncserver -rfbauth %s/.vncpasswd -autokill' % environ['HOME']
subprocess.call(vncserver_cmd, shell=True)

for p in psutil.process_iter():
if p.username==environ['USER']:
if p.name == 'Xvnc':
print environ['HOSTNAME'], p.pid, p.cmdline[15]
```