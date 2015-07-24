/*global $, window, document*/

(function () {
  "use strict";

  $("form.confirmable").submit(function (ev) {
    if (!window.confirm('Are you sure?')) {
      ev.preventDefault();
    }
  });

}());
