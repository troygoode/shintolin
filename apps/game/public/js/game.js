/*global $, window, document*/

(function () {
  "use strict";

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

//       case 80: //P
//         if (!event.shiftKey) { break; }
//         $("button[data-action=paint]").trigger("click");
//         break;
//       case 85: //U
//         if (!event.shiftKey) { break; }
//         $("button[data-action=use]").trigger("click");
//         break;
//       case 75: //K
//         console.log(event);
//         if (!event.shiftKey) { break; }
//         $("button[data-action=attack]").trigger("click");
//         break;
//       case 76: //L
//         if (!event.shiftKey) { break; }
//         $("button[data-action=search]").trigger("click");
//         break;
    }
  });

  $.cookie.json = true;

  var persistedSelections = $.cookie("persisted_selections") || {};

  window.hydratePersistedSelections = function () {
    for (var key in persistedSelections) {
      if (key && key.length && key !== "undefined") {
        $("select[data-persist=" + key + "]").val(persistedSelections[key]);
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

  $(function () {
    $("[data-toggle=\"tooltip\"]").tooltip({html: true});
  });

  window.setTimeout(function () {
    var actionTabSelected = $.cookie("action_tab_selected");
    if (actionTabSelected) {
      $("a[href='" + actionTabSelected + "']").tab("show");
    }
    $(".actions").removeClass("hidden");
  }, 0);
  $(".actions a[data-toggle='tab']").on("shown.bs.tab", function (e) {
    $.cookie("action_tab_selected", e.target.hash);
  });

}());
