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
      chainIdx: 276,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0.32,
      endPos: 0.99,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0.01,
      endPos: 0.7,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 7,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 5,
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
      chainIdx: 0,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 174,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 36,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 323,
      startPos: 0.36,
      endPos: 0.98,
      hiddenLeds: 0,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 338,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 5,
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
      chainIdx: 0,
      startPos: 0.2,
      endPos: 1.0,
      hiddenLeds: 5,
      anticlockwise: false
    }, {
      chainIdx: 0,
      startPos: 0.34,
      endPos: 0.99,
      hiddenLeds: 5,
      anticlockwise: false
    }, {
      chainIdx: 0,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0.02,
      endPos: 0.49,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0.27,
      endPos: 1.0,
      hiddenLeds: 5,
      anticlockwise: false
    }, {
      chainIdx: 0,
      startPos: 0.01,
      endPos: 0.69,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 308,
      startPos: 0.01,
      endPos: 0.51,
      hiddenLeds: 14,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0.01,
      endPos: 0.62,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0.02,
      endPos: 0.55,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0.38,
      endPos: 0.99,
      hiddenLeds: 5,
      anticlockwise: false
    }, {
      chainIdx: 0,
      startPos: 0.33,
      endPos: 0.98,
      hiddenLeds: 5,
      anticlockwise: false
    }, {
      chainIdx: 0,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0.37,
      endPos: 0.98,
      hiddenLeds: 5,
      anticlockwise: false
    }, {
      chainIdx: 0,
      startPos: 0.01,
      endPos: 0.7,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 56,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 30,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0.01,
      endPos: 0.55,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0.01,
      endPos: 0.68,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0,
      endPos: -1,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0.01,
      endPos: 0.7,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0.01,
      endPos: 0.76,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0.2,
      endPos: 0.67,
      hiddenLeds: 5,
      anticlockwise: true
    }, {
      chainIdx: 0,
      startPos: 0.01,
      endPos: 0.65,
      hiddenLeds: 5,
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
        wrapRound = _this.padInfo[padIdx].endPos === -1;
        stripLen = wrapRound ? pathLen : pathLen * (_this.padInfo[padIdx].endPos - _this.padInfo[padIdx].startPos);
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
    this.spideyGraph.colourNodes();
    this.spideyGraph.displayEdges();
    this.spideyGraph.labelNodes();
    this.spideyGraph.enableMouseMove("leds");
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

  return spideyGeom;

})();
