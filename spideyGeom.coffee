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
		{ chainIdx: 1448, startPos: 0.35, endPos: 0.98, hiddenLeds: 0, anticlockwise: false }, #32
		{ chainIdx: 732, startPos: 0, endPos: -0.98, hiddenLeds: 34, anticlockwise: true }, #33
		{ chainIdx: 1346, startPos: 0.37, endPos: 1.00, hiddenLeds: 0, anticlockwise: false }, #34
		{ chainIdx: 1220, startPos: 0.01, endPos: 0.72, hiddenLeds: 0, anticlockwise: true }, #35
		{ chainIdx: 1376, startPos: 0, endPos: -1, hiddenLeds: -27, anticlockwise: true }, #36
		{ chainIdx: 56, startPos: 0, endPos: -1, hiddenLeds: 30, anticlockwise: true }, #37
		{ chainIdx: 516, startPos: 0.01, endPos: 0.55, hiddenLeds: 0, anticlockwise: true }, #38
		{ chainIdx: 836, startPos: 0.02, endPos: 0.68, hiddenLeds: 0, anticlockwise: true }, #39
		{ chainIdx: 1040, startPos: 0, endPos: -1, hiddenLeds: 39, anticlockwise: true }, #40
		{ chainIdx: 1000, startPos: 0.01, endPos: 0.73, hiddenLeds: 0, anticlockwise: true }, #41
		{ chainIdx: 934, startPos: 0.03, endPos: 0.78, hiddenLeds: 0, anticlockwise: true }, #42
		{ chainIdx: 974, startPos: 0.2, endPos: 0.69, hiddenLeds: 0, anticlockwise: true }, #43
		{ chainIdx: 490, startPos: 0.01, endPos: 0.67, hiddenLeds: 0, anticlockwise: true }, #44
	]

	init: ->

		@spideyAnim = new SpideyAnimation()
		@spideyGraph = new SpideyGraph()
		@spideyPacMan = new SpideyPacMan(this)

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
			.enter()
			.append("circle")
		 	.attr("class", "led")
		 	.attr("cx", (d) -> return d.pt.x )
		 	.attr("cy", (d) -> return d.pt.y )
		 	.attr("r", @ledUISize)
		 	.attr("fill", (d,i) -> return d.clr)
		 	.text((d,i) -> return d.chainIdx + " ")

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
		#d3.timer(@spideyPacMan.step())
		@spideyTimer = setInterval(@pacManStep, 200)
		clearInterval(@spideyTimer)

		$("#startSpidey").click =>
			clearInterval(@spideyTimer)
			@spideyTimer = setInterval(@pacManStep, 200)
			@showDebug()
		$("#pauseSpidey").click =>
			clearInterval(@spideyTimer)
		$("#steprightSpidey").click =>
			@spideyPacMan.mouseover('right')
			@pacManStep()
		$("#stepleftSpidey").click =>
			@spideyPacMan.mouseover('left')
			@pacManStep()
		$("#stepSpidey").click =>
			@spideyPacMan.mouseover('forward')
			@pacManStep()
		$("#stepbackSpidey").click =>
			@spideyPacMan.mouseover('back')
			@pacManStep()
		$("#moveup").mousemove =>
			@spideyPacMan.mouseover('forward')
		$("#movedown").mousemove =>
			@spideyPacMan.mouseover('back')
		$("#moveleft").mousemove =>
			@spideyPacMan.mouseover('left')
		$("#moveright").mousemove =>
			@spideyPacMan.mouseover('right')
		$(".led").mousemove (ev) =>
			ledIdx = parseInt(ev.currentTarget.textContent)
			ledInfo = @ledsChainList[ledIdx]
			$("#DebugInfo3").text(ev.currentTarget.textContent + " P" + ledInfo.padIdx + " PL" + ledInfo.ledIdx)

		@ledsSel.attr("fill", (d) -> return d.clr)

		ledsChain = @flatten_array @padLedsList
		@ledsChainList = []
		for led in ledsChain
			@ledsChainList[led.chainIdx] = led

		return

	pacManStep: () =>		
		@spideyPacMan.step()
		@showDebug()

	showDebug: () ->
		dbg = @spideyPacMan.getDebugInfo()
		$('#DebugInfo').text(dbg)
		return

	d2h: (d) ->
		return d.toString(16)

	h2d: (h) ->
		return parseInt(h,16)

	zeropad: (n, width, z) ->
		z = z || '0'
		n = n + ''
		return if n.length >= width then n else new Array(width - n.length + 1).join(z) + n

	execSpideyCmd: (cmdParams) ->
		console.log "Sending " + cmdParams 
		$.ajax cmdParams,
			type: "GET"
			dataType: "text"
			success: (data, textStatus, jqXHR) =>
				return
			error: (jqXHR, textStatus, errorThrown) =>
				console.error ("Direct exec command failed: " + textStatus + " " + errorThrown + " COMMAND=" + cmdParams)
		return

	sendLedCmd: (ledChainIdx, ledclr) ->
		clrStr = if ledclr is "white" then "000000" else "800000"
		if ledclr isnt "white"
			@ipCmdBuf += "000802" + @zeropad(@d2h(ledChainIdx), 4) + "0001" + clrStr
		return

	setNodeColour: (nodeIdx, disp, colour) ->
		node = @spideyGraph.nodeList[nodeIdx]
		dbg = ""
		for nodeLed in node.leds
			if disp
				nodeLed.led.clr = colour
			else
				nodeLed.led.clr = "white"
			@sendLedCmd(nodeLed.led.chainIdx, nodeLed.led.clr)
			dbg += "P" + nodeLed.padIdx + " X" + nodeLed.ledIdx + " C" + nodeLed.led.chainIdx + ", "
		$('#DebugInfo2').text(dbg)
		return

	setLinkColour: (nodeIdx, linkIdx, linkStep, disp, colour) ->
		node = @spideyGraph.nodeList[nodeIdx]
		link = node.edgesTo[linkIdx]
		dbg = ""
		if linkStep < link.edgeList.length
			for edgeLeds in link.edgeList[linkStep]
				led = edgeLeds.led
				dbg += "P" + led.padIdx + " X" + led.ledIdx + " C" + led.chainIdx + ", "
				if disp
					led.clr = colour
				else
					led.clr = "white"
				@sendLedCmd(led.chainIdx, led.clr)
		else
			dbg = "ListLenErr"
		$('#DebugInfo2').text(dbg)
		return

	getNodeXY: (nodeIdx) ->
		return @spideyGraph.nodeList[nodeIdx].CofG.pt

	getLinkLedXY: (nodeIdx, linkIdx, linkStep) ->
		return @spideyGraph.nodeList[nodeIdx].edgesTo[linkIdx].edgeList[linkStep][0].led.pt

	getNumLinks: (nodeIdx) ->
		return @spideyGraph.nodeList[nodeIdx].edgesTo.length

	getLinkLength: (nodeIdx, linkIdx) ->
		return @spideyGraph.nodeList[nodeIdx].edgesTo[linkIdx].edgeList.length

	getLinkTarget: (nodeIdx, linkIdx) ->
		return @spideyGraph.nodeList[nodeIdx].edgesTo[linkIdx].toNodeIdx

	preShowAll: () ->
		@ipCmdBuf = ""

	showAll: () ->
		@ledsSel.attr("fill", (d) -> return d.clr)
		@ipCmdBuf = "0000000101" + @ipCmdBuf + "00"
		@execSpideyCmd("http://macallan:5078/rawcmd/" + @ipCmdBuf)
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
			x: node.CofG.pt.x
			y: node.CofG.pt.y
			nodeDegree: node.nodeDegree
			name: node.nodeId
			ledIdxs: ( nodeLed.led.chainIdx for nodeLed in node.leds )
			linkIdxs: ( edgeTo.linkListIdx for edgeTo in node.edgesTo )
		return rtnData

	angle: (x1, y1, x2, y2) ->
		return Math.atan2(y2-y1, x2-x1) * 180 / Math.PI

	getLinkExportInfo: () ->
		rtnData = []
		for node in @spideyGraph.nodeList
			for edgeTo in node.edgesTo
				edgeTo.linkListIdx = rtnData.length
				toNode = @spideyGraph.nodeList[edgeTo.toNodeIdx]
				oneLink =
					linkIdx: rtnData.length
					source: node.nodeId
					xSource: node.CofG.pt.x
					ySource: node.CofG.pt.y
					target: edgeTo.toNodeIdx
					xTarget: toNode.CofG.pt.x
					yTarget: toNode.CofG.pt.y
					linkAngle: @angle(node.CofG.pt.x, node.CofG.pt.y, toNode.CofG.pt.x, toNode.CofG.pt.y)
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
		finalLeds = []
		for led in leds
			newLed =
				x: led.pt.x
				y: led.pt.y
				ledIdx: led.chainIdx
				padIdx: led.padIdx
			finalLeds[led.chainIdx] = newLed
		for led, ledIdx in finalLeds
			if not led?
				finalLeds[ledIdx] =
					x: 0
					y: 0
					ledIdx: -1
					padIdx: -1
		return finalLeds

	getPadsExportInfo: ->
		padsList = []
		for padCentre in @pad_centers
			padInfo = 
				x: padCentre[0]
				y: padCentre[1]
			padsList.push padInfo
		for padLeds, padIdx in @padLedsList
			leds = []
			for led in padLeds
				leds.push led.chainIdx
			padsList[padIdx].ledIdxs = leds
			padsList[padIdx].padIdx = padIdx
		return padsList

	convLedListForPad: (ledList) ->
		if ledList.length is 0
			return "{ -1, -1 },"
		ledList.sort (a,b) ->
			return a-b
		return "{ #{ledList[0]}, #{ledList[ledList.length-1]} },"

	convertPadsToMbedHeader: (spideyGeomToExport) ->
		outText = ""
		outLine = """
			// Spidey pads

			struct SpideyPadInfo
			{
				int padLeds[2];
			};

			static const SpideyPadInfo _spideyPads[] =
			{

		"""
		for pad in spideyGeomToExport.pads
			outLine += "\t" + @convLedListForPad(pad.ledIdxs) + "\n"
		outLine += """
			};

		"""
		outText += outLine
		return outText

	convLedListToMbedSeq: (ledList) ->
		edgeLen = 0
		if not ledList? or ledList.ledIdxs.length is 0
			return [ edgeLen, "{ -1, -1 }" ]
		lastLed = -10
		seqLen = 1
		ledSeqText = "{ "
		for led, ledIdx in ledList.ledIdxs
			if ledIdx is 0
				ledSeqText += "#{led}, "
			else if (led+1 isnt lastLed) and (led-1 isnt lastLed)
				ledSeqText += "#{lastLed}, #{led}, "
				seqLen += 1
			if ledIdx is ledList.ledIdxs.length-1
				ledSeqText += "#{led} "
			lastLed = led
		ledSeqText += " }"
		if seqLen > 2
			console.log "Seq Length > 2 ==== " + seqLen
		return [ ledList.ledIdxs.length, ledSeqText ]

	convNodeToMbedSeq: (node, spideyGeomToExport) ->
		# Links
		outText = ""
		links = (link for link in spideyGeomToExport.links when link.source is node.name)
		linkHIds = []
		for link, linkIdx in links
			linkHId = "__spideyLink_#{link.source}_#{link.target}"
			linkHIds.push(linkHId)
			if link.padEdges.length isnt 2
				console.log "Link PadEdges != 2 === " + link.padEdges.length + " for link from " + link.source + " to " + link.target
			ledListA = @convLedListToMbedSeq link.padEdges[0]
			ledListB = @convLedListToMbedSeq link.padEdges[1]
			outText += """
				static const SpideyLinkInfo #{linkHId} =
				{
					#{link.source},
					#{link.target},
					#{ledListA[0]},
					#{ledListA[1]},
					#{ledListB[0]},
					#{ledListB[1]}
				};

			"""

		# Links for each node
		nodeListHeaderText = """
			\t{
				\t#{node.ledIdxs.length},
				\t{
		"""
		for nodeLed in node.ledIdxs
			nodeListHeaderText += " " + nodeLed + ", "
		nodeListHeaderText += """
				},
				\t\t#{linkHIds.length},
				\t\t{
		"""

		for linkHId in linkHIds
			nodeListHeaderText += " &" + linkHId + ", "
		nodeListHeaderText += """
				}
			\t},

		"""
		return [ nodeListHeaderText, outText, linkHIds ]

	convertNodesToMbedHeader: (spideyGeomToExport) ->
		outText = ""
		outLine = """

			// Spidey Node Information Elements

			const int MAX_SPIDEY_NODE_LEDS = 4;
			const int MAX_SPIDEY_NODE_LINKS = 6;
			const int MAX_SPIDEY_LINK_ELS = 4;

			struct SpideyLinkInfo
			{
				int fromNode;
			    int toNode;
			    int edgeLengthA;
			    int edgeLedsA[MAX_SPIDEY_LINK_ELS];
			    int edgeLengthB;
			    int edgeLedsB[MAX_SPIDEY_LINK_ELS];
			};

			struct SpideyNodeInfo
			{
				int numNodeLeds;
			    int nodeLeds[MAX_SPIDEY_NODE_LEDS];
			    int numLinks;
			    const SpideyLinkInfo* nodeLinks[MAX_SPIDEY_NODE_LINKS];
			};


		"""

		# The links
		nodeListHeaderText = []
		linkHIdsList = []
		for node in spideyGeomToExport.nodes
			nodeTexts = @convNodeToMbedSeq(node, spideyGeomToExport)
			nodeListHeaderText.push nodeTexts[0] + "\n"
			outLine += nodeTexts[1] + "\n"
			for linkHId in nodeTexts[2]
				linkHIdsList.push(linkHId)

		# The list of nodes
		outLine += """

			// List of Spidey Wall nodes

			static const SpideyNodeInfo _spideyNodes[] = 
			{

		"""
		for nodeLine in nodeListHeaderText
			outLine += nodeLine
		outLine += """
			};

		"""
		outText += outLine

		# List of links
		outLine = """
			
			const static SpideyLinkInfo* _spideyLinks[] =
			{

		"""
		for linkHid in linkHIdsList
			outLine += "\t&" + linkHid + ",\n"
		outLine += "};"
		outText += outLine

		return outText

	convertToMbedHeader: (spideyGeomToExport) ->
		outText = """
			// Header file generated by SpideySim HTML
			// Rob Dobson, 2015


		"""
		outText += @convertPadsToMbedHeader(spideyGeomToExport)
		outText += @convertNodesToMbedHeader(spideyGeomToExport)
		return outText

	showDownloadJsonLink: ->
		@spideyGeomFinal =
			leds: @getLedsExportInfo()
			pads: @getPadsExportInfo()
			links: @getLinkExportInfo()
			nodes: ( @getNodeExportInfo(node) for node in @spideyGraph.nodeList )

		spideyGeomJson = "text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(@spideyGeomFinal, (key,val) -> return if val.toFixed then Number(val.toFixed(2)) else val ))
		$('<a href="data:' + spideyGeomJson + '" download="SpideyGeometry.json">Download Spidey JSON</a>').appendTo('#downloadSpideyJson')
		spideyGeomMbed = "text/text;charset=utf-8," + encodeURIComponent(@convertToMbedHeader(@spideyGeomFinal))
		$('<a href="data:' + spideyGeomMbed + '" download="SpideyGeometry.h">Download Spidey MBED</a>').appendTo('#downloadSpideyMbed')
