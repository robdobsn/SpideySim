class @SpideyGraph

	DEBUG_EDGES: false
	DEBUG_NODES: false

	padAdjacencies: []
	maxDistForPadAdjacency: 300
	maxDistForLedAdjacency: 10
	maxDistForNodeDetect: 10
	maxDistForNodeMerge: 10
	minDistForEndNode: 20
	maxDistForFirstAndLastLedsOnCircularPad: 30

	genColours: (numColours) ->
		# assumes hue [0, 360), saturation [0, 100), lightness [0, 100)
		colourList = []
		for i in [0...360] by 360 / numColours
			hslColour = d3.hsl((i * 1787) % 360, 0.90 + Math.random() * 0.10, 0.50 + Math.random() * 0.10)
			colrStr = hslColour.toString()
			colourList.push colrStr
		return colourList

	dist: (led1, led2) ->
		dx = led1.pt.x - led2.pt.x
		dy = led1.pt.y - led2.pt.y
		return Math.sqrt(dx*dx+dy*dy)

	getCofGforLeds: (ledList) ->
		xSum = 0
		ySum = 0
		for ledId in ledList
			xSum += @padLedsList[ledId.padIdx][ledId.ledIdx].pt.x
			ySum += @padLedsList[ledId.padIdx][ledId.ledIdx].pt.y
		rlstPt = { x: xSum/ledList.length, y: ySum/ledList.length }
		return {pt: rlstPt }

	createGraph: (padOutlines, @padLedsList, @ledsSel, @svg) ->

		# Find pad adjacencies
		for padLedsInfo, padIdx in @padLedsList
			@padAdjacencies.push []
			for otherPadIdx in [0...@padLedsList.length]
				if padIdx is otherPadIdx
					continue
				otherPadLedsInfo = @padLedsList[otherPadIdx]
				if @dist(padLedsInfo[0], otherPadLedsInfo[0]) > @maxDistForPadAdjacency
					continue
				adjFound = false
				for ledInfo, ledIdx in padLedsInfo
					if @dist(ledInfo, otherPadLedsInfo[0]) > @maxDistForPadAdjacency
						continue
					for otherLedInfo, otherLedIdx in otherPadLedsInfo
						if @dist(ledInfo, otherLedInfo) < @maxDistForLedAdjacency
							adjFound = true
							@padAdjacencies[padIdx].push otherPadIdx
							# console.log "adjFound " + padIdx + " .. " + otherPadIdx
							break
					if adjFound
						break

		# Find nodes (multi nodes are multiply connected - ie. degree > 1)
		multiNodeLedsList = []
		edgeNodeLedsList = []
		for padAdjList,padIdx in @padAdjacencies
			for ledInfo,ledIdx in @padLedsList[padIdx]
				ledAdjList = []
				ledUniqPads = []
				# Go around adjacent pads checking for leds within a specific
				# distance of the currently checked led to identify a node
				for otherPadIdx in padAdjList
					ledPadFound = false
					for otherLedInfo,otherLedIdx in @padLedsList[otherPadIdx]
						if @dist(ledInfo, otherLedInfo) < @maxDistForNodeDetect
							if ledAdjList.length is 0
								ledAdjList.push { padIdx: padIdx, ledIdx: ledIdx }
							ledAdjList.push { padIdx: otherPadIdx, ledIdx: otherLedIdx }
							if not ledPadFound
								if otherPadIdx not in ledUniqPads
									ledUniqPads.push otherPadIdx
								ledPadFound = true
							# console.log "Found " + padIdx + "." + ledIdx + " close to " + otherPadIdx + "." + otherLedIdx
				# It's only a multi-node if there are leds clustered together on
				# more than 2 pads 
				if ledUniqPads.length >= 2
					nodeAlreadyInList = false
					for nodeLeds in multiNodeLedsList
						for led in nodeLeds
							if led.padIdx is padIdx
								if led.ledIdx is ledIdx
									nodeAlreadyInList = true
									break
						if nodeAlreadyInList
							break
					if not nodeAlreadyInList
						multiNodeLedsList.push ledAdjList
						# console.log "Node at " + padIdx + ", " + ledIdx + " adj " + ledAdjList.length
				else
					# Check if it's an edge node
					if ledIdx is 0 or ledIdx is @padLedsList[padIdx].length-1
						if ledAdjList.length isnt 0
						 	edgeNodeLedsList.push ledAdjList

		# Rationalise multi-node list
		rationalisedMultiNodeLedsList = []
		for multiNodeLeds, multiNodeLedsIdx in multiNodeLedsList
			curCofG = @getCofGforLeds(multiNodeLeds)
			for otherNodeLedsIdx in [multiNodeLedsIdx+1...multiNodeLedsList.length]
				listMerged = false
				if @dist(curCofG, @getCofGforLeds(multiNodeLedsList[otherNodeLedsIdx])) < @maxDistForNodeMerge
					# merge leds into other list
					for nodeLed in multiNodeLeds
						alreadInList = false
						for otherNodeLed in multiNodeLedsList[otherNodeLedsIdx]
							if nodeLed.padIdx is otherNodeLed.padIdx and nodeLed.ledIdx is otherNodeLed.ledIdx
								alreadInList = true
						if not alreadInList
							multiNodeLedsList[otherNodeLedsIdx].push nodeLed
					listMerged = true
					break
			if not listMerged
				rationalisedMultiNodeLedsList.push { leds: multiNodeLeds, CofG: @getCofGforLeds(multiNodeLeds), nodeDegree: 2 }

		# Rationalise the free nodes
		rationalisedEdgeNodeLedsList = []
		for edgeNodeLeds in edgeNodeLedsList
			curCofG = @getCofGforLeds(edgeNodeLeds)
			discardFree = false
			for nodeLeds in rationalisedMultiNodeLedsList
				if @dist(curCofG, @getCofGforLeds(nodeLeds.leds)) < @minDistForEndNode
					discardFree = true
					break
			for freeLeds in rationalisedEdgeNodeLedsList
				if @dist(curCofG, @getCofGforLeds(freeLeds.leds)) < @minDistForEndNode
					discardFree = true
					break
			if not discardFree
				rationalisedEdgeNodeLedsList.push { leds: edgeNodeLeds, CofG: @getCofGforLeds(edgeNodeLeds), nodeDegree: 1 }

		# Comnbine the node lists
		@nodeList = rationalisedMultiNodeLedsList.concat rationalisedEdgeNodeLedsList

		# Remove duplicated leds from the same pad from nodes
		for nodeInfo in @nodeList
			ledDistances = {}
			curCofG = nodeInfo.CofG
			for nodeLed in nodeInfo.leds
				distFromCofGtoLed = @dist(curCofG, @padLedsList[nodeLed.padIdx][nodeLed.ledIdx])
				# console.log distFromCofGtoLed
				if nodeLed.padIdx of ledDistances
					if ledDistances[nodeLed.padIdx].dist > distFromCofGtoLed
						ledDistances[nodeLed.padIdx].dist = distFromCofGtoLed
						ledDistances[nodeLed.padIdx].padIdx = nodeLed.padIdx
						ledDistances[nodeLed.padIdx].ledIdx = nodeLed.ledIdx				
				else
					ledDistances[nodeLed.padIdx] =
						dist: distFromCofGtoLed
						padIdx: nodeLed.padIdx
						ledIdx: nodeLed.ledIdx
			nodeInfo.leds = []
			for key,val of ledDistances
				nodeInfo.leds.push val
				# console.log val.padIdx, val.ledIdx
			nodeInfo.CofG = @getCofGforLeds(nodeInfo.leds)
			# console.log("")

		# Insert additional info into node
		for node, nodeIdx in @nodeList
			node["nodeId"] = nodeIdx
			for led in node.leds
				led["uniqId"] = led.padIdx * 1000 + led.ledIdx
				led["led"] = @padLedsList[led.padIdx][led.ledIdx]
	
		# Ensure a single led only used in one node
		ledsUsed = {}
		for nodeInfo, nodeIdx in @nodeList
			ledsModified = true
			while ledsModified
				ledsModified = false
				for nodeLed in nodeInfo.leds
					if nodeLed.uniqId of ledsUsed
						otherLedUse = ledsUsed[nodeLed.uniqId]
						if otherLedUse.nodeIdx isnt nodeIdx
							ledInfo = @padLedsList[nodeLed.padIdx][nodeLed.ledIdx]
							ledDist = @dist(ledInfo, @nodeList[nodeIdx].CofG)
							otherLedDist = @dist(ledInfo, @nodeList[otherLedUse.nodeIdx].CofG)
							if ledDist < otherLedDist
								newList = []
								for led in @nodeList[otherLedUse.nodeIdx].leds
									if not (led.padIdx is nodeLed.padIdx and led.ledIdx is nodeLed.ledIdx)
										newList.push led
								@nodeList[otherLedUse.nodeIdx].leds = newList
								ledsUsed[nodeLed.uniqId] = { nodeIdx: nodeIdx }
							else
								newList = []
								for led in @nodeList[nodeIdx].leds
									if not (led.padIdx is nodeLed.padIdx and led.ledIdx is nodeLed.ledIdx)
										newList.push led
								@nodeList[nodeIdx].leds = newList
							ledsModified = true
							break
					else
						ledsUsed[nodeLed.uniqId] = { nodeIdx: nodeIdx }

		# Debug - show the node leds
		if @DEBUG_NODES
			for testNode, testNodeIdx in @nodeList
				oStr = testNodeIdx + " nodeLeds "
				for testNodeLeds in testNode.leds
					oStr += "[" + testNodeLeds.padIdx + "," + testNodeLeds.ledIdx + "] "
				console.log oStr

		# Rationalise nodes
		console.log "InnerNodeList " + rationalisedMultiNodeLedsList.length
		console.log "FreeNodeList " + rationalisedEdgeNodeLedsList.length
		console.log "Combined nodeList " + @nodeList.length

		# Build the graph
		@edgeList = []
		for fullNode in @nodeList
			fullNode.edgesTo = []
		for padAdjList,padIdx in @padAdjacencies
			fromNode = null
			# Go entirely round the pads that are nearly continuous to find all edges
			padCircuit = @padLedsList[padIdx].length
			if @dist(@padLedsList[padIdx][0], @padLedsList[padIdx][padCircuit-1]) < @maxDistForFirstAndLastLedsOnCircularPad
				padCircuit += 5
			for testLedIdx in [0...padCircuit]
			# for ledInfo,ledIdx in @padLedsList[padIdx]
				ledIdx = testLedIdx % @padLedsList[padIdx].length
				ledInfo = @padLedsList[padIdx][ledIdx]
				wrappedRound = testLedIdx >= @padLedsList[padIdx].length
				# Find if this led belogs to any node
				thisNode = null
				for testNode, testNodeIdx in @nodeList
					for testNodeLeds in testNode.leds
						if testNodeLeds.padIdx is padIdx and testNodeLeds.ledIdx is ledIdx
							thisNode = 
								nodeIdx: testNodeIdx
								padIdx: padIdx
								ledIdx: ledIdx
							break
					if thisNode?
						break
				if fromNode? and thisNode? and thisNode.nodeIdx isnt fromNode.nodeIdx
					if @nodeList[fromNode.nodeIdx].nodeDegree > 1 or @nodeList[thisNode.nodeIdx].nodeDegree > 1
						if @DEBUG_EDGES
							console.log "fromNode " + fromNode + " thisNode " + thisNode
						curEdgeIdx = @edgeList.length
						edgeLength = Math.abs(fromNode.ledIdx-thisNode.ledIdx)
						if wrappedRound
							@padLedsList[padIdx].length - edgeLength
						if not @nodeList[fromNode.nodeIdx].edgesTo.some( (el) -> el.toNodeIdx is thisNode.nodeIdx )

							@nodeList[fromNode.nodeIdx].edgesTo.push
							 	toNodeIdx: thisNode.nodeIdx
							 	edgeIdx: curEdgeIdx
							 	edgeLength: edgeLength
							edgeInfo = 
								padIdx: padIdx
								fromNodeIdx: fromNode.nodeIdx
								fromNode: @nodeList[fromNode.nodeIdx]
								fromLedIdx: fromNode.ledIdx
								toNodeIdx: thisNode.nodeIdx
								toNode: @nodeList[thisNode.nodeIdx]
								toLedIdx: thisNode.ledIdx
							@edgeList.push edgeInfo
						if not @nodeList[thisNode.nodeIdx].edgesTo.some( (el) -> el.toNodeIdx is fromNode.nodeIdx )
							@nodeList[thisNode.nodeIdx].edgesTo.push
							 	toNodeIdx: fromNode.nodeIdx
							 	edgeIdx: curEdgeIdx
							 	edgeLength: edgeLength
				if thisNode?
					# console.log "At node " + thisNode + " fromNode=" + fromNode
					fromNode = {}
					for key, val of thisNode
						fromNode[key] = val

		# List nodes and edges
		if @DEBUG_NODES or @DEBUG_EDGES
			for node, nodeIdx in @nodeList
				edgeStr = ""
				for edgeTo in node.edgesTo
					edgeStr += " " + edgeTo.toNodeIdx
				console.log "Node " + nodeIdx + " edgesToNodes " + edgeStr

		# Add edge info to nodes
		for node, nodeIdx in @nodeList
			for edgeTo in node.edgesTo
				# work down edges of pads common to both nodes
				edgeSteps = []
				for nodeLed in node.leds
					padIdx = nodeLed.padIdx
					for toNodeLed in @nodeList[edgeTo.toNodeIdx].leds
						if padIdx is toNodeLed.padIdx
							# find the number of leds in the edge
							numleds = Math.abs(toNodeLed.ledIdx - nodeLed.ledIdx)
							ledInc = if toNodeLed.ledIdx > nodeLed.ledIdx then 1 else -1
							ledBase = nodeLed.ledIdx
							if node.nodeDegree >= 2 and @nodeList[edgeTo.toNodeIdx].nodeDegree >= 2
								wrapRoundNumLeds = @padLedsList[padIdx].length - numleds
								if numleds > wrapRoundNumLeds
									numleds = wrapRoundNumLeds
									ledInc = -ledInc
							if numleds < edgeTo.edgeLength - 1 and numleds > edgeTo.edgeLength - 10
								numleds = Math.abs(toNodeLed.ledIdx - nodeLed.ledIdx)
								ledInc = -ledInc

							if @DEBUG_EDGES
								console.log "edgeLengthDiscrepancy from " + nodeIdx + " to " + edgeTo.toNodeIdx + " expected " + edgeTo.edgeLength + " is " + numleds

							# if numleds < edgeTo.edgeLength - 1 and numleds > edgeTo.edgeLength - 10
							# 	console.log "TESTTESTTEST " + nodeIdx + " to " + edgeTo.toNodeIdx + " expected " + edgeTo.edgeLength + " is " + numleds

							edgeStr2 = ""
							for i in [0...numleds-1]
								if edgeSteps.length <= i
									edgeSteps[i] = []
								tLedIdx = (ledBase+(i+1)*ledInc+@padLedsList[padIdx].length)%@padLedsList[padIdx].length
								edgeSteps[i].push { padIdx: padIdx, ledIdx: tLedIdx, led: @padLedsList[padIdx][tLedIdx]}
								edgeStr2 += tLedIdx + ","

							if @DEBUG_EDGES
								console.log "Edge from " + nodeIdx + " to " + edgeTo.toNodeIdx + " alongPad " + padIdx + " numleds= " + numleds + " fromNodeLed " + nodeLed.ledIdx + " toNodeLed " + toNodeLed.ledIdx + " edgeLeds " + edgeStr2
							if nodeIdx is 39 or nodeIdx is 42
								console.log "Edge from " + nodeIdx + " to " + edgeTo.toNodeIdx + " alongPad " + padIdx + " numleds= " + numleds + " fromNodeLed " + nodeLed.ledIdx + " toNodeLed " + toNodeLed.ledIdx + " edgeLeds " + edgeStr2

				edgeTo.edgeList = edgeSteps

				if @DEBUG_EDGES
					edgeStr3 = "edgeSteps "
					for step in edgeSteps
						for leds in step
							edgeStr3 += leds.padIdx + "." + leds.ledIdx + " "
						edgeStr3 += ", "
					console.log edgeStr3

	colourNodes: ->
		# for edge in @edgeList
		# 	console.log "edge from " + edge.fromNodeIdx + " to node " + edge.toNodeIdx

		# # Edge list
		# edgeList = []
		# for node, nodeIdx in @nodeList
		# 	for edgesTo in node.edgesTo
		# 		edgeList.push { from: { nodeIdx: nodeIdx, pt: node.CofG.pt }, to: { nodeIdx: edgesTo, pt: @nodeList[edgesTo].CofG.pt }}

		colrs = @genColours(@nodeList.length)
		colrIdx = 0
		for nodeLeds in @nodeList
			nodeLeds.colr = colrs[colrIdx++]
		# @nodeList[0].colr = "#000000"
		# for nodeLeds in rationalisedMultiNodeLedsList
		# 	colr = colrs[colrIdx++]
		# 	for nodeLed in nodeLeds.leds
		# 		@padLedsList[nodeLed.padIdx][nodeLed.ledIdx].clr = colr

	displayNodes: ->

		nodesSvg = @svg.selectAll("g.nodes")
			.data(@nodeList)
			.enter()
			.append("g")
			.attr("class","nodes")
			.append("circle")
		 	.attr("class", "node")
		 	.attr("cx", (d) -> return d.CofG.pt.x )
		 	.attr("cy", (d) -> return d.CofG.pt.y )
		 	.attr("r", 5)
		 	.attr("fill", (d,i) -> return d.colr)

		# for nod, nodIdx in @nodeList
		# 	nodStr = "node " + nodIdx + " edges "
		# 	for ed in nod.edgesTo
		# 		nodStr += ed + ", "
		# 	console.log nodStr
		# for edge in @edgeList
		# 	console.log "edge from " + edge.fromNode.nodeIdx + ", to " + edge.toNode.nodeIdx

	displayEdges: ->
		edgesSvg = @svg.selectAll("g.edges")
			.data(@edgeList)
			.enter()
			.append("g")
			.attr("class","edges")
			.append("line")
		 	.attr("class", "edge")
		 	.attr("x1", (d) -> return d.fromNode.CofG.pt.x )
		 	.attr("y1", (d) -> return d.fromNode.CofG.pt.y )
		 	.attr("x2", (d) -> return d.toNode.CofG.pt.x )
		 	.attr("y2", (d) -> return d.toNode.CofG.pt.y )
		 	.attr("stroke", (d,i) -> return 'black')

	labelNodes: ->
		nodeLabels = @svg
			.selectAll(".nodelabels")
			.data(@nodeList)
			.enter()
			.append("text")
			.attr("class","nodelabels")

		nodeLabels
			.attr("x", (d) -> return d.CofG.pt.x+5 )
			.attr("y", (d) -> return d.CofG.pt.y-2 )
			.text((d) -> return d.nodeId)
			.attr("font-family", "sans-serif")
			.attr("font-size", "10px")
			.attr("fill", "#005050")

	animate: ->
		@animNodeIdx = 34
		@animEdgeIdx = 0
		@animEdgeStep = 0
		@atANode = true
		@steps = 0
		d3.timer(@stepFn)

	enableMouseMove: (dispType) ->
		if dispType is "edges"
			@svg.on "mousemove", @mousemoveEdges
		else
			@svg.on "mousemove", @mousemoveLeds
		return

	mousemoveLeds: =>
		x = event.x - 8
		y = event.y - 8
		nearestLed = null
		nearestDist = 1000
		for pad in @padLedsList
			for led, ledIdx in pad
				ledDist = @dist(led, {pt: { x: x, y: y}})
				if ledDist < 20
					if nearestDist > ledDist
						nearestDist = ledDist
						nearestLed = led
		if nearestDist < 1000
			@selectLed(nearestLed)
			@sendLedCmd(nearestLed)
		return

	selectLed: (showLed) ->
		for pad in @padLedsList
			for led in pad
				if led is showLed
					led.clr = "#000000"
				else
					led.clr = "#dcdcdc"
		@ledsSel.attr("fill", (d) -> return d.clr)

	mousemoveEdges: =>
		x = event.x - 8
		y = event.y - 8
		for node, nodeIdx in @nodeList
			if @dist(node.CofG, {pt: { x: x, y: y}}) < 10
				for pad in @padLedsList
					for led in pad
						led.clr = "#dcdcdc"
				for edgesTo in node.edgesTo
					for edgeStep in edgesTo.edgeList
						for led in edgeStep
							@padLedsList[led.padIdx][led.ledIdx].clr = "#000000"
	 
			@ledsSel.attr("fill", (d) -> return d.clr)
		return

				# # console.log "MouseOver " + nodeIdx
				# tmpEdgeList = []
				# edgesStr = ""
				# for edgeTo in node.edgesTo
				# 	tmpEdgeList.push
				# 		fromNode: @nodeList[nodeIdx]
				# 		toNode: @nodeList[edgeTo.toNodeIdx]
				# 	edgesStr += edgeTo.toNodeIdx + " "
				# console.log "Node " + nodeIdx + " edges " + edgesStr
				# animEdgesSvg = @svg.selectAll("g.animedges")
				# .data(tmpEdgeList)

				# animEdgesSvg
				# .enter()
				# .append("g")
				# .attr("class","animedges")
				# .append("line")
			 # 	.attr("class", "edge")
			 # 	.attr("x1", (d) -> return d.fromNode.CofG.pt.x )
			 # 	.attr("y1", (d) -> return d.fromNode.CofG.pt.y )
			 # 	.attr("x2", (d) -> return d.toNode.CofG.pt.x )
			 # 	.attr("y2", (d) -> return d.toNode.CofG.pt.y )
			 # 	.attr("stroke", (d,i) -> return 'blue')

			 # 	animEdgesSvg
			 # 	.exit()
			 # 	.remove()

			 	# break

	toHex: (val, digits) ->
		 return ("000000000000000" + val.toString(16)).slice(-digits);

	sendLedCmd: (showLed) =>

		sss = "http://fractal:5078/rawcmd/01010b02" + @toHex(showLed.chainIdx,4) + "0001ff0000ff0000"
		$.get sss, ( data ) ->
			console.log "sent " + showLed.chainIdx + " = " + sss
		return
		 # + Math.random().toString(16).substr(-6) + Math.random().toString(16).substr(-6)

	stepFn: =>

		@steps++
		if @steps > 10
			@steps = 0
			return false

		for pad in @padLedsList
			for led in pad
				led.clr = "#dcdcdc"

		# If at a node then select an edge randomly
		if @atANode
			@animEdgeIdx = Math.floor(Math.random() * @nodeList[@animNodeIdx].edgesTo.length)
			@atANode = false
			@animEdgeStep = 0
			for nodeLed in @nodeList[@animNodeIdx].leds
				@padLedsList[nodeLed.padIdx][nodeLed.ledIdx].clr = "#000000"
				@sendLedCmd(nodeLed.led)
			# check for zero length edge
			if @nodeList[@animNodeIdx].edgesTo[@animEdgeIdx].edgeList.length == 0
				@animNodeIdx = @nodeList[@animNodeIdx].edgesTo[@animEdgeIdx].toNodeIdx
				@atANode = true
		else
			edgeSteps = @nodeList[@animNodeIdx].edgesTo[@animEdgeIdx].edgeList
			if @animEdgeStep < edgeSteps.length
				for led in edgeSteps[@animEdgeStep]
					@padLedsList[led.padIdx][led.ledIdx].clr = "#000000"
					@sendLedCmd(led.led)
			@animEdgeStep++
			if @animEdgeStep >= edgeSteps.length
				@animNodeIdx = @nodeList[@animNodeIdx].edgesTo[@animEdgeIdx].toNodeIdx
				@atANode = true

		@ledsSel.attr("fill", (d) -> return d.clr)

		return false
