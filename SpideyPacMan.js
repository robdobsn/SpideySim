// Generated by CoffeeScript 1.7.1
var SpideyPacMan, Sprite,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Sprite = (function() {
  function Sprite(name, initialNode, colour, spideyWall) {
    this.name = name;
    this.colour = colour;
    this.spideyWall = spideyWall;
    this.curLocation = {
      node: initialNode,
      linkIdx: -1,
      linkStep: 0
    };
    this.curDirection = {
      move: "forward",
      turn: "none"
    };
    return;
  }

  Sprite.prototype.copyLocation = function() {
    this.oldLocation = {
      node: this.curLocation.node,
      linkIdx: this.curLocation.linkIdx,
      linkStep: this.curLocation.linkStep
    };
  };

  Sprite.prototype.show = function() {
    if (this.oldLocation != null) {
      if (this.oldLocation.linkIdx < 0) {
        this.spideyWall.setNodeColour(this.oldLocation.node, false, this.colour);
      } else {
        this.spideyWall.setLinkColour(this.oldLocation.node, this.oldLocation.linkIdx, this.oldLocation.linkStep, false, this.colour);
      }
      if (this.curLocation.linkIdx < 0) {
        this.spideyWall.setNodeColour(this.curLocation.node, true, this.colour);
      } else {
        this.spideyWall.setLinkColour(this.curLocation.node, this.curLocation.linkIdx, this.curLocation.linkStep, true, this.colour);
      }
    }
  };

  Sprite.prototype.getXY = function() {
    if (this.curLocation.linkIdx < 0) {
      return this.spideyWall.getNodeXY(this.curLocation.node);
    }
    return this.spideyWall.getLinkLedXY(this.curLocation.node, this.curLocation.linkIdx, this.curLocation.linkStep);
  };

  Sprite.prototype.dist = function(x1, y1, x2, y2) {
    return Math.sqrt(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1)));
  };

  Sprite.prototype.angle = function(x1, y1, x2, y2) {
    return Math.atan2(y2 - y1, x2 - x1) * 180 / Math.PI;
  };

  Sprite.prototype.moveMe = function() {
    var angleDiff, bestLinkIdx, edgeEndXY, endOfLink, endOfLinkLen, linkAngle, linkIdx, meXY, nearestAngle, nextNode, nextNodeXY, pointA, pointB, reqdAngle, _i, _ref;
    this.copyLocation();
    if (this.curLocation.linkIdx < 0) {
      console.log("Dirn " + this.curDirection.move + "/" + this.curDirection.turn + " lastDir " + (this.angleOfTravel != null ? this.angleOfTravel : "NO"));
      bestLinkIdx = 0;
      if (this.angleOfTravel != null) {
        reqdAngle = this.curDirection.turn === "right" ? this.angleOfTravel + 90 : this.curDirection.turn === "left" ? this.angleOfTravel - 90 : this.angleOfTravel;
        reqdAngle = reqdAngle > 180 ? reqdAngle - 360 : reqdAngle < -180 ? reqdAngle + 360 : reqdAngle;
        console.log("reqdAngle = " + reqdAngle);
        meXY = this.getXY();
        nearestAngle = 360;
        for (linkIdx = _i = 0, _ref = this.spideyWall.getNumLinks(this.curLocation.node); 0 <= _ref ? _i < _ref : _i > _ref; linkIdx = 0 <= _ref ? ++_i : --_i) {
          endOfLinkLen = this.spideyWall.getLinkLength(this.curLocation.node, linkIdx);
          if (endOfLinkLen > 0) {
            edgeEndXY = this.spideyWall.getLinkLedXY(this.curLocation.node, linkIdx, endOfLinkLen - 1);
            linkAngle = this.angle(meXY.x, meXY.y, edgeEndXY.x, edgeEndXY.y);
          } else {
            nextNode = this.spideyWall.getLinkTarget(this.curLocation.node, linkIdx);
            nextNodeXY = this.spideyWall.getNodeXY(nextNode);
            linkAngle = this.angle(meXY.x, meXY.y, nextNodeXY.x, nextNodeXY.y);
          }
          angleDiff = Math.abs(reqdAngle - linkAngle);
          angleDiff = angleDiff > 180 ? 360 - angleDiff : angleDiff;
          console.log("linkAngle = " + linkAngle + " diff " + angleDiff);
          if (nearestAngle > angleDiff) {
            nearestAngle = angleDiff;
            bestLinkIdx = linkIdx;
            console.log("Best is " + linkIdx);
          }
        }
      }
      this.curLocation.linkIdx = bestLinkIdx;
      this.curLocation.linkStep = 0;
    } else {
      if (this.curDirection.move === "back") {
        this.curLocation.linkStep -= 1;
        if (this.curLocation.linkStep < 0) {
          this.curLocation.linkStep = 0;
          this.curLocation.linkIdx = -1;
          this.curDirection.move = "forward";
        }
      } else {
        this.curLocation.linkStep += 1;
        if (this.curLocation.linkStep >= this.spideyWall.getLinkLength(this.curLocation.node, this.curLocation.linkIdx)) {
          this.curLocation.node = this.spideyWall.getLinkTarget(this.curLocation.node, this.curLocation.linkIdx);
          this.curLocation.linkIdx = -1;
          this.curLocation.linkStep = 0;
        }
      }
      if (this.curLocation.linkIdx < 0) {
        if (this.spideyWall.getLinkLength(this.oldLocation.node, this.oldLocation.linkIdx) > 0) {
          pointA = this.spideyWall.getLinkLedXY(this.oldLocation.node, this.oldLocation.linkIdx, 0);
        } else {
          pointA = this.spideyWall.getNodeXY(this.oldLocation.node);
        }
        if (this.spideyWall.getLinkLength(this.oldLocation.node, this.oldLocation.linkIdx) > 1) {
          endOfLink = this.spideyWall.getLinkLength(this.oldLocation.node, this.oldLocation.linkIdx) - 1;
          pointB = this.spideyWall.getLinkLedXY(this.oldLocation.node, this.oldLocation.linkIdx, endOfLink);
        } else {
          nextNode = this.spideyWall.getLinkTarget(this.oldLocation.node, this.oldLocation.linkIdx);
          pointB = this.spideyWall.getNodeXY(nextNode);
        }
        this.angleOfTravel = this.angle(pointA.x, pointA.y, pointB.x, pointB.y);
      }
    }
  };

  Sprite.prototype.moveBaddie = function(me) {
    var bestLinkIdx, edgeEndXY, endOfLinkLen, linkDist, linkIdx, meXY, minDist, _i, _ref;
    this.copyLocation();
    if (this.curLocation.linkIdx < 0) {
      meXY = me.getXY();
      minDist = 100000;
      bestLinkIdx = 0;
      for (linkIdx = _i = 0, _ref = this.spideyWall.getNumLinks(this.curLocation.node); 0 <= _ref ? _i < _ref : _i > _ref; linkIdx = 0 <= _ref ? ++_i : --_i) {
        endOfLinkLen = this.spideyWall.getLinkLength(this.curLocation.node, linkIdx);
        if (endOfLinkLen > 0) {
          edgeEndXY = this.spideyWall.getLinkLedXY(this.curLocation.node, linkIdx, endOfLinkLen - 1);
          linkDist = this.dist(meXY.x, meXY.y, edgeEndXY.x, edgeEndXY.y);
          if (minDist > linkDist) {
            minDist = linkDist;
            bestLinkIdx = linkIdx;
          }
        }
      }
      this.curLocation.linkIdx = bestLinkIdx;
      this.curLocation.linkStep = 0;
    } else {
      this.curLocation.linkStep += 1;
      if (this.curLocation.linkStep >= this.spideyWall.getLinkLength(this.curLocation.node, this.curLocation.linkIdx)) {
        this.curLocation.node = this.spideyWall.getLinkTarget(this.curLocation.node, this.curLocation.linkIdx);
        this.curLocation.linkIdx = -1;
        this.curLocation.linkStep = 0;
      }
    }
  };

  return Sprite;

})();

