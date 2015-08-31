var makeJoystick = function(selector, sqhw) {
  //websocket tire controller

  var product_code     = $(selector).data('code');

  var vec = Object.seal({
    left: 0,
    right: 0
  });

  var websocketInterval = null;
  var websocketDelay = 200;
  var container = $(selector);
  var stick = $('<div class="joystick-base"></div>');
  var circle = $('<div class="joystick-point"></div>');

  this.setWebSocketDelay = function(delay) {
    websocketDelay = delay;
  };

  container.css('width', sqhw + 'px');
  container.css('height', sqhw + 'px');
  container.css('border-radius', (sqhw / 2) + 'px');

  stick.css('width', (sqhw / 2) + 'px');
  stick.css('height', (sqhw / 2) + 'px');
  stick.css('top', 'calc( 50% - ' + ((sqhw / 4) + 1) + 'px )');
  stick.css('left', 'calc( 50% - ' + ((sqhw / 4) + 1) + 'px )');
  stick.css('border-radius', sqhw / 8 + 'px');

  container.append(circle);
  container.append(stick);

  stick.draggable({
    start: function() {
      clearInterval(websocketInterval);
      websocketInterval = setInterval(function() {
        ws_2.send('{"cmd" : 8, "speed" : ' + vec.left + '}');
        ws_2.send('{"cmd" : 9, "speed" : ' + vec.right + '}');
      }, websocketDelay);
    },
    containment: "parent",
    drag: function(event, ui) {
      $(this).stop();
      var x = parseInt(this.style.left.substr(0, this.style.left.length - 2), 10) + sqhw / 4;
      var y = parseInt(this.style.top.substr(0, this.style.top.length - 2), 10) + sqhw / 4;

      if (x > sqhw / 2) {
        x -= sqhw / 2;
      } else if (x < sqhw / 2) {
        x = - (sqhw / 2 - x);
      } else {
        x = 0;
      }

      if (y > sqhw / 2) {
        y -= sqhw / 2;
      } else if (y < sqhw / 2) {
        y = - (sqhw / 2 - y);
      } else {
        y = 0;
      }

      y *= -1;

      vec.left = y + x;
      vec.right = y - x;

    },
    stop: function() {
      var self = this;
      var top = ($(this).parent().height() / 2) - (sqhw / 4) + 1;
      var left = ($(this).parent().width() / 2) - (sqhw / 4) + 1;

      $(this).stop().animate({
        top: top,
        left: left
      }, 1000, function() {
        this.style.top = 'calc( 50% - ' + ((sqhw / 4) + 1) + 'px )';
        this.style.left = 'calc( 50% - ' + ((sqhw / 4) + 1) + 'px )';
        clearInterval(returnInterval);
        clearInterval(websocketInterval);
        vec.left = 0;
        vec.right = 0;
        ws_2.send('{"cmd" : 8, "speed" : ' + vec.left + '}');
        ws_2.send('{"cmd" : 9, "speed" : ' + vec.right + '}');
      });

      var returnInterval = setInterval(function() {
        var x = parseInt(self.style.left.substr(0, self.style.left.length - 2), 10) + sqhw / 4;
        var y = parseInt(self.style.top.substr(0, self.style.top.length - 2), 10) + sqhw / 4;

        if (x > sqhw / 2) {
          x -= sqhw / 2;
        } else if (x < sqhw / 2) {
          x = - (sqhw / 2 - x);
        } else {
          x = 0;
        }

        if (y > sqhw / 2) {
          y -= sqhw / 2;
        } else if (y < sqhw / 2) {
          y = - (sqhw / 2 - y);
        } else {
          y = 0;
        }

        y *= -1;

        vec.left = y + x;
        vec.right = y - x;
      }, websocketDelay);
    }
  });
};


