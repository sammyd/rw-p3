var scheme = 'wss://';
var uri    = scheme + window.document.location.host + '/ws';
var ws     = new WebSocket(uri);


ws.onmessage = function(message) {
  var content = JSON.parse(message.data);
  var date = new Date();
  var elem = document.getElementById('log');
  elem.insertAdjacentText('afterbegin', date.toString() + ' :: ' + JSON.stringify(content) + "\n");
};

