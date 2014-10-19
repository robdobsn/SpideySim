class @SpideyAnimation

	xCentre: 250
	yCentre: 375
	
	getColour: (x, y, padNum, padLedIdx, genIdx) ->
		distFromCentre = Math.sqrt((x-@xCentre)*(x-@xCentre) + (y-@yCentre)*(y-@yCentre))
		colorIdx = (distFromCentre + (100000-genIdx) * 15)
		colr = "#"
		colAr = []
		for i in [0..2]
			colAr.push (Math.abs((Math.floor(colorIdx) + (i * 152)) % 256 - 128) + 30)
			colr += ("00"+colAr[i].toString(16)).substr(-2)
		colr = "rgba("+colAr[0].toString()+","+colAr[1].toString()+","+colAr[2].toString()+",1.0)"
		# if colorIdx > 100 and colorIdx < 120
		# 	console.log(x,y,genIdx,colorIdx,colr)
		return colr