

$(document).ready(function() {
  var scheme = 'wss://';
  var uri    = scheme + window.document.location.host + '/ws';
  var ws     = new WebSocket(uri);

  ws.onmessage = function(message) {
    var content = JSON.parse(message.data);
    console.log(content);
    var date = new Date();
    var elem = document.getElementById('log');
    elem.insertAdjacentText('afterbegin', date.toString() + ' :: ' + JSON.stringify(content) + "\n");
  };

  $('#buy-custom-amount').click(function() {
    var amount = document.getElementById('custom-amount').value;
    $.ajax({
      type: 'POST',
      url: '/paddle-custom-checkout',
      success: function(resp) {
        Paddle.Checkout.open({
          override: resp
        });
      },
      data: {amount: amount}
    });
  });
});