SpideyPacMan = (function() {
  function SpideyPacMan(spideyWall) {
    this.spideyWall = spideyWall;
    this.step = __bind(this.step, this);
    this.me = new Sprite("me", 39, "green", this.spideyWall);
    this.baddies = [new Sprite("bad1", 66, "red", this.spideyWall), new Sprite("bad2", 75, "red", this.spideyWall)];
    return;
  }

  SpideyPacMan.prototype.showSprites = function() {
    this.spideyWall.preShowAll();
    this.me.show();
    this.spideyWall.showAll();
  };

  SpideyPacMan.prototype.step = function() {
    var actor, _i, _len, _ref;
    this.me.moveMe();
    _ref = this.baddies;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      actor = _ref[_i];
      actor.moveBaddie(this.me);
    }
    this.showSprites();
  };

  SpideyPacMan.prototype.mouseover = function(dirn) {
    if (dirn === "forward" || dirn === "back") {
      this.me.curDirection.move = dirn;
      this.me.curDirection.turn = "none";
    } else if (dirn === "left" || dirn === "right") {
      this.me.curDirection.turn = dirn;
    }
  };

  SpideyPacMan.prototype.getDebugInfo = function() {
    return "N " + this.me.curLocation.node + " L " + this.me.curLocation.linkIdx + " S " + this.me.curLocation.linkStep;
  };

  return SpideyPacMan;

})();
