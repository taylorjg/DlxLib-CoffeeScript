Dlx = require "./Dlx"
require "colors"

highlightIf = (x, condition) ->
	s = x.toString()
	if condition then s.yellow.bold else s
	
arrayContains = (arr, x) ->
	arr.indexOf(x) >= 0

printSolution = (matrix, solution, index) ->
	console.log "Solution number #{index} ([#{solution.rowIndexes}]):"
	numRows = matrix.length
	numCols = if numRows > 0 then matrix[0].length else 0
	for rowIndex in [0...numRows]
		do (rowIndex) ->
			highlightRowIndex = arrayContains solution.rowIndexes, rowIndex
			line = "matrix["
			line += highlightIf rowIndex, highlightRowIndex
			line += "]: {"
			
			for colIndex in [0...numCols]
				do (colIndex) ->
					value = matrix[rowIndex][colIndex]
					highlightValue = highlightRowIndex and value isnt 0
					line += highlightIf value, highlightValue
					line += ", " if colIndex + 1 < numCols
			
			line += "}"
			console.log line
	console.log ""
	return
	
matrix = [
	[1, 0, 0, 0]
	[0, 1, 1, 0]
	[1, 0, 0, 1]
	[0, 0, 1, 1]
	[0, 1, 0, 0]
	[0, 0, 1, 0]
]

index = 0
for solution in new Dlx().solve matrix
	printSolution matrix, solution, ++index
