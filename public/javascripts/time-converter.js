function stringToSecondTime(str) {
  if(str == "empty") return 0;
  var arr = str.split(':');
  var hours = parseInt(arr[0]) % 12;
  var minutes = parseInt(arr[1].split(' ')[0]);
  var meridian = arr[1].split(' ')[1];
  if( meridian == "PM" ) hours += 12;
  return (3600 * hours) + (minutes * 60);
}

function secondToStringTime(sec) {
  if(typeof(sec) != "number") return;
  if(sec == 0) return "empty"
  sec = sec - (sec % 60);
  var h = Math.floor(sec / 3600);
  var m = Math.floor(sec % 3600 / 60);
  var meridian = sec >= 3600 * 12 ? "PM" : "AM";
  if(meridian == "PM") {
    if(h == 24) {
      meridian = "AM";
    }else if(h > 12) {
      h -= 12;
    }
  }
  return ((h < 10 ? "0" : "") + (h > 0 ? h + ":" + (m < 10 ? "0" : "") : "") + m + " " + meridian );
}

function timeSort(arr) {
  arr = arr.sort(function(a,b) {
    time1 = stringToSecondTime(a.time) == 0 ? 100000 : stringToSecondTime(a.time);
    time2 = stringToSecondTime(b.time) == 0 ? 100000 : stringToSecondTime(b.time);
    return parseFloat(time1) - parseFloat(time2);
  });
  return arr;
}
