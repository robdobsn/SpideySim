class @SpideyGraph

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
			xSum += @padLedsData[ledId[0]][ledId[1]].pt.x
			ySum += @padLedsData[ledId[0]][ledId[1]].pt.y
		return {pt: { x: xSum/ledList.length, y: ySum/ledList.length } }

	createGraph: (padOutlines, @padLedsData, @ledsSel, @svg) ->

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

		# Comnbine the node lists
		@fullNodeList = nodeRationalisedList.concat freeRationalisedList
		for node,nodeIdx in @fullNodeList
			node["nodeId"] = nodeIdx

		# Remove duplicated leds from the same pad from nodes
		for nodeInfo in @fullNodeList
			ledDistances = {}
			curCofG = nodeInfo.CofG
			for nodeLed in nodeInfo.leds
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
			nodeInfo.leds = []
			for key,val of ledDistances
				nodeInfo.leds.push [val.padIdx, val.ledIdx]
				console.log val.padIdx, val.ledIdx
			nodeInfo.CofG = @getCofGforLeds(nodeInfo.leds)
			console.log("")

		# Ensure a single led only used in one node
		ledsUsed = {}
		for nodeInfo, nodeIdx in @fullNodeList
			ledsModified = true
			while ledsModified
				ledsModified = false
				for nodeLed in nodeInfo.leds
					if nodeLed[0]*1000 + nodeLed[1] of ledsUsed
						otherLedUse = ledsUsed[nodeLed[0]*1000 + nodeLed[1]]
						if otherLedUse.nodeIdx isnt nodeIdx
							ledInfo = padLedsData[nodeLed[0]][nodeLed[1]]
							ledDist = @dist(ledInfo, @fullNodeList[nodeIdx].CofG)
							otherLedDist = @dist(ledInfo, @fullNodeList[otherLedUse.nodeIdx].CofG)
							if ledDist < otherLedDist
								newList = []
								for led in @fullNodeList[otherLedUse.nodeIdx].leds
									if not (led[0] is nodeLed[0] and led[1] is nodeLed[1])
										newList.push led
								@fullNodeList[otherLedUse.nodeIdx].leds = newList
								ledsUsed[nodeLed[0]*1000 + nodeLed[1]] = { nodeIdx: nodeIdx }
							else
								newList = []
								for led in @fullNodeList[nodeIdx].leds
									if not (led[0] is nodeLed[0] and led[1] is nodeLed[1])
										newList.push led
								@fullNodeList[nodeIdx].leds = newList
							ledsModified = true
							break
					else
						ledsUsed[nodeLed[0]*1000 + nodeLed[1]] = { nodeIdx: nodeIdx }


		for testNode, testNodeIdx in @fullNodeList
			oStr = testNodeIdx + " nodeLeds "
			for testNodeLeds in testNode.leds
				oStr += "[" + testNodeLeds[0] + "," + testNodeLeds[1] + "] "
			console.log oStr

		# Rationalise nodes
		console.log "InnerNodeList " + nodeRationalisedList.length
		console.log "FreeNodeList " + freeRationalisedList.length
		console.log "@fullNodeList " + @fullNodeList.length

		# Build the graph
		@edgeList = []
		for fullNode in @fullNodeList
			fullNode.edgesTo = []
		for padAdjList,padIdx in @padAdjacencies
			fromNode = null
			# Go entirely round the pads that are nearly continuous to find all edges
			padCircuit = padLedsData[padIdx].length
			if @dist(padLedsData[padIdx][0], padLedsData[padIdx][padCircuit-1]) < @maxDistForFirstAndLastLedsOnCircularPad
				padCircuit += 5
			for testLedIdx in [0...padCircuit]
			# for ledInfo,ledIdx in padLedsData[padIdx]
				ledIdx = testLedIdx % padLedsData[padIdx].length
				ledInfo = padLedsData[padIdx][ledIdx]
				wrappedRound = testLedIdx >= padLedsData[padIdx].length
				# Find if this led belogs to any node
				thisNode = null
				for testNode, testNodeIdx in @fullNodeList
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
					if (thisNode.nodeIdx is 63 or thisNode.nodeIdx is 83 or thisNode.nodeIdx is 82)
						console.log "this node " + thisNode.nodeIdx + " fromNode " + (if fromNode? then fromNode.nodeIdx else "null") + " padIdx " + padIdx + " ledIdx " + ledIdx
					if @fullNodeList[fromNode.nodeIdx].nodeDegree > 1 or @fullNodeList[thisNode.nodeIdx].nodeDegree > 1
						console.log "fromNode " + fromNode + " thisNode " + thisNode
						curEdgeIdx = @edgeList.length
						edgeLength = Math.abs(fromNode.ledIdx-thisNode.ledIdx)
						if wrappedRound
							padLedsData[padIdx].length - edgeLength
						if not @fullNodeList[fromNode.nodeIdx].edgesTo.some( (el) -> el.toNodeIdx is thisNode.nodeIdx )

							@fullNodeList[fromNode.nodeIdx].edgesTo.push
							 	toNodeIdx: thisNode.nodeIdx
							 	edgeIdx: curEdgeIdx
							 	edgeLength: edgeLength
							edgeInfo = 
								padIdx: padIdx
								fromNodeIdx: fromNode.nodeIdx
								fromNode: @fullNodeList[fromNode.nodeIdx]
								fromLedIdx: fromNode.ledIdx
								toNodeIdx: thisNode.nodeIdx
								toNode: @fullNodeList[thisNode.nodeIdx]
								toLedIdx: thisNode.ledIdx
							@edgeList.push edgeInfo
						if not @fullNodeList[thisNode.nodeIdx].edgesTo.some( (el) -> el.toNodeIdx is fromNode.nodeIdx )
							@fullNodeList[thisNode.nodeIdx].edgesTo.push
							 	toNodeIdx: fromNode.nodeIdx
							 	edgeIdx: curEdgeIdx
							 	edgeLength: edgeLength
				if thisNode?
					# console.log "At node " + thisNode + " fromNode=" + fromNode
					fromNode = {}
					for key, val of thisNode
						fromNode[key] = val

		# List nodes and edges
		for node, nodeIdx in @fullNodeList
			edgeStr = ""
			for edgeTo in node.edgesTo
				edgeStr += " " + edgeTo.toNodeIdx
			console.log "Node " + nodeIdx + " edgesToNodes " + edgeStr

		# Add edge info to nodes
		for node, nodeIdx in @fullNodeList
			for edgeTo in node.edgesTo
				# work down edges of pads common to both nodes
				edgeSteps = []
				for nodeLed in node.leds
					padIdx = nodeLed[0]
					for toNodeLed in @fullNodeList[edgeTo.toNodeIdx].leds
						if padIdx is toNodeLed[0]
							# find the number of leds in the edge
							numleds = Math.abs(toNodeLed[1] - nodeLed[1])
							ledInc = if toNodeLed[1] > nodeLed[1] then 1 else -1
							ledBase = nodeLed[1]
							if node.nodeDegree >= 2 and @fullNodeList[edgeTo.toNodeIdx].nodeDegree >= 2
								wrapRoundNumLeds = @padLedsData[padIdx].length - numleds
								if numleds > wrapRoundNumLeds
									numleds = wrapRoundNumLeds
									ledInc = -ledInc
							if numleds < edgeTo.edgeLength - 1 and numleds > edgeTo.edgeLength - 10
								numleds = Math.abs(toNodeLed[1] - nodeLed[1])
								ledInc = -ledInc

							if DEBUG_EDGES?
								if nodeIdx == 31
									console.log "edgeLengthDiscrepancy from " + nodeIdx + " to " + edgeTo.toNodeIdx + " expected " + edgeTo.edgeLength + " is " + numleds

							# if numleds < edgeTo.edgeLength - 1 and numleds > edgeTo.edgeLength - 10
							# 	console.log "TESTTESTTEST " + nodeIdx + " to " + edgeTo.toNodeIdx + " expected " + edgeTo.edgeLength + " is " + numleds

							edgeStr2 = ""
							for i in [0...numleds-1]
								if edgeSteps.length <= i
									edgeSteps[i] = []
								tLedIdx = (ledBase+(i+1)*ledInc+@padLedsData[padIdx].length)%@padLedsData[padIdx].length
								edgeSteps[i].push { padIdx: padIdx, ledIdx: tLedIdx }
								edgeStr2 += tLedIdx + ","

							if DEBUG_EDGES?
								if nodeIdx == 31
									console.log "Edge from " + nodeIdx + " to " + edgeTo.toNodeIdx + " alongPad " + padIdx + " numleds= " + numleds + " fromNodeLed " + nodeLed[1] + " toNodeLed " + toNodeLed[1] + " edgeLeds " + edgeStr2

				edgeTo.edgeList = edgeSteps

				if DEBUG_EDGES?
					edgeStr3 = "edgeSteps "
					for step in edgeSteps
						for leds in step
							edgeStr3 += leds.padIdx + "." + leds.ledIdx + " "
						edgeStr3 += ", "
					console.log edgeStr3

		# for edge in @edgeList
		# 	console.log "edge from " + edge.fromNodeIdx + " to node " + edge.toNodeIdx

		# # Edge list
		# edgeList = []
		# for node, nodeIdx in @fullNodeList
		# 	for edgesTo in node.edgesTo
		# 		edgeList.push { from: { nodeIdx: nodeIdx, pt: node.CofG.pt }, to: { nodeIdx: edgesTo, pt: @fullNodeList[edgesTo].CofG.pt }}

		colrs = @genColours(@fullNodeList.length)
		colrIdx = 0
		console.log "NumNodes = " + @fullNodeList.length
		for nodeLeds in @fullNodeList
			nodeLeds.colr = colrs[colrIdx++]
		# @fullNodeList[0].colr = "#000000"
		# for nodeLeds in nodeRationalisedList
		# 	colr = colrs[colrIdx++]
		# 	for nodeLed in nodeLeds.leds
		# 		padLedsData[nodeLed[0]][nodeLed[1]].clr = colr

		nodesSvg = @svg.selectAll("g.nodes")
			.data(@fullNodeList)
			.enter()
			.append("g")
			.attr("class","nodes")
			.append("circle")
		 	.attr("class", "node")
		 	.attr("cx", (d) -> return d.CofG.pt.x )
		 	.attr("cy", (d) -> return d.CofG.pt.y )
		 	.attr("r", 5)
		 	.attr("fill", (d,i) -> return d.colr)

		# for nod, nodIdx in @fullNodeList
		# 	nodStr = "node " + nodIdx + " edges "
		# 	for ed in nod.edgesTo
		# 		nodStr += ed + ", "
		# 	console.log nodStr
		# for edge in @edgeList
		# 	console.log "edge from " + edge.fromNode.nodeIdx + ", to " + edge.toNode.nodeIdx

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

		nodeLabels = @svg
			.selectAll(".nodelabels")
			.data(@fullNodeList)
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

		@animNodeIdx = 34
		@animEdgeIdx = 0
		@animEdgeStep = 0
		@atANode = true
		@steps = 0
		d3.timer(@stepFn)

		@svg.on "mousemove", @mousemove

	mousemove: =>
		x = event.x
		y = event.y
		for node, nodeIdx in @fullNodeList
			if @dist(node.CofG, {pt: { x: x, y: y}}) < 10
				sss = "http://fractal:5078/rawcmd/01010b0200010001" + Math.random().toString(16).substr(-6) + Math.random().toString(16).substr(-6)
				$.get sss, ( data ) ->
					console.log "Done get"

				for pad in @padLedsData
					for led in pad
						led.clr = "#dcdcdc"
				for edgesTo in node.edgesTo
					for edgeStep in edgesTo.edgeList
						for led in edgeStep
							@padLedsData[led.padIdx][led.ledIdx].clr = "#000000"
	 
			@ledsSel.attr("fill", (d) -> return d.clr)


				# # console.log "MouseOver " + nodeIdx
				# tmpEdgeList = []
				# edgesStr = ""
				# for edgeTo in node.edgesTo
				# 	tmpEdgeList.push
				# 		fromNode: @fullNodeList[nodeIdx]
				# 		toNode: @fullNodeList[edgeTo.toNodeIdx]
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

	stepFn: =>

		@steps++
		if @steps > 10
			@steps = 0
			return false

		for pad in @padLedsData
			for led in pad
				led.clr = "#dcdcdc"

		# If at a node then select an edge randomly
		if @atANode
			@animEdgeIdx = Math.floor(Math.random() * @fullNodeList[@animNodeIdx].edgesTo.length)
			@atANode = false
			@animEdgeStep = 0
			for nodeLed in @fullNodeList[@animNodeIdx].leds
				@padLedsData[nodeLed[0]][nodeLed[1]].clr = "#000000"
			# check for zero length edge
			if @fullNodeList[@animNodeIdx].edgesTo[@animEdgeIdx].edgeList.length == 0
				@animNodeIdx = @fullNodeList[@animNodeIdx].edgesTo[@animEdgeIdx].toNodeIdx
				@atANode = true
		else
			edgeSteps = @fullNodeList[@animNodeIdx].edgesTo[@animEdgeIdx].edgeList
			if @animEdgeStep < edgeSteps.length
				for led in edgeSteps[@animEdgeStep]
					@padLedsData[led.padIdx][led.ledIdx].clr = "#000000"
			@animEdgeStep++
			if @animEdgeStep >= edgeSteps.length
				@animNodeIdx = @fullNodeList[@animNodeIdx].edgesTo[@animEdgeIdx].toNodeIdx
				@atANode = true

		@ledsSel.attr("fill", (d) -> return d.clr)





		return false
