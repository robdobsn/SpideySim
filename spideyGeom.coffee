class @spideyGeom

	ledInterval: 6.9
	steps: 0
	ledUISize: 3

	padInfo: [
		{ chainIdx: 276, startPos: 0, endPos: -1, hiddenLeds: 5, anticlockwise: true }, #0
		{ chainIdx: 0, startPos: 0.32, endPos: 0.99, hiddenLeds: 5, anticlockwise: true }, #1
		{ chainIdx: 0, startPos: 0, endPos: -1, hiddenLeds: 5, anticlockwise: true }, #2
		{ chainIdx: 0, startPos: 0.01, endPos: 0.7, hiddenLeds: 5, anticlockwise: true }, #3
		{ chainIdx: 0, startPos: 0, endPos: -1, hiddenLeds: 5, anticlockwise: true }, #4
		{ chainIdx: 0, startPos: 0, endPos: -1, hiddenLeds: 7, anticlockwise: true }, #5
		{ chainIdx: 0, startPos: 0, endPos: -1, hiddenLeds: 5, anticlockwise: true }, #6
		{ chainIdx: 0, startPos: 0, endPos: -1, hiddenLeds: 5, anticlockwise: true }, #7
		{ chainIdx: 0, startPos: 0, endPos: -1, hiddenLeds: 5, anticlockwise: true }, #8
		{ chainIdx: 222, startPos: 0, endPos: -1, hiddenLeds: -7, anticlockwise: true }, #9
		{ chainIdx: 276, startPos: 0, endPos: -1, hiddenLeds: -27, anticlockwise: true }, #10
		{ chainIdx: 0, startPos: 0, endPos: -1, hiddenLeds: 5, anticlockwise: true }, #11
		{ chainIdx: 174, startPos: 0, endPos: -1, hiddenLeds: 36, anticlockwise: true }, #12
		{ chainIdx: 0, startPos: 0, endPos: -1, hiddenLeds: 5, anticlockwise: true }, #13
		{ chainIdx: 0, startPos: 0, endPos: -1, hiddenLeds: 5, anticlockwise: true }, #14
		{ chainIdx: 323, startPos: 0.36, endPos: 0.98, hiddenLeds: 0, anticlockwise: true }, #15
		{ chainIdx: 0, startPos: 0, endPos: -1, hiddenLeds: 5, anticlockwise: true }, #16
		{ chainIdx: 338, startPos: 0, endPos: -1, hiddenLeds: 5, anticlockwise: true }, #17
		{ chainIdx: 0, startPos: 0, endPos: -1, hiddenLeds: 5, anticlockwise: true }, #18
		{ chainIdx: 0, startPos: 0, endPos: -1, hiddenLeds: 5, anticlockwise: true }, #19
		{ chainIdx: 94, startPos: 0, endPos: -1, hiddenLeds: -26, anticlockwise: true }, #20
		{ chainIdx: 132, startPos: 0, endPos: -1, hiddenLeds: -5, anticlockwise: true }, #21
		{ chainIdx: 0, startPos: 0.2, endPos: 1.0, hiddenLeds: 5, anticlockwise: false }, #22
		{ chainIdx: 0, startPos: 0.34, endPos: 0.99, hiddenLeds: 5, anticlockwise: false }, #23
		{ chainIdx: 0, startPos: 0, endPos: -1, hiddenLeds: 5, anticlockwise: true }, #24
		{ chainIdx: 0, startPos: 0.02, endPos: 0.49, hiddenLeds: 5, anticlockwise: true }, #25
		{ chainIdx: 0, startPos: 0.27, endPos: 1.0, hiddenLeds: 5, anticlockwise: false }, #26
		{ chainIdx: 0, startPos: 0.01, endPos: 0.69, hiddenLeds: 5, anticlockwise: true }, #27
		{ chainIdx: 308, startPos: 0.01, endPos: 0.51, hiddenLeds: 14, anticlockwise: true }, #28
		{ chainIdx: 0, startPos: 0.01, endPos: 0.62, hiddenLeds: 5, anticlockwise: true }, #29
		{ chainIdx: 0, startPos: 0.02, endPos: 0.55, hiddenLeds: 5, anticlockwise: true }, #30
		{ chainIdx: 0, startPos: 0.38, endPos: 0.99, hiddenLeds: 5, anticlockwise: false }, #31
		{ chainIdx: 0, startPos: 0.33, endPos: 0.98, hiddenLeds: 5, anticlockwise: false }, #32
		{ chainIdx: 0, startPos: 0, endPos: -1, hiddenLeds: 5, anticlockwise: true }, #33
		{ chainIdx: 0, startPos: 0.37, endPos: 0.98, hiddenLeds: 5, anticlockwise: false }, #34
		{ chainIdx: 0, startPos: 0.01, endPos: 0.7, hiddenLeds: 5, anticlockwise: true }, #35
		{ chainIdx: 0, startPos: 0, endPos: -1, hiddenLeds: 5, anticlockwise: true }, #36
		{ chainIdx: 56, startPos: 0, endPos: -1, hiddenLeds: 30, anticlockwise: true }, #37
		{ chainIdx: 0, startPos: 0.01, endPos: 0.55, hiddenLeds: 5, anticlockwise: true }, #38
		{ chainIdx: 0, startPos: 0.01, endPos: 0.68, hiddenLeds: 5, anticlockwise: true }, #39
		{ chainIdx: 0, startPos: 0, endPos: -1, hiddenLeds: 5, anticlockwise: true }, #40
		{ chainIdx: 0, startPos: 0.01, endPos: 0.7, hiddenLeds: 5, anticlockwise: true }, #41
		{ chainIdx: 0, startPos: 0.01, endPos: 0.76, hiddenLeds: 5, anticlockwise: true }, #42
		{ chainIdx: 0, startPos: 0.2, endPos: 0.67, hiddenLeds: 5, anticlockwise: true }, #43
		{ chainIdx: 0, startPos: 0.01, endPos: 0.65, hiddenLeds: 5, anticlockwise: true }, #44
	]

	init: ->

		@spideyAnim = new SpideyAnimation()
		@spideyGraph = new SpideyGraph()

		svg = d3.select("#spideyGeom svg");
		@padOutlines = svg.selectAll("path");

		pad_centers = @padOutlines[0].map (d, padIdx) ->
		    bbox = d.getBBox()
		    return [bbox.x + bbox.width/2, bbox.y + bbox.height/2, padIdx]

		@padLedsList = @padOutlines[0].map (d, padIdx) =>
			pathLen = d.getTotalLength()
			wrapRound = @padInfo[padIdx].endPos is -1
			stripLen = if wrapRound then pathLen else pathLen * (@padInfo[padIdx].endPos - @padInfo[padIdx].startPos)
			intv = @ledInterval
			pathStart = pathLen * @padInfo[padIdx].startPos
			if @padInfo[padIdx].anticlockwise
				intv = -@ledInterval
				pathStart = pathLen * (1 - @padInfo[padIdx].startPos)
			numLeds = Math.floor((stripLen / @ledInterval) + 0.5)
			leds = []
			pPos = pathStart
			pDist = 0
			ledIdx = 0
			ledOffset = Math.abs(@padInfo[padIdx].hiddenLeds)
			ledReversed = (@padInfo[padIdx].hiddenLeds < 0)
			while true
				if pDist >= stripLen
					break
				chainIdx = @padInfo[padIdx].chainIdx + (2 * numLeds + (if ledReversed then -ledIdx else ledIdx) - ledOffset) % numLeds
				if padIdx is 15
					console.log "striplen " + stripLen + " pathLen " + pathLen + " chainIdx " + @padInfo[padIdx].chainIdx + ", mumleds " + numLeds + ", ledrev " + ledReversed + " ledIdx " + ledIdx + " ledOff " + ledOffset + " rslt " + chainIdx
				console.log "stripLen " + stripLen
				leds.push { pt: d.getPointAtLength(pPos), padIdx: padIdx, ledIdx: ledIdx, clr: "#d4d4d4", chainIdx: chainIdx }
				pDist += @ledInterval
				pPos += intv
				ledIdx++
				if wrapRound
					if pPos > pathLen or pPos < 0
						pPos = pPos + (if intv > 0 then -pathLen else pathLen)
			return leds

		ledCount = 0
		for padLedsData in @padLedsList
			ledCount += padLedsData.length
		console.log("Total Leds = " + ledCount)

		@padLeds = svg.selectAll("g.padLeds")
			.data(@padLedsList)
			.enter()
			.append("g")
			.attr("class","padLeds")

		@ledsSel = @padLeds.selectAll(".led")
			.data( (d,i) -> return d )

		@ledsSel
			.enter()
			.append("circle")
		 	.attr("class", "led")
		 	.attr("cx", (d) -> return d.pt.x )
		 	.attr("cy", (d) -> return d.pt.y )
		 	.attr("r", @ledUISize)
		 	.attr("fill", (d,i) -> return d.clr)

		text = svg
			.selectAll("text")
			.data(pad_centers)
			.enter()
			.append("text")

		text
			.attr("x", (d) -> return d[0]-10 )
			.attr("y", (d) -> return d[1]+8 )
			.text((d) -> return d[2])
			.attr("font-family", "sans-serif")
			.attr("font-size", "20px")
			.attr("fill", "#DCDCDC")

		@spideyGraph.createGraph(@padOutlines, @padLedsList, @ledsSel, svg)

		@spideyGraph.colourNodes()
		@spideyGraph.displayNodes()
		@spideyGraph.displayEdges()
		@spideyGraph.labelNodes()
		# @spideyGraph.animate()
		@spideyGraph.enableMouseMove("leds")

		# d3.timer(@stepFn)
		@ledsSel.attr("fill", (d) -> return d.clr)

		return

	stepFn: =>
		@steps++
		if @steps > 1000
			return true

		for padLedsData in @padLedsList
			# clr = '#'+Math.random().toString(16).substr(-6)
			for ledData in padLedsData
				ledData.clr = @spideyAnim.getColour(ledData.pt.x, ledData.pt.y, ledData.padIdx, ledData.ledIdx, @steps)

		@ledsSel.attr("fill", (d) -> return d.clr)

		return false

