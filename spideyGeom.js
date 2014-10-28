// Generated by CoffeeScript 1.7.1
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

this.spideyGeom = (function() {
  function spideyGeom() {
    this.stepFn = __bind(this.stepFn, this);
  }

  spideyGeom.prototype.ledInterval = 6.9;

  spideyGeom.prototype.steps = 0;

  spideyGeom.prototype.ledUISize = 3;

  spideyGeom.prototype.padInfo = [
    {
      chainIdx: 780,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 47,
      anticlockwise: true
    }, {
      chainIdx: 540,
      startPos: 0.35,
      endPos: 0.99,
      hiddenLeds: 0,
      anticlockwise: true
    }, {
      chainIdx: 878,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 17,
      anticlockwise: true
    }, {
      chainIdx: 1180,
      startPos: 0,
      endPos: 0.71,
      hiddenLeds: 0,
      anticlockwise: true
    }, {
      chainIdx: 1086,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 9,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 7,
      anticlockwise: true
    }, {
      chainIdx: 678,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 42,
      anticlockwise: true
    }, {
      chainIdx: 1260,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 34,
      anticlockwise: true
    }, {
      chainIdx: 628,
      startPos: 0,
      endPos: -1,
      hiddenLeds: -32,
      anticlockwise: true
    }, {
      chainIdx: 222,
      startPos: 0,
      endPos: -1,
      hiddenLeds: -7,
      anticlockwise: true
    }, {
      chainIdx: 276,
      startPos: 0,
      endPos: -1,
      hiddenLeds: -27,
      anticlockwise: true
    }, {
      chainIdx: 1414,
      startPos: 0,
      endPos: -0.98,
      hiddenLeds: 30,
      anticlockwise: true
    }, {
      chainIdx: 174,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 37,
      anticlockwise: true
    }, {
      chainIdx: 579,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 36,
      anticlockwise: true
    }, {
      chainIdx: 1134,
      startPos: 0,
      endPos: -0.99,
      hiddenLeds: 10,
      anticlockwise: true
    }, {
      chainIdx: 323,
      startPos: 0.36,
      endPos: 0.98,
      hiddenLeds: 0,
      anticlockwise: true
    }, {
      chainIdx: 386,
      startPos: 0,
      endPos: -1,
      hiddenLeds: -38,
      anticlockwise: true
    }, {
      chainIdx: 431,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 13,
      anticlockwise: true
    }, {
      chainIdx: 1524,
      startPos: 0,
      endPos: -0.98,
      hiddenLeds: 27,
      anticlockwise: true
    }, {
      chainIdx: 1556,
      startPos: 0,
      endPos: -0.96,
      hiddenLeds: 32,
      anticlockwise: true
    }, {
      chainIdx: 94,
      startPos: 0,
      endPos: -1,
      hiddenLeds: -26,
      anticlockwise: true
    }, {
      chainIdx: 132,
      startPos: 0,
      endPos: -1,
      hiddenLeds: -5,
      anticlockwise: true
    }, {
      chainIdx: 1609,
      startPos: 0.2,
      endPos: 1.0,
      hiddenLeds: 0,
      anticlockwise: false
    }, {
      chainIdx: 1472,
      startPos: 0.34,
      endPos: 0.98,
      hiddenLeds: 0,
      anticlockwise: false
    }, {
      chainIdx: 348,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 8,
      anticlockwise: true
    }, {
      chainIdx: 1590,
      startPos: 0.02,
      endPos: 0.49,
      hiddenLeds: 0,
      anticlockwise: true
    }, {
      chainIdx: 1637,
      startPos: 0.25,
      endPos: 1.0,
      hiddenLeds: 0,
      anticlockwise: false
    }, {
      chainIdx: 1304,
      startPos: 0.01,
      endPos: 0.70,
      hiddenLeds: 0,
      anticlockwise: true
    }, {
      chainIdx: 308,
      startPos: 0.01,
      endPos: 0.51,
      hiddenLeds: 14,
      anticlockwise: true
    }, {
      chainIdx: 466,
      startPos: 0.01,
      endPos: 0.64,
      hiddenLeds: 0,
      anticlockwise: true
    }, {
      chainIdx: 1665,
      startPos: 0.02,
      endPos: 0.55,
      hiddenLeds: 0,
      anticlockwise: true
    }, {
      chainIdx: 1498,
      startPos: 0.37,
      endPos: 1.00,
      hiddenLeds: 0,
      anticlockwise: false
    }, {
      chainIdx: 1448,
      startPos: 0.35,
      endPos: 0.96,
      hiddenLeds: 0,
      anticlockwise: false
    }, {
      chainIdx: 732,
      startPos: 0,
      endPos: -0.98,
      hiddenLeds: 34,
      anticlockwise: true
    }, {
      chainIdx: 1346,
      startPos: 0.37,
      endPos: 0.98,
      hiddenLeds: 0,
      anticlockwise: false
    }, {
      chainIdx: 1220,
      startPos: 0.01,
      endPos: 0.72,
      hiddenLeds: 0,
      anticlockwise: true
    }, {
      chainIdx: 1376,
      startPos: 0,
      endPos: -1,
      hiddenLeds: -27,
      anticlockwise: true
    }, {
      chainIdx: 56,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 30,
      anticlockwise: true
    }, {
      chainIdx: 516,
      startPos: 0.01,
      endPos: 0.55,
      hiddenLeds: 0,
      anticlockwise: true
    }, {
      chainIdx: 836,
      startPos: 0.02,
      endPos: 0.68,
      hiddenLeds: 0,
      anticlockwise: true
    }, {
      chainIdx: 1040,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 39,
      anticlockwise: true
    }, {
      chainIdx: 1000,
      startPos: 0.01,
      endPos: 0.75,
      hiddenLeds: 0,
      anticlockwise: true
    }, {
      chainIdx: 934,
      startPos: 0.03,
      endPos: 0.78,
      hiddenLeds: 0,
      anticlockwise: true
    }, {
      chainIdx: 974,
      startPos: 0.2,
      endPos: 0.69,
      hiddenLeds: 0,
      anticlockwise: true
    }, {
      chainIdx: 490,
      startPos: 0.01,
      endPos: 0.67,
      hiddenLeds: 0,
      anticlockwise: true
    }
  ];

  spideyGeom.prototype.init = function() {
    var ledCount, padLedsData, pad_centers, svg, text, _i, _j, _len, _len1, _ref, _ref1;
    this.spideyAnim = new SpideyAnimation();
    this.spideyGraph = new SpideyGraph();
    svg = d3.select("#spideyGeom svg");
    this.padOutlines = svg.selectAll("path");
    pad_centers = this.padOutlines[0].map(function(d, padIdx) {
      var bbox;
      bbox = d.getBBox();
      return [bbox.x + bbox.width / 2, bbox.y + bbox.height / 2, padIdx];
    });
    this.padLedsList = this.padOutlines[0].map((function(_this) {
      return function(d, padIdx) {
        var chainIdx, intv, ledIdx, ledOffset, ledReversed, leds, numLeds, pDist, pPos, pathLen, pathStart, stripLen, wrapRound;
        pathLen = d.getTotalLength();
        wrapRound = _this.padInfo[padIdx].endPos < 0;
        stripLen = pathLen * Math.abs(_this.padInfo[padIdx].endPos - _this.padInfo[padIdx].startPos);
        intv = _this.ledInterval;
        pathStart = pathLen * _this.padInfo[padIdx].startPos;
        if (_this.padInfo[padIdx].anticlockwise) {
          intv = -_this.ledInterval;
          pathStart = pathLen * (1 - _this.padInfo[padIdx].startPos);
        }
        numLeds = Math.floor((stripLen / _this.ledInterval) + 0.5);
        leds = [];
        pPos = pathStart;
        pDist = 0;
        ledIdx = 0;
        ledOffset = Math.abs(_this.padInfo[padIdx].hiddenLeds);
        ledReversed = _this.padInfo[padIdx].hiddenLeds < 0;
        while (true) {
          if (pDist >= stripLen - (_this.ledInterval / 2)) {
            break;
          }
          chainIdx = _this.padInfo[padIdx].chainIdx + (2 * numLeds + (ledReversed ? -ledIdx : ledIdx) - ledOffset) % numLeds;
          leds.push({
            pt: d.getPointAtLength(pPos),
            padIdx: padIdx,
            ledIdx: ledIdx,
            clr: "#d4d4d4",
            chainIdx: chainIdx
          });
          pDist += _this.ledInterval;
          pPos += intv;
          ledIdx++;
          if (wrapRound) {
            if (pPos > pathLen || pPos < 0) {
              pPos = pPos + (intv > 0 ? -pathLen : pathLen);
            }
          }
        }
        return leds;
      };
    })(this));
    ledCount = 0;
    _ref = this.padLedsList;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      padLedsData = _ref[_i];
      ledCount += padLedsData.length;
    }
    console.log("Total Leds = " + ledCount);
    _ref1 = this.padLedsList;
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      padLedsData = _ref1[_j];
      padLedsData[0].clr = "#000000";
    }
    this.padLeds = svg.selectAll("g.padLeds").data(this.padLedsList).enter().append("g").attr("class", "padLeds");
    this.ledsSel = this.padLeds.selectAll(".led").data(function(d, i) {
      return d;
    });
    this.ledsSel.enter().append("circle").attr("class", "led").attr("cx", function(d) {
      return d.pt.x;
    }).attr("cy", function(d) {
      return d.pt.y;
    }).attr("r", this.ledUISize).attr("fill", function(d, i) {
      return d.clr;
    });
    text = svg.selectAll("text").data(pad_centers).enter().append("text");
    text.attr("x", function(d) {
      return d[0] - 10;
    }).attr("y", function(d) {
      return d[1] + 8;
    }).text(function(d) {
      return d[2];
    }).attr("font-family", "sans-serif").attr("font-size", "20px").attr("fill", "#DCDCDC");
    this.spideyGraph.createGraph(this.padOutlines, this.padLedsList, this.ledsSel, svg);
    this.showDownloadJsonLink();
    this.spideyGraph.colourNodes();
    this.spideyGraph.displayEdges();
    this.spideyGraph.labelNodes();
    this.spideyGraph.animate();
    this.ledsSel.attr("fill", function(d) {
      return d.clr;
    });
  };

  spideyGeom.prototype.stepFn = function() {
    var ledData, padLedsData, _i, _j, _len, _len1, _ref;
    this.steps++;
    if (this.steps > 1000) {
      return true;
    }
    _ref = this.padLedsList;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      padLedsData = _ref[_i];
      for (_j = 0, _len1 = padLedsData.length; _j < _len1; _j++) {
        ledData = padLedsData[_j];
        ledData.clr = this.spideyAnim.getColour(ledData.pt.x, ledData.pt.y, ledData.padIdx, ledData.ledIdx, this.steps);
      }
    }
    this.ledsSel.attr("fill", function(d) {
      return d.clr;
    });
    return false;
  };

  spideyGeom.prototype.getNodeExportInfo = function(node) {
    var nodeLed, rtnData;
    rtnData = {
      center: node.CofG,
      nodeDegree: node.nodeDegree,
      name: node.nodeId,
      LEDs: (function() {
        var _i, _len, _ref, _results;
        _ref = node.leds;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          nodeLed = _ref[_i];
          _results.push({
            chainIdx: nodeLed.led.chainIdx
          });
        }
        return _results;
      })()
    };
    return rtnData;
  };

  spideyGeom.prototype.getLinkExportInfo = function() {
    var edgeTo, node, oneLink, rtnData, _i, _j, _len, _len1, _ref, _ref1;
    rtnData = [];
    _ref = this.spideyGraph.nodeList;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      node = _ref[_i];
      _ref1 = node.edgesTo;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        edgeTo = _ref1[_j];
        oneLink = {
          source: node.nodeId,
          target: edgeTo.toNodeIdx,
          length: edgeTo.edgeLength,
          edgeId: edgeTo.edgeIdx
        };
        rtnData.push(oneLink);
      }
    }
    return rtnData;
  };

  spideyGeom.prototype.getEdgeExportInfo = function() {
    return this.spideyGraph.edgeList;
  };

  spideyGeom.prototype.getLedsExportInfo = function() {
    return this.padLedsList;
  };

  spideyGeom.prototype.showDownloadJsonLink = function() {
    var spideyGeomJson, spideyGeomToExport;
    spideyGeomToExport = {
      LEDs: this.getLedsExportInfo()
    };
    spideyGeomJson = "text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(spideyGeomToExport));
    return $('<a href="data:' + spideyGeomJson + '" download="SpideyGeometry.json">Download Spidey JSON</a>').appendTo('#downloadSpideyJson');
  };

  return spideyGeom;

})();
