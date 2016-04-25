/*global $, window, document*/

(function () {
  "use strict";

  var NOW = new Date();

  $(document.body).bind("keyup", function (event) {
    if (event.target.localName !== "body") { return; }
    if (event.altKey || event.ctrlKey || event.metaKey || event.shiftKey) { return; }

    switch(event.keyCode) {
      case 81: //q
        $(".map button[data-direction=nw]").trigger("click");
        break;
      case 87: //w
        $(".map button[data-direction=n]").trigger("click");
        break;
      case 75: //k (vim-style!)
        $(".map button[data-direction=n]").trigger("click");
        break;
      case 69: //e
        $(".map button[data-direction=ne]").trigger("click");
        break;
      case 65: //a
        $(".map button[data-direction=w]").trigger("click");
        break;
      case 72: //h (vim-style!)
        $(".map button[data-direction=w]").trigger("click");
        break;
      case 68: //d
        $(".map button[data-direction=e]").trigger("click");
        break;
      case 76: //l (vim-style!)
        $(".map button[data-direction=e]").trigger("click");
        break;
      case 90: //z
        $(".map button[data-direction=sw]").trigger("click");
        break;
      case 83: //s
        $(".map button[data-direction=s]").trigger("click");
        break;
      case 88: //x
        $(".map button[data-direction=s]").trigger("click");
        break;
      case 74: //j (vim-style!)
        $(".map button[data-direction=s]").trigger("click");
        break;
      case 67: //c
        $(".map button[data-direction=se]").trigger("click");
        break;
      case 70: //f
        $(".map button[data-direction=enterexit]").trigger("click");
        break;
    }
  });

  var persistedSelections = {};

  if (window.sessionStorage) {
    persistedSelections = JSON.parse(window.sessionStorage.getItem("shintolin_selections") || "{}");
  }

  window.hydratePersistedSelections = function () {
    for (var key in persistedSelections) {
      var $select = $("select[data-persist=" + key + "]");
      if (key && key.length && key !== "undefined") {
        var targetValue = persistedSelections[key],
          hydrate = false;

        /*eslint-disable no-loop-func*/
        $select.children("option").each(function () {
          if ($(this).val() === targetValue) {
            hydrate = true;
          }
        });
        /*eslint-enable no-loop-func*/

        if (hydrate) {
          $select.val(targetValue);
        }
      }
    }
  };
  window.hydratePersistedSelections();

  $("form").submit(function () {
    var $form = $(this);
    var selectBoxes = $form.find("select");
    selectBoxes.each(function () {
      var $select = $(this);
      var $selected = $select.children("option:selected");
      persistedSelections[$select.data("persist")] = $selected.val();
    });
    if (window.sessionStorage) {
      window.sessionStorage.setItem("shintolin_selections", JSON.stringify(persistedSelections));
    }
  });

  $(function () {
    $("[data-toggle=\"tooltip\"]").tooltip({
      html: true,
      trigger: "hover",
      animate: true
    });
  });

  var actionTabSelected = $.cookie("action_tab_selected");
  if (actionTabSelected) {
    $("a[href='" + actionTabSelected + "']").tab("show");
  }
  $(".actions a[data-toggle='tab']").on("shown.bs.tab", function (e) {
    $.cookie("action_tab_selected", e.target.hash);
  });

  $("form.confirmable").submit(function (ev) {
    if (!window.confirm('Are you sure?')) {
      ev.preventDefault();
    }
  });

  (function () {
    var $clock = $('.dazed-countdown');
    if (!$clock.length) {
      return;
    }

    var ms = $clock.data('timestamp');
    var future = new Date(ms);
    var diff = (future.getTime() - NOW.getTime()) / 1000;

    var clock = $clock.FlipClock(diff, {
      countdown: true,
      callbacks: {
        interval: function () {
          if (new Date() >= future) {
            window.href = window.href; // refresh
          }
        }
      }
    });
  }());


}());
