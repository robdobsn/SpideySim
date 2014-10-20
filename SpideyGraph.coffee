class @SpideyGraph

	padAdjacencies: []
	maxDistForPadAdjacency: 300
	maxDistForLedAdjacency: 10
	maxDistForNodeDetect: 11
	maxDistForNodeMerge: 10

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

	getCofGforLeds: (padLedsData, ledList) ->
		xSum = 0
		ySum = 0
		for ledId in ledList
			xSum += padLedsData[ledId[0]][ledId[1]].pt.x
			ySum += padLedsData[ledId[0]][ledId[1]].pt.y
		return {pt: { x: xSum/ledList.length, y: ySum/ledList.length } }

	createGraph: (padOutlines, padLedsData, svg) ->

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
				ledUniqPads = 0
				for otherPadIdx in padAdjList
					ledPadFound = false
					for otherLedInfo,otherLedIdx in padLedsData[otherPadIdx]
						if @dist(ledInfo, otherLedInfo) < @maxDistForNodeDetect
							if ledAdjList.length is 0
								ledAdjList.push [padIdx, ledIdx]
							ledAdjList.push [otherPadIdx, otherLedIdx]
							if not ledPadFound
								ledUniqPads++
								ledPadFound = true
							# console.log "Found " + padIdx + "." + ledIdx + " close to " + otherPadIdx + "." + otherLedIdx
				if ledUniqPads >= 2
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
						# console.log "Node at " + padIdx + ", " + ledIdx + " adj " + ledAdjList.length
				else
					if ledIdx == 0 or ledIdx == padLedsData[padIdx].length-1
					 	freeLedList.push ledAdjList

		# Rationalise node list
		nodeRationalisedList = []
		for nodeLeds, nodeLedsIdx in nodeLedList
			curCofG = @getCofGforLeds(padLedsData, nodeLeds)
			for otherNodeLedsIdx in [nodeLedsIdx+1...nodeLedList.length]
				listMerged = false
				if @dist(curCofG, @getCofGforLeds(padLedsData, nodeLedList[otherNodeLedsIdx])) < @maxDistForNodeMerge
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
				nodeRationalisedList.push { leds: nodeLeds, CofG: @getCofGforLeds(padLedsData, nodeLeds), nodeDegree: 2 }

		# Rationalise the free nodes
		freeRationalisedList = []
		for freeNodeLeds, nodeLedsIdx in freeLedList
			curCofG = @getCofGforLeds(padLedsData, freeNodeLeds)
			discardFree = false
			for nodeLeds in nodeRationalisedList
				if @dist(curCofG, @getCofGforLeds(padLedsData, nodeLeds.leds)) < @maxDistForNodeMerge
					discardFree = true
					break
			for freeLeds in freeRationalisedList
				if @dist(curCofG, @getCofGforLeds(padLedsData, freeLeds.leds)) < @maxDistForNodeMerge
					discardFree = true
					break
			if not discardFree
				freeRationalisedList.push { leds: freeNodeLeds, CofG: @getCofGforLeds(padLedsData, freeNodeLeds), nodeDegree: 1 }

		# Comnbine the node lists
		fullNodeList = nodeRationalisedList.concat freeRationalisedList

		# Rationalise nodes
		console.log "InnerNodeList " + nodeRationalisedList.length
		console.log "FreeNodeList " + freeRationalisedList.length
		console.log "FullNodeList " + fullNodeList.length

		# for testNode, testNodeIdx in fullNodeList
		# 	oStr = testNodeIdx + " nodeLeds "
		# 	for testNodeLeds in testNode.leds
		# 		oStr += "[" + testNodeLeds[0] + "," + testNodeLeds[1] + "] "
		# 	console.log oStr

		# Build the graph
		for fullNode in fullNodeList
			fullNode.edgesTo = []
		for padAdjList,padIdx in @padAdjacencies
			fromNode = -1
			for ledInfo,ledIdx in padLedsData[padIdx]
				# Find if this led belogs to any node
				thisNode = -1
				for testNode, testNodeIdx in fullNodeList
					for testNodeLeds in testNode.leds
						if testNodeLeds[0] is padIdx and testNodeLeds[1] is ledIdx
							thisNode = testNodeIdx
							break
					if thisNode isnt -1
						break
				if fromNode isnt -1 and thisNode isnt -1 and thisNode isnt fromNode
					# console.log "fromNode " + fromNode + " thisNode " + thisNode
					if thisNode not in fullNodeList[fromNode].edgesTo
						fullNodeList[fromNode].edgesTo.push thisNode
					if fromNode not in fullNodeList[thisNode].edgesTo
						fullNodeList[thisNode].edgesTo.push fromNode
				if thisNode isnt -1
					# console.log "At node " + thisNode + " fromNode=" + fromNode
					fromNode = thisNode

		# Edge list
		edgeList = []
		for node, nodeIdx in fullNodeList
			for edgesTo in node.edgesTo
				edgeList.push { from: { nodeIdx: nodeIdx, pt: node.CofG.pt }, to: { nodeIdx: edgesTo, pt: fullNodeList[edgesTo].CofG.pt }}

		colrs = @genColours(fullNodeList.length)
		colrIdx = 0
		console.log "NumNodes = " + fullNodeList.length
		for nodeLeds in fullNodeList
			nodeLeds.colr = colrs[colrIdx++]
		fullNodeList[0].colr = "#000000"
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
		for edge in edgeList
			console.log "edge from " + edge.from.nodeIdx + ", to " + edge.to.nodeIdx

		edgesSvg = svg.selectAll("g.edges")
			.data(edgeList)
			.enter()
			.append("g")
			.attr("class","edges")
			.append("line")
		 	.attr("class", "edge")
		 	.attr("x1", (d) -> 
		 		console.log d
		 		return d.from.pt.x )
		 	.attr("y1", (d) -> return d.from.pt.y )
		 	.attr("x2", (d) -> return d.to.pt.x )
		 	.attr("y2", (d) -> return d.to.pt.y )
		 	.attr("stroke", (d,i) -> return 'black')
