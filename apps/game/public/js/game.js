/*global $, window, document*/

(function () {
  "use strict";

  $(document.body).bind("keyup", function (event) {
    if (event.srcElement.localName !== "body") { return; }
    if (event.altKey || event.ctrlKey || event.metaKey || event.shiftKey) { return; }

    switch(event.keyCode) {
      case 81: //q
        $(".movebutton[data-direction=nw]").trigger("click");
        break;
      case 87: //w
        $(".movebutton[data-direction=n]").trigger("click");
        break;
      case 75: //k (vim-style!)
        $(".movebutton[data-direction=n]").trigger("click");
        break;
      case 69: //e
        $(".movebutton[data-direction=ne]").trigger("click");
        break;
      case 65: //a
        $(".movebutton[data-direction=w]").trigger("click");
        break;
      case 72: //h (vim-style!)
        $(".movebutton[data-direction=w]").trigger("click");
        break;
      case 68: //d
        $(".movebutton[data-direction=e]").trigger("click");
        break;
      case 76: //l (vim-style!)
        $(".movebutton[data-direction=e]").trigger("click");
        break;
      case 90: //z
        $(".movebutton[data-direction=sw]").trigger("click");
        break;
      case 83: //s
        $(".movebutton[data-direction=s]").trigger("click");
        break;
      case 88: //x
        $(".movebutton[data-direction=s]").trigger("click");
        break;
      case 74: //j (vim-style!)
        $(".movebutton[data-direction=s]").trigger("click");
        break;
      case 67: //c
        $(".movebutton[data-direction=se]").trigger("click");
        break;
      case 70: //f
        $(".movebutton[data-direction=enterexit]").trigger("click");
        break;
      case 80: //P
        if (event.shiftKey) {
          $("[data-action-focus=paint]").focus();
        } else {
          $("input[data-action=paint]").trigger("click");
        }
        break;
      case 85: //U
        if (event.shiftKey) {
          $("[data-action-focus=use]").focus();
        } else {
          $("input[data-action=use]").trigger("click");
        }
        break;
      case 75: //K
        if (event.shiftKey) {
          $("[data-action-focus=attack]").focus();
        } else {
          $("input[data-action=attack]").trigger("click");
        }
        break;
      case 76: //L
        $("input[data-action=search]").trigger("click");
        break;
    }
  });

  $.cookie.json = true;

  var persistedSelections = $.cookie("persisted_selections") || {};

  window.hydratePersistedSelections = function () {
    for (var key in persistedSelections) {
      if (key && key.length && key !== "undefined") {
        $("select[data-persist=#{key}]").val(persistedSelections[key]);
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
    $.cookie("persisted_selections", persistedSelections);
  });

}());
