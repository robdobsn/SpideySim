// Generated by CoffeeScript 1.7.1
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

this.SpideyGraph = (function() {
  function SpideyGraph() {
    this.stepFn = __bind(this.stepFn, this);
  }

  SpideyGraph.prototype.padAdjacencies = [];

  SpideyGraph.prototype.maxDistForPadAdjacency = 300;

  SpideyGraph.prototype.maxDistForLedAdjacency = 10;

  SpideyGraph.prototype.maxDistForNodeDetect = 10;

  SpideyGraph.prototype.maxDistForNodeMerge = 10;

  SpideyGraph.prototype.minDistForEndNode = 20;

  SpideyGraph.prototype.maxDistForFirstAndLastLedsOnCircularPad = 30;

  SpideyGraph.prototype.genColours = function(numColours) {
    var colourList, colrStr, hslColour, i, _i, _ref;
    colourList = [];
    for (i = _i = 0, _ref = 360 / numColours; _i < 360; i = _i += _ref) {
      hslColour = d3.hsl((i * 1787) % 360, 0.90 + Math.random() * 0.10, 0.50 + Math.random() * 0.10);
      colrStr = hslColour.toString();
      colourList.push(colrStr);
    }
    return colourList;
  };

  SpideyGraph.prototype.dist = function(led1, led2) {
    var dx, dy;
    dx = led1.pt.x - led2.pt.x;
    dy = led1.pt.y - led2.pt.y;
    return Math.sqrt(dx * dx + dy * dy);
  };

  SpideyGraph.prototype.getCofGforLeds = function(ledList) {
    var ledId, xSum, ySum, _i, _len;
    xSum = 0;
    ySum = 0;
    for (_i = 0, _len = ledList.length; _i < _len; _i++) {
      ledId = ledList[_i];
      xSum += this.padLedsData[ledId[0]][ledId[1]].pt.x;
      ySum += this.padLedsData[ledId[0]][ledId[1]].pt.y;
    }
    return {
      pt: {
        x: xSum / ledList.length,
        y: ySum / ledList.length
      }
    };
  };

  SpideyGraph.prototype.createGraph = function(padOutlines, padLedsData, ledsSel, svg) {
    var adjFound, alreadInList, colrIdx, colrs, curCofG, curEdgeIdx, discardFree, distFromCofGtoLed, edge, edgeInfo, edgesSvg, freeLedList, freeLeds, freeNodeLeds, freeRationalisedList, fromNode, fullNode, fullNodeList, key, led, ledAdjList, ledDist, ledDistances, ledIdx, ledInfo, ledPadFound, ledUniqPads, ledsModified, ledsUsed, listMerged, newList, node, nodeAlreadyInList, nodeIdx, nodeInfo, nodeLabels, nodeLed, nodeLedList, nodeLeds, nodeLedsIdx, nodeRationalisedList, nodesSvg, oStr, otherLedDist, otherLedIdx, otherLedInfo, otherLedUse, otherNodeLed, otherNodeLedsIdx, otherPadIdx, otherPadLedsInfo, padAdjList, padCircuit, padIdx, padLedsInfo, testLedIdx, testNode, testNodeIdx, testNodeLeds, thisNode, val, _aa, _ab, _ac, _ad, _ae, _af, _ag, _ah, _ai, _aj, _ak, _al, _am, _an, _ao, _ap, _i, _j, _k, _l, _len, _len1, _len10, _len11, _len12, _len13, _len14, _len15, _len16, _len17, _len18, _len19, _len2, _len20, _len21, _len22, _len23, _len24, _len25, _len26, _len27, _len28, _len29, _len3, _len30, _len4, _len5, _len6, _len7, _len8, _len9, _m, _n, _o, _p, _q, _r, _ref, _ref1, _ref10, _ref11, _ref12, _ref13, _ref14, _ref15, _ref16, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9, _s, _t, _u, _v, _w, _x, _y, _z;
    this.padLedsData = padLedsData;
    this.ledsSel = ledsSel;
    for (padIdx = _i = 0, _len = padLedsData.length; _i < _len; padIdx = ++_i) {
      padLedsInfo = padLedsData[padIdx];
      this.padAdjacencies.push([]);
      for (otherPadIdx = _j = 0, _ref = padLedsData.length; 0 <= _ref ? _j < _ref : _j > _ref; otherPadIdx = 0 <= _ref ? ++_j : --_j) {
        if (padIdx === otherPadIdx) {
          continue;
        }
        otherPadLedsInfo = padLedsData[otherPadIdx];
        if (this.dist(padLedsInfo[0], otherPadLedsInfo[0]) > this.maxDistForPadAdjacency) {
          continue;
        }
        adjFound = false;
        for (ledIdx = _k = 0, _len1 = padLedsInfo.length; _k < _len1; ledIdx = ++_k) {
          ledInfo = padLedsInfo[ledIdx];
          if (this.dist(ledInfo, otherPadLedsInfo[0]) > this.maxDistForPadAdjacency) {
            continue;
          }
          for (otherLedIdx = _l = 0, _len2 = otherPadLedsInfo.length; _l < _len2; otherLedIdx = ++_l) {
            otherLedInfo = otherPadLedsInfo[otherLedIdx];
            if (this.dist(ledInfo, otherLedInfo) < this.maxDistForLedAdjacency) {
              adjFound = true;
              this.padAdjacencies[padIdx].push(otherPadIdx);
              break;
            }
          }
          if (adjFound) {
            break;
          }
        }
      }
    }
    nodeLedList = [];
    freeLedList = [];
    _ref1 = this.padAdjacencies;
    for (padIdx = _m = 0, _len3 = _ref1.length; _m < _len3; padIdx = ++_m) {
      padAdjList = _ref1[padIdx];
      _ref2 = padLedsData[padIdx];
      for (ledIdx = _n = 0, _len4 = _ref2.length; _n < _len4; ledIdx = ++_n) {
        ledInfo = _ref2[ledIdx];
        ledAdjList = [];
        ledUniqPads = [];
        for (_o = 0, _len5 = padAdjList.length; _o < _len5; _o++) {
          otherPadIdx = padAdjList[_o];
          ledPadFound = false;
          _ref3 = padLedsData[otherPadIdx];
          for (otherLedIdx = _p = 0, _len6 = _ref3.length; _p < _len6; otherLedIdx = ++_p) {
            otherLedInfo = _ref3[otherLedIdx];
            if (this.dist(ledInfo, otherLedInfo) < this.maxDistForNodeDetect) {
              if (ledAdjList.length === 0) {
                ledAdjList.push([padIdx, ledIdx]);
              }
              ledAdjList.push([otherPadIdx, otherLedIdx]);
              if (!ledPadFound) {
                if (__indexOf.call(ledUniqPads, otherPadIdx) < 0) {
                  ledUniqPads.push(otherPadIdx);
                }
                ledPadFound = true;
              }
            }
          }
        }
        if (ledUniqPads.length >= 2) {
          nodeAlreadyInList = false;
          for (_q = 0, _len7 = nodeLedList.length; _q < _len7; _q++) {
            nodeLeds = nodeLedList[_q];
            for (_r = 0, _len8 = nodeLeds.length; _r < _len8; _r++) {
              led = nodeLeds[_r];
              if (led[0] === padIdx) {
                if (led[1] === ledIdx) {
                  nodeAlreadyInList = true;
                  break;
                }
              }
            }
            if (nodeAlreadyInList) {
              break;
            }
          }
          if (!nodeAlreadyInList) {
            nodeLedList.push(ledAdjList);
            if (padIdx === 9) {
              for (_s = 0, _len9 = ledAdjList.length; _s < _len9; _s++) {
                led = ledAdjList[_s];
                console.log(led);
              }
              console.log("");
            }
          }
        } else {
          if (ledIdx === 0 || ledIdx === padLedsData[padIdx].length - 1) {
            freeLedList.push(ledAdjList);
          }
        }
      }
    }
    nodeRationalisedList = [];
    for (nodeLedsIdx = _t = 0, _len10 = nodeLedList.length; _t < _len10; nodeLedsIdx = ++_t) {
      nodeLeds = nodeLedList[nodeLedsIdx];
      curCofG = this.getCofGforLeds(nodeLeds);
      for (otherNodeLedsIdx = _u = _ref4 = nodeLedsIdx + 1, _ref5 = nodeLedList.length; _ref4 <= _ref5 ? _u < _ref5 : _u > _ref5; otherNodeLedsIdx = _ref4 <= _ref5 ? ++_u : --_u) {
        listMerged = false;
        if (this.dist(curCofG, this.getCofGforLeds(nodeLedList[otherNodeLedsIdx])) < this.maxDistForNodeMerge) {
          for (_v = 0, _len11 = nodeLeds.length; _v < _len11; _v++) {
            nodeLed = nodeLeds[_v];
            alreadInList = false;
            _ref6 = nodeLedList[otherNodeLedsIdx];
            for (_w = 0, _len12 = _ref6.length; _w < _len12; _w++) {
              otherNodeLed = _ref6[_w];
              if (nodeLed[0] === otherNodeLed[0] && nodeLed[1] === otherNodeLed[1]) {
                alreadInList = true;
              }
            }
            if (!alreadInList) {
              nodeLedList[otherNodeLedsIdx].push(nodeLed);
            }
          }
          listMerged = true;
          break;
        }
      }
      if (!listMerged) {
        nodeRationalisedList.push({
          leds: nodeLeds,
          CofG: this.getCofGforLeds(nodeLeds),
          nodeDegree: 2
        });
      }
    }
    for (_x = 0, _len13 = nodeRationalisedList.length; _x < _len13; _x++) {
      nodeInfo = nodeRationalisedList[_x];
      ledDistances = {};
      curCofG = nodeInfo.CofG;
      _ref7 = nodeInfo.leds;
      for (_y = 0, _len14 = _ref7.length; _y < _len14; _y++) {
        nodeLed = _ref7[_y];
        distFromCofGtoLed = this.dist(curCofG, this.padLedsData[nodeLed[0]][nodeLed[1]]);
        console.log(distFromCofGtoLed);
        if (nodeLed[0] in ledDistances) {
          if (ledDistances[nodeLed[0]].dist > distFromCofGtoLed) {
            ledDistances[nodeLed[0]].dist = distFromCofGtoLed;
            ledDistances[nodeLed[0]].padIdx = nodeLed[0];
            ledDistances[nodeLed[0]].ledIdx = nodeLed[1];
          }
        } else {
          ledDistances[nodeLed[0]] = {
            dist: distFromCofGtoLed,
            padIdx: nodeLed[0],
            ledIdx: nodeLed[1]
          };
        }
      }
      nodeInfo.leds = [];
      for (key in ledDistances) {
        val = ledDistances[key];
        nodeInfo.leds.push([val.padIdx, val.ledIdx]);
        console.log(val.padIdx, val.ledIdx);
      }
      nodeInfo.CofG = this.getCofGforLeds(nodeInfo.leds);
      console.log("");
    }
    ledsUsed = {};
    for (nodeIdx = _z = 0, _len15 = nodeRationalisedList.length; _z < _len15; nodeIdx = ++_z) {
      nodeInfo = nodeRationalisedList[nodeIdx];
      ledsModified = true;
      while (ledsModified) {
        ledsModified = false;
        _ref8 = nodeInfo.leds;
        for (_aa = 0, _len16 = _ref8.length; _aa < _len16; _aa++) {
          nodeLed = _ref8[_aa];
          if (nodeLed[0] * 1000 + nodeLed[1] in ledsUsed) {
            otherLedUse = ledsUsed[nodeLed[0] * 1000 + nodeLed[1]];
            if (otherLedUse.nodeIdx !== nodeIdx) {
              ledInfo = padLedsData[nodeLed[0]][nodeLed[1]];
              ledDist = this.dist(ledInfo, nodeRationalisedList[nodeIdx].CofG);
              otherLedDist = this.dist(ledInfo, nodeRationalisedList[otherLedUse.nodeIdx].CofG);
              if (ledDist < otherLedDist) {
                newList = [];
                _ref9 = nodeRationalisedList[otherLedUse.nodeIdx].leds;
                for (_ab = 0, _len17 = _ref9.length; _ab < _len17; _ab++) {
                  led = _ref9[_ab];
                  if (!(led[0] === nodeLed[0] && led[1] === nodeLed[1])) {
                    newList.push(led);
                  }
                }
                nodeRationalisedList[otherLedUse.nodeIdx].leds = newList;
                ledsUsed[nodeLed[0] * 1000 + nodeLed[1]] = {
                  nodeIdx: nodeIdx
                };
              } else {
                newList = [];
                _ref10 = nodeRationalisedList[nodeIdx].leds;
                for (_ac = 0, _len18 = _ref10.length; _ac < _len18; _ac++) {
                  led = _ref10[_ac];
                  if (!(led[0] === nodeLed[0] && led[1] === nodeLed[1])) {
                    newList.push(led);
                  }
                }
                nodeRationalisedList[nodeIdx].leds = newList;
              }
              ledsModified = true;
              break;
            }
          } else {
            ledsUsed[nodeLed[0] * 1000 + nodeLed[1]] = {
              nodeIdx: nodeIdx
            };
          }
        }
      }
    }
    freeRationalisedList = [];
    for (nodeLedsIdx = _ad = 0, _len19 = freeLedList.length; _ad < _len19; nodeLedsIdx = ++_ad) {
      freeNodeLeds = freeLedList[nodeLedsIdx];
      curCofG = this.getCofGforLeds(freeNodeLeds);
      discardFree = false;
      for (_ae = 0, _len20 = nodeRationalisedList.length; _ae < _len20; _ae++) {
        nodeLeds = nodeRationalisedList[_ae];
        if (this.dist(curCofG, this.getCofGforLeds(nodeLeds.leds)) < this.minDistForEndNode) {
          discardFree = true;
          break;
        }
      }
      for (_af = 0, _len21 = freeRationalisedList.length; _af < _len21; _af++) {
        freeLeds = freeRationalisedList[_af];
        if (this.dist(curCofG, this.getCofGforLeds(freeLeds.leds)) < this.minDistForEndNode) {
          discardFree = true;
          break;
        }
      }
      if (!discardFree) {
        freeRationalisedList.push({
          leds: freeNodeLeds,
          CofG: this.getCofGforLeds(freeNodeLeds),
          nodeDegree: 1
        });
      }
    }
    for (testNodeIdx = _ag = 0, _len22 = nodeRationalisedList.length; _ag < _len22; testNodeIdx = ++_ag) {
      testNode = nodeRationalisedList[testNodeIdx];
      oStr = testNodeIdx + " nodeLeds ";
      _ref11 = testNode.leds;
      for (_ah = 0, _len23 = _ref11.length; _ah < _len23; _ah++) {
        testNodeLeds = _ref11[_ah];
        oStr += "[" + testNodeLeds[0] + "," + testNodeLeds[1] + "] ";
      }
      console.log(oStr);
    }
    fullNodeList = nodeRationalisedList.concat(freeRationalisedList);
    for (nodeIdx = _ai = 0, _len24 = fullNodeList.length; _ai < _len24; nodeIdx = ++_ai) {
      node = fullNodeList[nodeIdx];
      node["nodeId"] = nodeIdx;
    }
    console.log("InnerNodeList " + nodeRationalisedList.length);
    console.log("FreeNodeList " + freeRationalisedList.length);
    console.log("FullNodeList " + fullNodeList.length);
    this.edgeList = [];
    for (_aj = 0, _len25 = fullNodeList.length; _aj < _len25; _aj++) {
      fullNode = fullNodeList[_aj];
      fullNode.edgesTo = [];
    }
    _ref12 = this.padAdjacencies;
    for (padIdx = _ak = 0, _len26 = _ref12.length; _ak < _len26; padIdx = ++_ak) {
      padAdjList = _ref12[padIdx];
      fromNode = null;
      padCircuit = padLedsData[padIdx].length;
      if (this.dist(padLedsData[padIdx][0], padLedsData[padIdx][padCircuit - 1]) < this.maxDistForFirstAndLastLedsOnCircularPad) {
        padCircuit += 5;
      }
      for (testLedIdx = _al = 0; 0 <= padCircuit ? _al < padCircuit : _al > padCircuit; testLedIdx = 0 <= padCircuit ? ++_al : --_al) {
        ledIdx = testLedIdx % padLedsData[padIdx].length;
        ledInfo = padLedsData[padIdx][ledIdx];
        thisNode = null;
        for (testNodeIdx = _am = 0, _len27 = fullNodeList.length; _am < _len27; testNodeIdx = ++_am) {
          testNode = fullNodeList[testNodeIdx];
          _ref13 = testNode.leds;
          for (_an = 0, _len28 = _ref13.length; _an < _len28; _an++) {
            testNodeLeds = _ref13[_an];
            if (testNodeLeds[0] === padIdx && testNodeLeds[1] === ledIdx) {
              thisNode = {
                nodeIdx: testNodeIdx,
                padIdx: padIdx,
                ledIdx: ledIdx
              };
              break;
            }
          }
          if (thisNode != null) {
            break;
          }
        }
        if ((thisNode != null) && (thisNode.nodeIdx === 20 || thisNode.nodeIdx === 19 || thisNode.nodeIdx === 0 || thisNode.nodeIdx === 27)) {
          console.log("this node " + thisNode.nodeIdx + " fromNode " + (fromNode != null ? fromNode.nodeIdx : "null") + " padIdx " + padIdx + " ledIdx " + ledIdx);
        }
        if ((fromNode != null) && (thisNode != null) && thisNode.nodeIdx !== fromNode.nodeIdx) {
          if (fullNodeList[fromNode.nodeIdx].nodeDegree > 1 || fullNodeList[thisNode.nodeIdx].nodeDegree > 1) {
            curEdgeIdx = this.edgeList.length;
            if (_ref14 = thisNode.nodeIdx, __indexOf.call(fullNodeList[fromNode.nodeIdx].edgesTo, _ref14) < 0) {
              fullNodeList[fromNode.nodeIdx].edgesTo.push({
                toNodeIdx: thisNode.nodeIdx,
                edgeIdx: curEdgeIdx
              });
              edgeInfo = {
                padIdx: padIdx,
                fromNodeIdx: fromNode.nodeIdx,
                fromNode: fullNodeList[fromNode.nodeIdx],
                fromLedIdx: fromNode.ledIdx,
                toNodeIdx: thisNode.nodeIdx,
                toNode: fullNodeList[thisNode.nodeIdx],
                toLedIdx: thisNode.ledIdx
              };
              this.edgeList.push(edgeInfo);
            }
            if (_ref15 = fromNode.nodeIdx, __indexOf.call(fullNodeList[thisNode.nodeIdx].edgesTo, _ref15) < 0) {
              fullNodeList[thisNode.nodeIdx].edgesTo.push({
                toNodeIdx: fromNode.nodeIdx,
                edgeIdx: curEdgeIdx
              });
            }
          }
        }
        if (thisNode != null) {
          fromNode = {};
          for (key in thisNode) {
            val = thisNode[key];
            fromNode[key] = val;
          }
        }
      }
    }
    _ref16 = this.edgeList;
    for (_ao = 0, _len29 = _ref16.length; _ao < _len29; _ao++) {
      edge = _ref16[_ao];
      console.log("edge from " + edge.fromNodeIdx + " to node " + edge.toNodeIdx);
    }
    colrs = this.genColours(fullNodeList.length);
    colrIdx = 0;
    console.log("NumNodes = " + fullNodeList.length);
    for (_ap = 0, _len30 = fullNodeList.length; _ap < _len30; _ap++) {
      nodeLeds = fullNodeList[_ap];
      nodeLeds.colr = colrs[colrIdx++];
    }
    nodesSvg = svg.selectAll("g.nodes").data(fullNodeList).enter().append("g").attr("class", "nodes").append("circle").attr("class", "node").attr("cx", function(d) {
      return d.CofG.pt.x;
    }).attr("cy", function(d) {
      return d.CofG.pt.y;
    }).attr("r", 5).attr("fill", function(d, i) {
      return d.colr;
    });
    edgesSvg = svg.selectAll("g.edges").data(this.edgeList).enter().append("g").attr("class", "edges").append("line").attr("class", "edge").attr("x1", function(d) {
      return d.fromNode.CofG.pt.x;
    }).attr("y1", function(d) {
      return d.fromNode.CofG.pt.y;
    }).attr("x2", function(d) {
      return d.toNode.CofG.pt.x;
    }).attr("y2", function(d) {
      return d.toNode.CofG.pt.y;
    }).attr("stroke", function(d, i) {
      return 'black';
    });
    nodeLabels = svg.selectAll(".nodelabels").data(fullNodeList).enter().append("text").attr("class", "nodelabels");
    nodeLabels.attr("x", function(d) {
      return d.CofG.pt.x + 5;
    }).attr("y", function(d) {
      return d.CofG.pt.y - 2;
    }).text(function(d) {
      return d.nodeId;
    }).attr("font-family", "sans-serif").attr("font-size", "10px").attr("fill", "#005050");
    this.animEdgeIdx = 0;
    this.steps = 0;
    return d3.timer(this.stepFn);
  };

  SpideyGraph.prototype.stepFn = function() {
    var edge, ledIdx, _i, _j, _ref, _ref1, _ref2, _ref3;
    if (this.steps === 0) {
      if (this.animEdgeIdx > 0) {
        edge = this.edgeList[this.animEdgeIdx - 1];
        for (ledIdx = _i = _ref = edge.fromLedIdx, _ref1 = edge.toLedIdx; _ref <= _ref1 ? _i <= _ref1 : _i >= _ref1; ledIdx = _ref <= _ref1 ? ++_i : --_i) {
          this.padLedsData[edge.padIdx][ledIdx].clr = "#dcdcdc";
        }
      }
      edge = this.edgeList[this.animEdgeIdx];
      for (ledIdx = _j = _ref2 = edge.fromLedIdx, _ref3 = edge.toLedIdx; _ref2 <= _ref3 ? _j <= _ref3 : _j >= _ref3; ledIdx = _ref2 <= _ref3 ? ++_j : --_j) {
        this.padLedsData[edge.padIdx][ledIdx].clr = "#000000";
      }
      this.ledsSel.attr("fill", function(d) {
        return d.clr;
      });
    }
    this.steps++;
    if (this.steps > 10) {
      this.animEdgeIdx++;
      this.steps = 0;
      if (this.animEdgeIdx >= this.edgeList.length) {
        return true;
      }
    }
    return false;
  };

  return SpideyGraph;

})();
