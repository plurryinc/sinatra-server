var makeJoystick = function(selector, sqhw) {
  //websocket tire controller

  var product_code     = $(selector).data('code');

  var vec = Object.seal({
    left: 0,
    right: 0
  });

  var websocketInterval = null;
  var websocketDelay = 500;
  var container = $(selector);
  var stick = $('<div class="joystick-base"></div>');
  var circle = $('<div class="joystick-point"></div>');

  this.setWebSocketDelay = function(delay) {
    websocketDelay = delay;
  };

  container.css('width', sqhw + 'px');
  container.css('height', sqhw + 'px');
  container.css('border-radius', (sqhw / 2) + 'px');

  stick.css('width', (sqhw / 3) + 'px');
  stick.css('height', (sqhw / 3) + 'px');
  stick.css('top', 'calc( 50% - ' + ((sqhw / 6) + 1) + 'px )');
  stick.css('left', 'calc( 50% - ' + ((sqhw / 6) + 1) + 'px )');
  stick.css('border-radius', sqhw / 4 + 'px');

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
      var x = parseInt(this.style.left.substr(0, this.style.left.length - 2), 10) + sqhw / 6;
      var y = parseInt(this.style.top.substr(0, this.style.top.length - 2), 10) + sqhw / 6;

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

      var magnitude = Math.sqrt((Math.pow(x, 2) + Math.pow(y, 2)));

      if (magnitude > sqhw / 2) {
        magnitude = sqhw / 2;
      }
      var theta = (Math.atan(y / x) || 0) * (180 / Math.PI);

      if (x === 0 && y === 0) {
        theta = 0;
      }

      if (x > 0) {
        if (y <= 0) {
          theta += 360;
        }
      } else if (x < 0) {
        theta += 180;
      }
      theta = parseInt(theta);
      var msq = sqhw / 3;
      if(theta >= 330 || theta < 30 ) {
        if(x > (msq / 2)) {
          vec.left = 255;
          vec.right = -255;
        } else {
          vec.left = 0;
          vec.right = 0;
        }
      } else if( theta >= 30 && theta < 150 ) {
        plusX = parseInt(Math.abs(75 * (x / msq).toFixed(2))) * -1;
        plusY = parseInt(75 * (y / msq).toFixed(2));
        if( x > 0 ) {
          vec.left = 180 + plusY + plusX
          vec.right = 180 + plusY
        } else {
          vec.left = 180 + plusY
          vec.right = 180 + plusY + plusX
        }
      } else if( theta >= 150 && theta < 210 ) {
        if(Math.abs(x) > (msq / 2)) {
          vec.left = -255;
          vec.right = 255;
        } else {
          vec.left = 0;
          vec.right = 0;
        }
      } else if( theta >= 210 && theta < 330 ) {
        plusX = parseInt(Math.abs(75 * (x / msq).toFixed(2)));
        plusY = parseInt(75 * (y / msq).toFixed(2));
        if( x > 0 ) {
          vec.left = -180 + plusY + plusX
          vec.right = -180 + plusY
        } else {
          vec.left = -180 + plusY
          vec.right = -180 + plusY + plusX
        }
      } else {
        vec.left = 0;
        vec.right = 0;
        console.log("else")
      }
      console.log(vec.left + "////" + vec.right);
      /*
      if(theta >= 315 || theta < 45 ) {
        if(x > (msq / 2)) {
          if( theta > 315 ) {
            vec.left = 255;
            vec.right = 0;
          } else if(theta < 45) {
            theta * 3
          }
        } else {
          vec.left = 0;
          vec.right = 180;
        }
      } else if( theta >= 45 && theta < 135 ) {
        if(y > (msq / 2)) {
          vec.left = 255;
          vec.right = 255;
        } else {
          vec.left = 180;
          vec.right = 180;
        }
      } else if( theta >= 135 && theta < 225 ) {
        if(Math.abs(x) > (msq / 2)) {
          vec.left = 0;
          vec.right = 255;
        } else {
          vec.left = 255;
          vec.right = 0;
        }
      } else if( theta >= 225 && theta < 315 ) {
        if(Math.abs(y) > (msq / 2)) {
          vec.left = 255;
          vec.right = 255;
        } else {
          vec.left = 180;
          vec.right = 180;
        }
      } else {
        vec.left = 0;
        vec.right = 0;
        console.log("else")
      }
      */
    },
    stop: function() {
      clearInterval(websocketInterval);
      vec.left = 0;
      vec.right = 0;
      this.style.top = 'calc( 50% - ' + ((sqhw / 6) + 1) + 'px )';
      this.style.left = 'calc( 50% - ' + ((sqhw / 6) + 1) + 'px )';
      ws_2.send('{"cmd" : 8, "speed" : ' + vec.left + '}');
      ws_2.send('{"cmd" : 9, "speed" : ' + vec.right + '}');

      /*
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
      */

     /*
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

        vec.left = -255;
        vec.right = -120;
      }, websocketDelay);
      */
    }
  });
};


