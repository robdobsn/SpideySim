class @SpideyGraph

	padAdjacencies: []
	maxDistForPadAdjacency: 300
	maxDistForLedAdjacency: 10
	maxDistForNodeDetect: 10
	maxDistForNodeMerge: 10
	minDistForEndNode: 20

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
			xSum += @padLedsData[ledId[0]][ledId[1]].pt.x
			ySum += @padLedsData[ledId[0]][ledId[1]].pt.y
		return {pt: { x: xSum/ledList.length, y: ySum/ledList.length } }

	createGraph: (padOutlines, @padLedsData, @ledsSel, svg) ->

		# Find pad adjacencies
		for padLedsInfo, padIdx in padLedsData
			@padAdjacencies.push []
			for otherPadIdx in [0...padLedsData.length]
				if padIdx is otherPadIdx
					continue
				otherPadLedsInfo = padLedsData[otherPadIdx]
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

		# Find nodes
		nodeLedList = []
		# edgeLedList = []
		freeLedList = []
		for padAdjList,padIdx in @padAdjacencies
			for ledInfo,ledIdx in padLedsData[padIdx]
				ledAdjList = []
				ledUniqPads = []
				# Go around adjacent pads checking for leds within a specific
				# distance of the currently checked led to identify a node
				for otherPadIdx in padAdjList
					ledPadFound = false
					for otherLedInfo,otherLedIdx in padLedsData[otherPadIdx]
						if @dist(ledInfo, otherLedInfo) < @maxDistForNodeDetect
							if ledAdjList.length is 0
								ledAdjList.push [padIdx, ledIdx]
							ledAdjList.push [otherPadIdx, otherLedIdx]
							if not ledPadFound
								if otherPadIdx not in ledUniqPads
									ledUniqPads.push otherPadIdx
								ledPadFound = true
							# console.log "Found " + padIdx + "." + ledIdx + " close to " + otherPadIdx + "." + otherLedIdx
				# It's only a node if there are leds clustered together on
				# more than 2 pads 
				if ledUniqPads.length >= 2
					nodeAlreadyInList = false
					for nodeLeds in nodeLedList
						for led in nodeLeds
							if led[0] is padIdx
								if led[1] is ledIdx
									nodeAlreadyInList = true
									break
						if nodeAlreadyInList
							break
					if not nodeAlreadyInList
						nodeLedList.push ledAdjList
						if padIdx is 9
							for led in ledAdjList
								console.log led
							console.log("")
						# console.log "Node at " + padIdx + ", " + ledIdx + " adj " + ledAdjList.length
				else
					if ledIdx == 0 or ledIdx == padLedsData[padIdx].length-1
					 	freeLedList.push ledAdjList

		# Rationalise node list
		nodeRationalisedList = []
		for nodeLeds, nodeLedsIdx in nodeLedList
			curCofG = @getCofGforLeds(nodeLeds)
			for otherNodeLedsIdx in [nodeLedsIdx+1...nodeLedList.length]
				listMerged = false
				if @dist(curCofG, @getCofGforLeds(nodeLedList[otherNodeLedsIdx])) < @maxDistForNodeMerge
					# merge leds into other list
					for nodeLed in nodeLeds
						alreadInList = false
						for otherNodeLed in nodeLedList[otherNodeLedsIdx]
							if nodeLed[0] is otherNodeLed[0] and nodeLed[1] is otherNodeLed[1]
								alreadInList = true
						if not alreadInList
							nodeLedList[otherNodeLedsIdx].push nodeLed
					listMerged = true
					break
			if not listMerged
				nodeRationalisedList.push { leds: nodeLeds, CofG: @getCofGforLeds(nodeLeds), nodeDegree: 2 }

		# Remove duplicated leds from the same pad from nodes
		for nodeLeds, nodeLedsIdx in nodeRationalisedList
			ledDistances = {}
			curCofG = nodeLeds.CofG
			for nodeLed in nodeLeds.leds
				distFromCofGtoLed = @dist(curCofG, @padLedsData[nodeLed[0]][nodeLed[1]])
				console.log distFromCofGtoLed
				if nodeLed[0] of ledDistances
					if ledDistances[nodeLed[0]].dist > distFromCofGtoLed
						ledDistances[nodeLed[0]].dist = distFromCofGtoLed
						ledDistances[nodeLed[0]].padIdx = nodeLed[0]
						ledDistances[nodeLed[0]].ledIdx = nodeLed[1]						
				else
					ledDistances[nodeLed[0]] =
						dist: distFromCofGtoLed
						padIdx: nodeLed[0]
						ledIdx: nodeLed[1]
			nodeLeds.leds = []
			for key,val of ledDistances
				nodeLeds.leds.push [val.padIdx, val.ledIdx]
				console.log val.padIdx, val.ledIdx
			nodeLeds.CofG = @getCofGforLeds(nodeLeds.leds)
			console.log("")

		# Rationalise the free nodes
		freeRationalisedList = []
		for freeNodeLeds, nodeLedsIdx in freeLedList
			curCofG = @getCofGforLeds(freeNodeLeds)
			discardFree = false
			for nodeLeds in nodeRationalisedList
				if @dist(curCofG, @getCofGforLeds(nodeLeds.leds)) < @minDistForEndNode
					discardFree = true
					break
			for freeLeds in freeRationalisedList
				if @dist(curCofG, @getCofGforLeds(freeLeds.leds)) < @minDistForEndNode
					discardFree = true
					break
			if not discardFree
				freeRationalisedList.push { leds: freeNodeLeds, CofG: @getCofGforLeds(freeNodeLeds), nodeDegree: 1 }

		for testNode, testNodeIdx in nodeRationalisedList
			oStr = testNodeIdx + " nodeLeds "
			for testNodeLeds in testNode.leds
				oStr += "[" + testNodeLeds[0] + "," + testNodeLeds[1] + "] "
			console.log oStr

		# Comnbine the node lists
		fullNodeList = nodeRationalisedList.concat freeRationalisedList

		# Rationalise nodes
		console.log "InnerNodeList " + nodeRationalisedList.length
		console.log "FreeNodeList " + freeRationalisedList.length
		console.log "FullNodeList " + fullNodeList.length

		# Build the graph
		@edgeList = []
		for fullNode in fullNodeList
			fullNode.edgesTo = []
		for padAdjList,padIdx in @padAdjacencies
			fromNode = null
			for ledInfo,ledIdx in padLedsData[padIdx]
				# Find if this led belogs to any node
				thisNode = null
				for testNode, testNodeIdx in fullNodeList
					for testNodeLeds in testNode.leds
						if testNodeLeds[0] is padIdx and testNodeLeds[1] is ledIdx
							thisNode = 
								nodeIdx: testNodeIdx
								padIdx: padIdx
								ledIdx: ledIdx
							break
					if thisNode?
						break
				if fromNode? and thisNode? and thisNode.nodeIdx isnt fromNode.nodeIdx
					# console.log "fromNode " + fromNode + " thisNode " + thisNode
					curEdgeIdx = @edgeList.length
					if thisNode.nodeIdx not in fullNodeList[fromNode.nodeIdx].edgesTo
						fullNodeList[fromNode.nodeIdx].edgesTo.push
						 	toNodeIdx: thisNode.nodeIdx
						 	edgeIdx: curEdgeIdx
						edgeInfo = 
							padIdx: padIdx
							fromNodeIdx: fromNode.nodeIdx
							fromNode: fullNodeList[fromNode.nodeIdx]
							fromLedIdx: fromNode.ledIdx
							toNodeIdx: thisNode.nodeIdx
							toNode: fullNodeList[thisNode.nodeIdx]
							toLedIdx: thisNode.ledIdx
						@edgeList.push edgeInfo
					if fromNode.nodeIdx not in fullNodeList[thisNode.nodeIdx].edgesTo
						fullNodeList[thisNode.nodeIdx].edgesTo.push
						 	toNodeIdx: fromNode.nodeIdx
						 	edgeIdx: curEdgeIdx

				if thisNode?
					# console.log "At node " + thisNode + " fromNode=" + fromNode
					fromNode = {}
					for key, val of thisNode
						fromNode[key] = val

		# Edge list
		# edgeList = []
		# for node, nodeIdx in fullNodeList
		# 	for edgesTo in node.edgesTo
		# 		edgeList.push { from: { nodeIdx: nodeIdx, pt: node.CofG.pt }, to: { nodeIdx: edgesTo, pt: fullNodeList[edgesTo].CofG.pt }}

		colrs = @genColours(fullNodeList.length)
		colrIdx = 0
		console.log "NumNodes = " + fullNodeList.length
		for nodeLeds in fullNodeList
			nodeLeds.colr = colrs[colrIdx++]
		# fullNodeList[0].colr = "#000000"
		# for nodeLeds in nodeRationalisedList
		# 	colr = colrs[colrIdx++]
		# 	for nodeLed in nodeLeds.leds
		# 		padLedsData[nodeLed[0]][nodeLed[1]].clr = colr

		nodesSvg = svg.selectAll("g.nodes")
			.data(fullNodeList)
			.enter()
			.append("g")
			.attr("class","nodes")
			.append("circle")
		 	.attr("class", "node")
		 	.attr("cx", (d) -> return d.CofG.pt.x )
		 	.attr("cy", (d) -> return d.CofG.pt.y )
		 	.attr("r", 5)
		 	.attr("fill", (d,i) -> return d.colr)

		# for nod, nodIdx in fullNodeList
		# 	nodStr = "node " + nodIdx + " edges "
		# 	for ed in nod.edgesTo
		# 		nodStr += ed + ", "
		# 	console.log nodStr
		# for edge in @edgeList
		# 	console.log "edge from " + edge.fromNode.nodeIdx + ", to " + edge.toNode.nodeIdx

		edgesSvg = svg.selectAll("g.edges")
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

		@animEdgeIdx = 0
		@steps = 0
		d3.timer(@stepFn)


	stepFn: =>

		if @steps == 0
			if @animEdgeIdx > 0
				edge = @edgeList[@animEdgeIdx-1]
				for ledIdx in [edge.fromLedIdx..edge.toLedIdx]
					@padLedsData[edge.padIdx][ledIdx].clr = "#dcdcdc"
			edge = @edgeList[@animEdgeIdx]
			for ledIdx in [edge.fromLedIdx..edge.toLedIdx]
				@padLedsData[edge.padIdx][ledIdx].clr = "#000000"
	 
			@ledsSel.attr("fill", (d) -> return d.clr)

		@steps++
		if @steps > 10
			@animEdgeIdx++
			@steps = 0
			if @animEdgeIdx >= @edgeList.length
				return true

		return false
