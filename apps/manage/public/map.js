/*global window, $, _*/
(function(){
  "use strict";

  var terrainLookup,
    tileLookup;

  var constructTerrainLookup = function(terrains){
    var retval = {};
    $.each(terrains, function(){
      retval[this.id] = this;
    });
    return retval;
  };

  var generateKey = function(tile){
    return tile.x + "x" + tile.y;
  };

  var findBoundaries = function(tiles){
    var xs = _.pluck(tiles, "x").map(function (n) { return parseInt(n); });
    var ys = _.pluck(tiles, "y").map(function (n) { return parseInt(n); });
    return {
      left: parseInt(_.min(xs)),
      right: parseInt(_.max(xs)),
      top: parseInt(_.min(ys)),
      bottom: parseInt(_.max(ys))
    };
  };

  var constructTileLookup = function(tiles){
    var retval = {};
    $.each(tiles, function(){
      retval[generateKey(this)] = this;
    });
    return retval;
  };

  var updateTileCell = function ($td, key, tile) {
    $td.removeClass();
    $td.addClass("tile");

    var terrain = terrainLookup[tile.terrain];
    if (terrain) {
      $td.addClass("tile-" + terrain.style);
    } else {
      $td.addClass("tile-" + terrainLookup[window.defaultTerrain].style);
    }
    if(tile.settlement_id && tile.settlement_id.length){
      $td.addClass("settlement-" + tile.settlement_id);
    }
    if(tile.region && tile.region.length){
      $td.addClass("region-" + tile.region);
    }else if(tile.terrain !== window.defaultTerrain){
      $td.addClass("region-none");
    }

    $td.data("x", tile.x);
    $td.data("y", tile.y);
    $td.data("z", tile.z);
    $td.data("terrain", tile.terrain);
    $td.attr("title", key);
  };

  var constructMapTable = function(terrains, cb){
    return function(tiles){
      var bounds = findBoundaries(tiles);
      var $map = $("#map");
      var $table = $("<table></table>");
      terrainLookup = constructTerrainLookup(terrains);
      tileLookup = constructTileLookup(tiles);
      for(var y = bounds.top - 1; y <= bounds.bottom + 1; y++){
        var $tr = $("<tr></tr>");
        for(var x = bounds.left - 1; x <= bounds.right + 1; x++){
          var key = generateKey({x: x, y: y});
          var tile = tileLookup[key] || {x: x, y: y, terrain: window.defaultTerrain};
          var $td = $("<td></td>");
          $td.attr("id", key);
          updateTileCell($td, key, tile);
          $tr.append($td);
        }
        $table.append($tr);
      }
      $map.empty().append($table);
      cb();
    };
  };

  var constructSettlements = function(settlements){
    var $settlements = $("#settlements");
    var $ul = $("<ul></ul>");
    $.each(settlements, function(){
      var settlement = this;

      var $li = $("<li></li>");
      $li.attr("id", settlement._id);
      $li.text(settlement.name);
      $li.mouseover(function(){
        $(".settlement-" + settlement._id).addClass("highlight");
      });
      $li.mouseout(function(){
        $("#map td").removeClass("highlight");
      });
      $ul.append($li);
    });
    $settlements.append($ul);
  };

  var constructRegions = function(regions){
    var $region = $("#region").empty().append($("<option></option>"));
    $.each(regions, function(){
      var $option = $("<option></option>");
      $option.attr("value", this.id);
      $option.text(this.name);
      $region.append($option);
    });

    regions.unshift({
      id: "none",
      name: "NONE"
    });

    var $regions = $("#regions");
    var $ul = $("<ul></ul>");
    $.each(regions, function(){
      var region = this;

      var $li = $("<li></li>");
      $li.attr("id", region.id);
      $li.text(region.name);
      $li.mouseover(function(){
        $(".region-" + region.id).addClass("highlight");
      });
      $li.mouseout(function(){
        $("#map td").removeClass("highlight");
      });
      $ul.append($li);
    });
    $regions.append($ul);
  };

  var constructTerrains = function(terrains){
    var $terrain = $("#terrain").empty().append($("<option></option>"));
    $.each(terrains, function(){
      if(this.hidden){
        return;
      }
      var $option = $("<option></option>");
      $option.text(this.id);
      $terrain.append($option);
    });
  };

  function resize() {
    var width = $("#td-map").width(),
      height = $("#td-map").height();
    $("#map").width(width - 8).height(height - 8);
  }

  var refresh = null;

  $(function(){

    resize();
    $(window).resize(function () {
      $("#map").width(480).height(360);
      resize();
    });

    $("#map").on("click", "td.tile", function () {
      $("#paint input[name=x]").val($(this).data("x"));
      $("#paint input[name=y]").val($(this).data("y"));
      $("#paint").submit();
    });

    $("#paint").submit(function (ev) {
      ev.preventDefault();

      var data = {
        x: parseInt($("#paint input[name=x]").val()),
        y: parseInt($("#paint input[name=y]").val()),
        terrain: $("#paint select[name=terrain]").val(),
        region: $("#paint select[name=region]").val()
      };
      $.ajax({
        type: "POST",
        url: "/manage/api/map",
        data: data,
        success: function () {
          var key = generateKey({x: data.x, y: data.y}),
            $td = $("#" + key),
            tile = tileLookup[key] || {x: data.x, y: data.y, terrain: window.defaultTerrain};
          tile.terrain = (data.terrain && data.terrain.length) ? data.terrain : (tile.terrain || window.defaultTerrain);
          tile.region = (data.region && data.region.length) ? data.region : tile.region;
          updateTileCell($td, key, tile);
        }
      });
    });

    $.ajax({
      url: "/manage/api/map/metadata",
      success: function(metadata){
        refresh = function (cb) {
          $.ajax({
            url: "/manage/api/map",
            success: constructMapTable(metadata.terrains, cb || function () {})
          });
        };
        refresh(function () {
          constructTerrains(metadata.terrains || []);
          constructSettlements(metadata.settlements || []);
          constructRegions(metadata.regions || []);
          window.hydratePersistedSelections();
        });
      }
    });

  });

})();
