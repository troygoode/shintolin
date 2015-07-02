/*global window, $, _*/
(function(){
  "use strict";

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

  var constructMapTable = function(terrains, cb){
    return function(tiles){
      var bounds = findBoundaries(tiles);
      var terrainLookup = constructTerrainLookup(terrains);
      var tileLookup = constructTileLookup(tiles);
      var $map = $("#map");
      var $table = $("<table></table>");
      for(var y = bounds.top - 1; y <= bounds.bottom + 1; y++){
        var $tr = $("<tr></tr>");
        for(var x = bounds.left - 1; x <= bounds.right + 1; x++){
          var key = generateKey({x: x, y: y});
          var tile = tileLookup[key];
          var terrain = tile && terrainLookup[tile.terrain];
          if(!tile){
            tile = {x: x, y: y, terrain: window.defaultTerrain};
          }
          var $td = $("<td></td>");
          if (terrain) {
            $td.addClass("tile-" + terrain.style);
          } else {
            $td.addClass("tile-" + terrainLookup.nothing.style);
          }
          if(tile.settlement_id && tile.settlement_id.length){
            $td.addClass("settlement-" + tile.settlement_id);
          }
          if(tile.region && tile.region.length){
            $td.addClass("region-" + tile.region);
          }else if(tile.terrain !== window.defaultTerrain){
            $td.addClass("region-none");
          }

          $td.attr("id", key);
          $td.data("x", tile.x);
          $td.data("y", tile.y);
          $td.data("z", tile.z);
          $td.data("terrain", tile.terrain);
          $td.attr("title", key);

          $td.click(function () {
            $("#paint input[name=x]").val($(this).data("x"));
            $("#paint input[name=y]").val($(this).data("y"));
            $("#paint").submit();
          });
          $tr.append($td);
        }
        $table.append($tr);
      }
      $map.append($table);
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

  $(function(){
    $.ajax({
      url: "/manage/api/map/metadata",
      success: function(metadata){
        $.ajax({
          url: "/manage/api/map",
          success: constructMapTable(metadata.terrains, function(){
            constructTerrains(metadata.terrains || []);
            constructSettlements(metadata.settlements || []);
            constructRegions(metadata.regions || []);
            window.hydratePersistedSelections();
          })
        });
      }
    });
  });

})();
