var scheme = 'wss://';
var uri    = scheme + window.document.location.host + '/ws';
var ws     = new WebSocket(uri);


ws.onmessage = function(message) {
  var content = JSON.parse(message.data);
  var elem = document.getElementById('log');
  elem.insertAdjacentText('afterbegin', content);
};

