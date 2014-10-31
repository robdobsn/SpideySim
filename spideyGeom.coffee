class @spideyGeom

	ledInterval: 6.9
	steps: 0
	ledUISize: 3

	padInfo: [
		{ chainIdx: 780, startPos: 0, endPos: -1, hiddenLeds: 47, anticlockwise: true }, #0
		{ chainIdx: 540, startPos: 0.35, endPos: 0.99, hiddenLeds: 0, anticlockwise: true }, #1
		{ chainIdx: 878, startPos: 0, endPos: -1, hiddenLeds: 17, anticlockwise: true }, #2
		{ chainIdx: 1180, startPos: 0, endPos: 0.71, hiddenLeds: 0, anticlockwise: true }, #3
		{ chainIdx: 1086, startPos: 0, endPos: -1, hiddenLeds: 9, anticlockwise: true }, #4
		{ chainIdx: 0, startPos: 0, endPos: -1, hiddenLeds: 7, anticlockwise: true }, #5
		{ chainIdx: 678, startPos: 0, endPos: -1, hiddenLeds: 42, anticlockwise: true }, #6
		{ chainIdx: 1260, startPos: 0, endPos: -1, hiddenLeds: 34, anticlockwise: true }, #7
		{ chainIdx: 628, startPos: 0, endPos: -1, hiddenLeds: -32, anticlockwise: true }, #8
		{ chainIdx: 222, startPos: 0, endPos: -1, hiddenLeds: -7, anticlockwise: true }, #9
		{ chainIdx: 276, startPos: 0, endPos: -1, hiddenLeds: -27, anticlockwise: true }, #10
		{ chainIdx: 1414, startPos: 0, endPos: -0.98, hiddenLeds: 30, anticlockwise: true }, #11
		{ chainIdx: 174, startPos: 0, endPos: -1, hiddenLeds: 37, anticlockwise: true }, #12
		{ chainIdx: 579, startPos: 0, endPos: -1, hiddenLeds: 36, anticlockwise: true }, #13
		{ chainIdx: 1134, startPos: 0, endPos: -0.99, hiddenLeds: 10, anticlockwise: true }, #14
		{ chainIdx: 323, startPos: 0.36, endPos: 0.98, hiddenLeds: 0, anticlockwise: true }, #15
		{ chainIdx: 386, startPos: 0, endPos: -1, hiddenLeds: -38, anticlockwise: true }, #16
		{ chainIdx:	431, startPos: 0, endPos: -1, hiddenLeds: 13, anticlockwise: true }, #17
		{ chainIdx: 1524, startPos: 0, endPos: -0.98, hiddenLeds: 27, anticlockwise: true }, #18
		{ chainIdx: 1556, startPos: 0, endPos: -0.96, hiddenLeds: 32, anticlockwise: true }, #19
		{ chainIdx: 94, startPos: 0, endPos: -1, hiddenLeds: -26, anticlockwise: true }, #20
		{ chainIdx: 132, startPos: 0, endPos: -1, hiddenLeds: -5, anticlockwise: true }, #21
		{ chainIdx: 1609, startPos: 0.2, endPos: 1.0, hiddenLeds: 0, anticlockwise: false }, #22
		{ chainIdx: 1472, startPos: 0.34, endPos: 0.98, hiddenLeds: 0, anticlockwise: false }, #23
		{ chainIdx: 348, startPos: 0, endPos: -1, hiddenLeds: 8, anticlockwise: true }, #24
		{ chainIdx: 1590, startPos: 0.02, endPos: 0.49, hiddenLeds: 0, anticlockwise: true }, #25
		{ chainIdx: 1637, startPos: 0.25, endPos: 1.0, hiddenLeds: 0, anticlockwise: false }, #26
		{ chainIdx: 1304, startPos: 0.01, endPos: 0.70, hiddenLeds: 0, anticlockwise: true }, #27
		{ chainIdx: 308, startPos: 0.01, endPos: 0.51, hiddenLeds: 14, anticlockwise: true }, #28
		{ chainIdx: 466, startPos: 0.01, endPos: 0.64, hiddenLeds: 0, anticlockwise: true }, #29
		{ chainIdx: 1665, startPos: 0.02, endPos: 0.55, hiddenLeds: 0, anticlockwise: true }, #30
		{ chainIdx: 1498, startPos: 0.37, endPos: 1.00, hiddenLeds: 0, anticlockwise: false }, #31
		{ chainIdx: 1448, startPos: 0.35, endPos: 0.96, hiddenLeds: 0, anticlockwise: false }, #32
		{ chainIdx: 732, startPos: 0, endPos: -0.98, hiddenLeds: 34, anticlockwise: true }, #33
		{ chainIdx: 1346, startPos: 0.37, endPos: 0.98, hiddenLeds: 0, anticlockwise: false }, #34
		{ chainIdx: 1220, startPos: 0.01, endPos: 0.72, hiddenLeds: 0, anticlockwise: true }, #35
		{ chainIdx: 1376, startPos: 0, endPos: -1, hiddenLeds: -27, anticlockwise: true }, #36
		{ chainIdx: 56, startPos: 0, endPos: -1, hiddenLeds: 30, anticlockwise: true }, #37
		{ chainIdx: 516, startPos: 0.01, endPos: 0.55, hiddenLeds: 0, anticlockwise: true }, #38
		{ chainIdx: 836, startPos: 0.02, endPos: 0.68, hiddenLeds: 0, anticlockwise: true }, #39
		{ chainIdx: 1040, startPos: 0, endPos: -1, hiddenLeds: 39, anticlockwise: true }, #40
		{ chainIdx: 1000, startPos: 0.01, endPos: 0.75, hiddenLeds: 0, anticlockwise: true }, #41
		{ chainIdx: 934, startPos: 0.03, endPos: 0.78, hiddenLeds: 0, anticlockwise: true }, #42
		{ chainIdx: 974, startPos: 0.2, endPos: 0.69, hiddenLeds: 0, anticlockwise: true }, #43
		{ chainIdx: 490, startPos: 0.01, endPos: 0.67, hiddenLeds: 0, anticlockwise: true }, #44
	]

	init: ->

		@spideyAnim = new SpideyAnimation()
		@spideyGraph = new SpideyGraph()

		svg = d3.select("#spideyGeom svg");
		@padOutlines = svg.selectAll("path");

		@pad_centers = @padOutlines[0].map (d, padIdx) ->
			bbox = d.getBBox()
			return [bbox.x + bbox.width/2, bbox.y + bbox.height/2, padIdx]

		@padLedsList = @padOutlines[0].map (d, padIdx) =>
			pathLen = d.getTotalLength()
			wrapRound = @padInfo[padIdx].endPos < 0
			stripLen = pathLen * Math.abs(@padInfo[padIdx].endPos - @padInfo[padIdx].startPos)
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
				if pDist >= stripLen - (@ledInterval/2)
					break
				chainIdx = @padInfo[padIdx].chainIdx + (2 * numLeds + (if ledReversed then -ledIdx else ledIdx) - ledOffset) % numLeds
				# if padIdx is 15
				# 	console.log "striplen " + stripLen + " pathLen " + pathLen + " chainIdx " + @padInfo[padIdx].chainIdx + ", mumleds " + numLeds + ", ledrev " + ledReversed + " ledIdx " + ledIdx + " ledOff " + ledOffset + " rslt " + chainIdx
				# console.log "stripLen " + stripLen
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

		# Colour first LED in each pad black
		for padLedsData in @padLedsList
			padLedsData[0].clr = "#000000"

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
			.data(@pad_centers)
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

		@showDownloadJsonLink()

		@spideyGraph.colourNodes()
		# @spideyGraph.displayNodes()
		@spideyGraph.displayEdges()
		@spideyGraph.labelNodes()
		# @spideyGraph.animate()
		# @spideyGraph.enableMouseMove("leds")

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

	getNodeExportInfo: (node) ->
		rtnData =
			centre: node.CofG.pt
			nodeDegree: node.nodeDegree
			name: node.nodeId
			LEDs: ( { ledIdx: nodeLed.led.chainIdx } for nodeLed in node.leds )
		return rtnData

	getLinkExportInfo: () ->
		rtnData = []
		for node in @spideyGraph.nodeList
			for edgeTo in node.edgesTo
				oneLink =
					source: node.nodeId
					target: edgeTo.toNodeIdx
					length: edgeTo.edgeLength
					padEdges: edgeTo.edgeLedsList
				rtnData.push oneLink
		return rtnData

	flatten_array: (a) ->
		unless a?
			return null
		else if a.length is 0
			return []
		else
			return ( a.reduce (l,r)->l.concat(r) )

	getLedsExportInfo: ->
		# leds = ( led for led in pad for pad in @padLedsList)
		leds = @flatten_array @padLedsList
		renamedLeds = []
		for led in leds
			newLed =
				centre: led.pt
				ledIdx: led.chainIdx
				padIdx: led.padIdx
			renamedLeds.push newLed
		renamedLeds.sort (a,b) ->
			return a.ledIdx - b.ledIdx
		return renamedLeds

	getPadsExportInfo: ->
		padsList = []
		for padCentre in @pad_centers
			padInfo = 
				centre: { x: padCentre[0], y: padCentre[1] }
			padsList.push padInfo
		for padLeds, padIdx in @padLedsList
			leds = []
			for led in padLeds
				leds.push
					ledIdx: led.chainIdx
			padsList[padIdx].LEDs = leds
		return padsList

	showDownloadJsonLink: ->
		spideyGeomToExport =
			LEDs: @getLedsExportInfo()
			Pads: @getPadsExportInfo()
			nodes: ( @getNodeExportInfo(node) for node in @spideyGraph.nodeList )
			links: @getLinkExportInfo()

		spideyGeomJson = "text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(spideyGeomToExport))
		$('<a href="data:' + spideyGeomJson + '" download="SpideyGeometry.json">Download Spidey JSON</a>').appendTo('#downloadSpideyJson')
