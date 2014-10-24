// Generated by CoffeeScript 1.7.1
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

this.SpideyGraph = (function() {
  function SpideyGraph() {
    this.stepFn = __bind(this.stepFn, this);
    this.ledCmd = __bind(this.ledCmd, this);
    this.mousemove = __bind(this.mousemove, this);
  }

  SpideyGraph.DEBUG_EDGES = false;

  SpideyGraph.DEBUG_NODES = false;

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
      xSum += this.padLedsList[ledId.padIdx][ledId.ledIdx].pt.x;
      ySum += this.padLedsList[ledId.padIdx][ledId.ledIdx].pt.y;
    }
    return {
      pt: {
        x: xSum / ledList.length,
        y: ySum / ledList.length
      }
    };
  };

  SpideyGraph.prototype.createGraph = function(padOutlines, padLedsList, ledsSel, svg) {
    var adjFound, alreadInList, curCofG, curEdgeIdx, discardFree, distFromCofGtoLed, edgeInfo, edgeLength, edgeNodeLeds, edgeNodeLedsList, edgeSteps, edgeStr, edgeStr2, edgeStr3, edgeTo, freeLeds, fromNode, fullNode, i, key, led, ledAdjList, ledBase, ledDist, ledDistances, ledIdx, ledInc, ledInfo, ledPadFound, ledUniqPads, leds, ledsModified, ledsUsed, listMerged, multiNodeLeds, multiNodeLedsIdx, multiNodeLedsList, newList, node, nodeAlreadyInList, nodeIdx, nodeInfo, nodeLed, nodeLeds, numleds, oStr, otherLedDist, otherLedIdx, otherLedInfo, otherLedUse, otherNodeLed, otherNodeLedsIdx, otherPadIdx, otherPadLedsInfo, padAdjList, padCircuit, padIdx, padLedsInfo, rationalisedEdgeNodeLedsList, rationalisedMultiNodeLedsList, step, tLedIdx, testLedIdx, testNode, testNodeIdx, testNodeLeds, thisNode, toNodeLed, val, wrapRoundNumLeds, wrappedRound, _aa, _ab, _ac, _ad, _ae, _af, _ag, _ah, _ai, _aj, _ak, _al, _am, _an, _ao, _ap, _aq, _i, _j, _k, _l, _len, _len1, _len10, _len11, _len12, _len13, _len14, _len15, _len16, _len17, _len18, _len19, _len2, _len20, _len21, _len22, _len23, _len24, _len25, _len26, _len27, _len28, _len29, _len3, _len30, _len31, _len4, _len5, _len6, _len7, _len8, _len9, _m, _n, _o, _p, _q, _r, _ref, _ref1, _ref10, _ref11, _ref12, _ref13, _ref14, _ref15, _ref16, _ref17, _ref18, _ref19, _ref2, _ref20, _ref21, _ref22, _ref23, _ref24, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9, _results, _s, _t, _u, _v, _w, _x, _y, _z;
    this.padLedsList = padLedsList;
    this.ledsSel = ledsSel;
    this.svg = svg;
    _ref = this.padLedsList;
    for (padIdx = _i = 0, _len = _ref.length; _i < _len; padIdx = ++_i) {
      padLedsInfo = _ref[padIdx];
      this.padAdjacencies.push([]);
      for (otherPadIdx = _j = 0, _ref1 = this.padLedsList.length; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; otherPadIdx = 0 <= _ref1 ? ++_j : --_j) {
        if (padIdx === otherPadIdx) {
          continue;
        }
        otherPadLedsInfo = this.padLedsList[otherPadIdx];
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
    multiNodeLedsList = [];
    edgeNodeLedsList = [];
    _ref2 = this.padAdjacencies;
    for (padIdx = _m = 0, _len3 = _ref2.length; _m < _len3; padIdx = ++_m) {
      padAdjList = _ref2[padIdx];
      _ref3 = this.padLedsList[padIdx];
      for (ledIdx = _n = 0, _len4 = _ref3.length; _n < _len4; ledIdx = ++_n) {
        ledInfo = _ref3[ledIdx];
        ledAdjList = [];
        ledUniqPads = [];
        for (_o = 0, _len5 = padAdjList.length; _o < _len5; _o++) {
          otherPadIdx = padAdjList[_o];
          ledPadFound = false;
          _ref4 = this.padLedsList[otherPadIdx];
          for (otherLedIdx = _p = 0, _len6 = _ref4.length; _p < _len6; otherLedIdx = ++_p) {
            otherLedInfo = _ref4[otherLedIdx];
            if (this.dist(ledInfo, otherLedInfo) < this.maxDistForNodeDetect) {
              if (ledAdjList.length === 0) {
                ledAdjList.push({
                  padIdx: padIdx,
                  ledIdx: ledIdx
                });
              }
              ledAdjList.push({
                padIdx: otherPadIdx,
                ledIdx: otherLedIdx
              });
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
          for (_q = 0, _len7 = multiNodeLedsList.length; _q < _len7; _q++) {
            nodeLeds = multiNodeLedsList[_q];
            for (_r = 0, _len8 = nodeLeds.length; _r < _len8; _r++) {
              led = nodeLeds[_r];
              if (led.padIdx === padIdx) {
                if (led.ledIdx === ledIdx) {
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
            multiNodeLedsList.push(ledAdjList);
          }
        } else {
          if (ledIdx === 0 || ledIdx === this.padLedsList[padIdx].length - 1) {
            edgeNodeLedsList.push(ledAdjList);
          }
        }
      }
    }
    rationalisedMultiNodeLedsList = [];
    for (multiNodeLedsIdx = _s = 0, _len9 = multiNodeLedsList.length; _s < _len9; multiNodeLedsIdx = ++_s) {
      multiNodeLeds = multiNodeLedsList[multiNodeLedsIdx];
      curCofG = this.getCofGforLeds(multiNodeLeds);
      for (otherNodeLedsIdx = _t = _ref5 = multiNodeLedsIdx + 1, _ref6 = multiNodeLedsList.length; _ref5 <= _ref6 ? _t < _ref6 : _t > _ref6; otherNodeLedsIdx = _ref5 <= _ref6 ? ++_t : --_t) {
        listMerged = false;
        if (this.dist(curCofG, this.getCofGforLeds(multiNodeLedsList[otherNodeLedsIdx])) < this.maxDistForNodeMerge) {
          for (_u = 0, _len10 = multiNodeLeds.length; _u < _len10; _u++) {
            nodeLed = multiNodeLeds[_u];
            alreadInList = false;
            _ref7 = multiNodeLedsList[otherNodeLedsIdx];
            for (_v = 0, _len11 = _ref7.length; _v < _len11; _v++) {
              otherNodeLed = _ref7[_v];
              if (nodeLed.padIdx === otherNodeLed.padIdx && nodeLed.ledIdx === otherNodeLed.ledIdx) {
                alreadInList = true;
              }
            }
            if (!alreadInList) {
              multiNodeLedsList[otherNodeLedsIdx].push(nodeLed);
            }
          }
          listMerged = true;
          break;
        }
      }
      if (!listMerged) {
        rationalisedMultiNodeLedsList.push({
          leds: multiNodeLeds,
          CofG: this.getCofGforLeds(multiNodeLeds),
          nodeDegree: 2
        });
      }
    }
    rationalisedEdgeNodeLedsList = [];
    for (_w = 0, _len12 = edgeNodeLedsList.length; _w < _len12; _w++) {
      edgeNodeLeds = edgeNodeLedsList[_w];
      curCofG = this.getCofGforLeds(edgeNodeLeds);
      discardFree = false;
      for (_x = 0, _len13 = rationalisedMultiNodeLedsList.length; _x < _len13; _x++) {
        nodeLeds = rationalisedMultiNodeLedsList[_x];
        if (this.dist(curCofG, this.getCofGforLeds(nodeLeds.leds)) < this.minDistForEndNode) {
          discardFree = true;
          break;
        }
      }
      for (_y = 0, _len14 = rationalisedEdgeNodeLedsList.length; _y < _len14; _y++) {
        freeLeds = rationalisedEdgeNodeLedsList[_y];
        if (this.dist(curCofG, this.getCofGforLeds(freeLeds.leds)) < this.minDistForEndNode) {
          discardFree = true;
          break;
        }
      }
      if (!discardFree) {
        rationalisedEdgeNodeLedsList.push({
          leds: edgeNodeLeds,
          CofG: this.getCofGforLeds(edgeNodeLeds),
          nodeDegree: 1
        });
      }
    }
    this.nodeList = rationalisedMultiNodeLedsList.concat(rationalisedEdgeNodeLedsList);
    _ref8 = this.nodeList;
    for (_z = 0, _len15 = _ref8.length; _z < _len15; _z++) {
      nodeInfo = _ref8[_z];
      ledDistances = {};
      curCofG = nodeInfo.CofG;
      _ref9 = nodeInfo.leds;
      for (_aa = 0, _len16 = _ref9.length; _aa < _len16; _aa++) {
        nodeLed = _ref9[_aa];
        distFromCofGtoLed = this.dist(curCofG, this.padLedsList[nodeLed.padIdx][nodeLed.ledIdx]);
        if (nodeLed.padIdx in ledDistances) {
          if (ledDistances[nodeLed.padIdx].dist > distFromCofGtoLed) {
            ledDistances[nodeLed.padIdx].dist = distFromCofGtoLed;
            ledDistances[nodeLed.padIdx].padIdx = nodeLed.padIdx;
            ledDistances[nodeLed.padIdx].ledIdx = nodeLed.ledIdx;
          }
        } else {
          ledDistances[nodeLed.padIdx] = {
            dist: distFromCofGtoLed,
            padIdx: nodeLed.padIdx,
            ledIdx: nodeLed.ledIdx
          };
        }
      }
      nodeInfo.leds = [];
      for (key in ledDistances) {
        val = ledDistances[key];
        nodeInfo.leds.push(val);
      }
      nodeInfo.CofG = this.getCofGforLeds(nodeInfo.leds);
    }
    _ref10 = this.nodeList;
    for (nodeIdx = _ab = 0, _len17 = _ref10.length; _ab < _len17; nodeIdx = ++_ab) {
      node = _ref10[nodeIdx];
      node["nodeId"] = nodeIdx;
      _ref11 = node.leds;
      for (_ac = 0, _len18 = _ref11.length; _ac < _len18; _ac++) {
        led = _ref11[_ac];
        led["uniqId"] = led.padIdx * 1000 + led.ledIdx;
        led["led"] = this.padLedsList[led.padIdx][led.ledIdx];
      }
    }
    ledsUsed = {};
    _ref12 = this.nodeList;
    for (nodeIdx = _ad = 0, _len19 = _ref12.length; _ad < _len19; nodeIdx = ++_ad) {
      nodeInfo = _ref12[nodeIdx];
      ledsModified = true;
      while (ledsModified) {
        ledsModified = false;
        _ref13 = nodeInfo.leds;
        for (_ae = 0, _len20 = _ref13.length; _ae < _len20; _ae++) {
          nodeLed = _ref13[_ae];
          if (nodeLed.uniqId in ledsUsed) {
            otherLedUse = ledsUsed[nodeLed.uniqId];
            if (otherLedUse.nodeIdx !== nodeIdx) {
              ledInfo = this.padLedsList[nodeLed.padIdx][nodeLed.ledIdx];
              ledDist = this.dist(ledInfo, this.nodeList[nodeIdx].CofG);
              otherLedDist = this.dist(ledInfo, this.nodeList[otherLedUse.nodeIdx].CofG);
              if (ledDist < otherLedDist) {
                newList = [];
                _ref14 = this.nodeList[otherLedUse.nodeIdx].leds;
                for (_af = 0, _len21 = _ref14.length; _af < _len21; _af++) {
                  led = _ref14[_af];
                  if (!(led.padIdx === nodeLed.padIdx && led.ledIdx === nodeLed.ledIdx)) {
                    newList.push(led);
                  }
                }
                this.nodeList[otherLedUse.nodeIdx].leds = newList;
                ledsUsed[nodeLed.uniqId] = {
                  nodeIdx: nodeIdx
                };
              } else {
                newList = [];
                _ref15 = this.nodeList[nodeIdx].leds;
                for (_ag = 0, _len22 = _ref15.length; _ag < _len22; _ag++) {
                  led = _ref15[_ag];
                  if (!(led.padIdx === nodeLed.padIdx && led.ledIdx === nodeLed.ledIdx)) {
                    newList.push(led);
                  }
                }
                this.nodeList[nodeIdx].leds = newList;
              }
              ledsModified = true;
              break;
            }
          } else {
            ledsUsed[nodeLed.uniqId] = {
              nodeIdx: nodeIdx
            };
          }
        }
      }
    }
    if (this.DEBUG_NODES != null) {
      _ref16 = this.nodeList;
      for (testNodeIdx = _ah = 0, _len23 = _ref16.length; _ah < _len23; testNodeIdx = ++_ah) {
        testNode = _ref16[testNodeIdx];
        oStr = testNodeIdx + " nodeLeds ";
        _ref17 = testNode.leds;
        for (_ai = 0, _len24 = _ref17.length; _ai < _len24; _ai++) {
          testNodeLeds = _ref17[_ai];
          oStr += "[" + testNodeLeds.padIdx + "," + testNodeLeds.ledIdx + "] ";
        }
        console.log(oStr);
      }
    }
    console.log("InnerNodeList " + rationalisedMultiNodeLedsList.length);
    console.log("FreeNodeList " + rationalisedEdgeNodeLedsList.length);
    console.log("Combined nodeList " + this.nodeList.length);
    this.edgeList = [];
    _ref18 = this.nodeList;
    for (_aj = 0, _len25 = _ref18.length; _aj < _len25; _aj++) {
      fullNode = _ref18[_aj];
      fullNode.edgesTo = [];
    }
    _ref19 = this.padAdjacencies;
    for (padIdx = _ak = 0, _len26 = _ref19.length; _ak < _len26; padIdx = ++_ak) {
      padAdjList = _ref19[padIdx];
      fromNode = null;
      padCircuit = this.padLedsList[padIdx].length;
      if (this.dist(this.padLedsList[padIdx][0], this.padLedsList[padIdx][padCircuit - 1]) < this.maxDistForFirstAndLastLedsOnCircularPad) {
        padCircuit += 5;
      }
      for (testLedIdx = _al = 0; 0 <= padCircuit ? _al < padCircuit : _al > padCircuit; testLedIdx = 0 <= padCircuit ? ++_al : --_al) {
        ledIdx = testLedIdx % this.padLedsList[padIdx].length;
        ledInfo = this.padLedsList[padIdx][ledIdx];
        wrappedRound = testLedIdx >= this.padLedsList[padIdx].length;
        thisNode = null;
        _ref20 = this.nodeList;
        for (testNodeIdx = _am = 0, _len27 = _ref20.length; _am < _len27; testNodeIdx = ++_am) {
          testNode = _ref20[testNodeIdx];
          _ref21 = testNode.leds;
          for (_an = 0, _len28 = _ref21.length; _an < _len28; _an++) {
            testNodeLeds = _ref21[_an];
            if (testNodeLeds.padIdx === padIdx && testNodeLeds.ledIdx === ledIdx) {
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
        if ((fromNode != null) && (thisNode != null) && thisNode.nodeIdx !== fromNode.nodeIdx) {
          if (this.nodeList[fromNode.nodeIdx].nodeDegree > 1 || this.nodeList[thisNode.nodeIdx].nodeDegree > 1) {
            if (this.DEBUG_EDGES != null) {
              console.log("fromNode " + fromNode + " thisNode " + thisNode);
            }
            curEdgeIdx = this.edgeList.length;
            edgeLength = Math.abs(fromNode.ledIdx - thisNode.ledIdx);
            if (wrappedRound) {
              this.padLedsList[padIdx].length - edgeLength;
            }
            if (!this.nodeList[fromNode.nodeIdx].edgesTo.some(function(el) {
              return el.toNodeIdx === thisNode.nodeIdx;
            })) {
              this.nodeList[fromNode.nodeIdx].edgesTo.push({
                toNodeIdx: thisNode.nodeIdx,
                edgeIdx: curEdgeIdx,
                edgeLength: edgeLength
              });
              edgeInfo = {
                padIdx: padIdx,
                fromNodeIdx: fromNode.nodeIdx,
                fromNode: this.nodeList[fromNode.nodeIdx],
                fromLedIdx: fromNode.ledIdx,
                toNodeIdx: thisNode.nodeIdx,
                toNode: this.nodeList[thisNode.nodeIdx],
                toLedIdx: thisNode.ledIdx
              };
              this.edgeList.push(edgeInfo);
            }
            if (!this.nodeList[thisNode.nodeIdx].edgesTo.some(function(el) {
              return el.toNodeIdx === fromNode.nodeIdx;
            })) {
              this.nodeList[thisNode.nodeIdx].edgesTo.push({
                toNodeIdx: fromNode.nodeIdx,
                edgeIdx: curEdgeIdx,
                edgeLength: edgeLength
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
    if ((this.DEBUG_NODES != null) || (this.DEBUG_EDGES != null)) {
      _ref22 = this.nodeList;
      for (nodeIdx = _ao = 0, _len29 = _ref22.length; _ao < _len29; nodeIdx = ++_ao) {
        node = _ref22[nodeIdx];
        edgeStr = "";
        _ref23 = node.edgesTo;
        for (_ap = 0, _len30 = _ref23.length; _ap < _len30; _ap++) {
          edgeTo = _ref23[_ap];
          edgeStr += " " + edgeTo.toNodeIdx;
        }
        console.log("Node " + nodeIdx + " edgesToNodes " + edgeStr);
      }
    }
    _ref24 = this.nodeList;
    _results = [];
    for (nodeIdx = _aq = 0, _len31 = _ref24.length; _aq < _len31; nodeIdx = ++_aq) {
      node = _ref24[nodeIdx];
      _results.push((function() {
        var _ar, _as, _at, _au, _av, _aw, _len32, _len33, _len34, _len35, _len36, _ref25, _ref26, _ref27, _ref28, _results1;
        _ref25 = node.edgesTo;
        _results1 = [];
        for (_ar = 0, _len32 = _ref25.length; _ar < _len32; _ar++) {
          edgeTo = _ref25[_ar];
          edgeSteps = [];
          _ref26 = node.leds;
          for (_as = 0, _len33 = _ref26.length; _as < _len33; _as++) {
            nodeLed = _ref26[_as];
            padIdx = nodeLed.padIdx;
            _ref27 = this.nodeList[edgeTo.toNodeIdx].leds;
            for (_at = 0, _len34 = _ref27.length; _at < _len34; _at++) {
              toNodeLed = _ref27[_at];
              if (padIdx === toNodeLed.padIdx) {
                numleds = Math.abs(toNodeLed.ledIdx - nodeLed.ledIdx);
                ledInc = toNodeLed.ledIdx > nodeLed.ledIdx ? 1 : -1;
                ledBase = nodeLed.ledIdx;
                if (node.nodeDegree >= 2 && this.nodeList[edgeTo.toNodeIdx].nodeDegree >= 2) {
                  wrapRoundNumLeds = this.padLedsList[padIdx].length - numleds;
                  if (numleds > wrapRoundNumLeds) {
                    numleds = wrapRoundNumLeds;
                    ledInc = -ledInc;
                  }
                }
                if (numleds < edgeTo.edgeLength - 1 && numleds > edgeTo.edgeLength - 10) {
                  numleds = Math.abs(toNodeLed.ledIdx - nodeLed.ledIdx);
                  ledInc = -ledInc;
                }
                if (this.DEBUG_EDGES != null) {
                  console.log("edgeLengthDiscrepancy from " + nodeIdx + " to " + edgeTo.toNodeIdx + " expected " + edgeTo.edgeLength + " is " + numleds);
                }
                edgeStr2 = "";
                for (i = _au = 0, _ref28 = numleds - 1; 0 <= _ref28 ? _au < _ref28 : _au > _ref28; i = 0 <= _ref28 ? ++_au : --_au) {
                  if (edgeSteps.length <= i) {
                    edgeSteps[i] = [];
                  }
                  tLedIdx = (ledBase + (i + 1) * ledInc + this.padLedsList[padIdx].length) % this.padLedsList[padIdx].length;
                  edgeSteps[i].push({
                    padIdx: padIdx,
                    ledIdx: tLedIdx
                  });
                  edgeStr2 += tLedIdx + ",";
                }
                if (this.DEBUG_EDGES != null) {
                  console.log("Edge from " + nodeIdx + " to " + edgeTo.toNodeIdx + " alongPad " + padIdx + " numleds= " + numleds + " fromNodeLed " + nodeLed.ledIdx + " toNodeLed " + toNodeLed.ledIdx + " edgeLeds " + edgeStr2);
                }
              }
            }
          }
          edgeTo.edgeList = edgeSteps;
          if (this.DEBUG_EDGES != null) {
            edgeStr3 = "edgeSteps ";
            for (_av = 0, _len35 = edgeSteps.length; _av < _len35; _av++) {
              step = edgeSteps[_av];
              for (_aw = 0, _len36 = step.length; _aw < _len36; _aw++) {
                leds = step[_aw];
                edgeStr3 += leds.padIdx + "." + leds.ledIdx + " ";
              }
              edgeStr3 += ", ";
            }
            _results1.push(console.log(edgeStr3));
          } else {
            _results1.push(void 0);
          }
        }
        return _results1;
      }).call(this));
    }
    return _results;
  };

  SpideyGraph.prototype.colourNodes = function() {
    var colrIdx, colrs, nodeLeds, _i, _len, _ref, _results;
    colrs = this.genColours(this.nodeList.length);
    colrIdx = 0;
    _ref = this.nodeList;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      nodeLeds = _ref[_i];
      _results.push(nodeLeds.colr = colrs[colrIdx++]);
    }
    return _results;
  };

  SpideyGraph.prototype.displayNodes = function() {
    var nodesSvg;
    return nodesSvg = this.svg.selectAll("g.nodes").data(this.nodeList).enter().append("g").attr("class", "nodes").append("circle").attr("class", "node").attr("cx", function(d) {
      return d.CofG.pt.x;
    }).attr("cy", function(d) {
      return d.CofG.pt.y;
    }).attr("r", 5).attr("fill", function(d, i) {
      return d.colr;
    });
  };

  SpideyGraph.prototype.displayEdges = function() {
    var edgesSvg;
    return edgesSvg = this.svg.selectAll("g.edges").data(this.edgeList).enter().append("g").attr("class", "edges").append("line").attr("class", "edge").attr("x1", function(d) {
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
  };

  SpideyGraph.prototype.labelNodes = function() {
    var nodeLabels;
    nodeLabels = this.svg.selectAll(".nodelabels").data(this.nodeList).enter().append("text").attr("class", "nodelabels");
    return nodeLabels.attr("x", function(d) {
      return d.CofG.pt.x + 5;
    }).attr("y", function(d) {
      return d.CofG.pt.y - 2;
    }).text(function(d) {
      return d.nodeId;
    }).attr("font-family", "sans-serif").attr("font-size", "10px").attr("fill", "#005050");
  };

  SpideyGraph.prototype.animate = function() {
    this.animNodeIdx = 34;
    this.animEdgeIdx = 0;
    this.animEdgeStep = 0;
    this.atANode = true;
    this.steps = 0;
    return d3.timer(this.stepFn);
  };

  SpideyGraph.prototype.enableMouseMode = function() {
    return this.svg.on("mousemove", this.mousemove);
  };

  SpideyGraph.prototype.mousemove = function() {
    var edgeStep, edgesTo, led, node, nodeIdx, pad, x, y, _i, _j, _k, _l, _len, _len1, _len2, _len3, _len4, _len5, _m, _n, _ref, _ref1, _ref2, _ref3, _results;
    x = event.x;
    y = event.y;
    _ref = this.nodeList;
    _results = [];
    for (nodeIdx = _i = 0, _len = _ref.length; _i < _len; nodeIdx = ++_i) {
      node = _ref[nodeIdx];
      if (this.dist(node.CofG, {
        pt: {
          x: x,
          y: y
        }
      }) < 10) {
        _ref1 = this.padLedsList;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          pad = _ref1[_j];
          for (_k = 0, _len2 = pad.length; _k < _len2; _k++) {
            led = pad[_k];
            led.clr = "#dcdcdc";
          }
        }
        _ref2 = node.edgesTo;
        for (_l = 0, _len3 = _ref2.length; _l < _len3; _l++) {
          edgesTo = _ref2[_l];
          _ref3 = edgesTo.edgeList;
          for (_m = 0, _len4 = _ref3.length; _m < _len4; _m++) {
            edgeStep = _ref3[_m];
            for (_n = 0, _len5 = edgeStep.length; _n < _len5; _n++) {
              led = edgeStep[_n];
              this.padLedsList[led.padIdx][led.ledIdx].clr = "#000000";
            }
          }
        }
      }
      _results.push(this.ledsSel.attr("fill", function(d) {
        return d.clr;
      }));
    }
    return _results;
  };

  SpideyGraph.prototype.ledCmd = function() {
    var sss;
    sss = "http://fractal:5078/rawcmd/01010b0200010001" + Math.random().toString(16).substr(-6) + Math.random().toString(16).substr(-6);
    return $.get(sss, function(data) {
      return console.log(".");
    });
  };

  SpideyGraph.prototype.stepFn = function() {
    var edgeSteps, led, nodeLed, pad, _i, _j, _k, _l, _len, _len1, _len2, _len3, _ref, _ref1, _ref2;
    this.steps++;
    if (this.steps > 10) {
      this.steps = 0;
      return false;
    }
    _ref = this.padLedsList;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      pad = _ref[_i];
      for (_j = 0, _len1 = pad.length; _j < _len1; _j++) {
        led = pad[_j];
        led.clr = "#dcdcdc";
      }
    }
    if (this.atANode) {
      this.animEdgeIdx = Math.floor(Math.random() * this.nodeList[this.animNodeIdx].edgesTo.length);
      this.atANode = false;
      this.animEdgeStep = 0;
      _ref1 = this.nodeList[this.animNodeIdx].leds;
      for (_k = 0, _len2 = _ref1.length; _k < _len2; _k++) {
        nodeLed = _ref1[_k];
        this.padLedsList[nodeLed.padIdx][nodeLed.ledIdx].clr = "#000000";
      }
      if (this.nodeList[this.animNodeIdx].edgesTo[this.animEdgeIdx].edgeList.length === 0) {
        this.animNodeIdx = this.nodeList[this.animNodeIdx].edgesTo[this.animEdgeIdx].toNodeIdx;
        this.atANode = true;
      }
    } else {
      edgeSteps = this.nodeList[this.animNodeIdx].edgesTo[this.animEdgeIdx].edgeList;
      if (this.animEdgeStep < edgeSteps.length) {
        _ref2 = edgeSteps[this.animEdgeStep];
        for (_l = 0, _len3 = _ref2.length; _l < _len3; _l++) {
          led = _ref2[_l];
          this.padLedsList[led.padIdx][led.ledIdx].clr = "#000000";
        }
      }
      this.animEdgeStep++;
      if (this.animEdgeStep >= edgeSteps.length) {
        this.animNodeIdx = this.nodeList[this.animNodeIdx].edgesTo[this.animEdgeIdx].toNodeIdx;
        this.atANode = true;
      }
    }
    this.ledsSel.attr("fill", function(d) {
      return d.clr;
    });
    return false;
  };

  return SpideyGraph;

})();
