var scheme = 'wss://';
var uri    = scheme + window.document.location.host + '/ws';
var ws     = new WebSocket(uri);


ws.onmessage = function(message) {
  console.log(message);
};

