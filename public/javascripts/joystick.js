var makeJoystick = function(selector, sqhw, done) {
  if (typeof(done) !== 'function') {
    done = function(){};
  }

  var container = $(selector);
  var stick = $('<div class="joystick-base"></div>');
  var circle = $('<div class="joystick-point"></div>');

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
    start: null,
    containment: "parent",
    drag: function() {
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

      console.log(x, y);

      var theta = (Math.atan(y / x) || 0) * (180 / Math.PI);

      if (x === 0 && y === 0) {
        return done(0, 0, 0, 0);
      }

      if (x > 0) {
        if (y <= 0) {
          theta += 360;
        }
      } else if (x < 0) {
        theta += 180;
      }

      var magnitude = Math.sqrt((Math.pow(x, 2) + Math.pow(y, 2)));

      if (magnitude > sqhw / 2) {
        magnitude = sqhw / 2;
      }

      done(magnitude, theta, x, y);
    },
    stop: function() {
      this.style.top = 'calc( 50% - ' + ((sqhw / 4) + 1) + 'px )';
      this.style.left = 'calc( 50% - ' + ((sqhw / 4) + 1) + 'px )';

      done(0, 0, 0, 0);
    }
  });
};


