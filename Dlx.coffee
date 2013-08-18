if module?
	DataObject = require "./DataObject"
	ColumnObject = require "./ColumnObject"
	Solution = require "./Solution"

class Dlx

	solve: (matrix) ->
		_buildInternalStructure matrix
		_search()
		_solutions
		
	_root = null
	_solutions = []
	_currentSolution = []

	_buildInternalStructure = (matrix) ->
	
		if matrix is null
			throw new Error "invalid matrix - null"
	
		_root = new ColumnObject
		_solutions = []
		_currentSolution = []
		
		numRows = matrix.length
		numCols = if numRows > 0 then matrix[0].length else 0
		
		for rowIndex in [0...numRows]
			do (rowIndex) ->
				if matrix[rowIndex].length isnt numCols
					throw new Error "invalid matrix - rows have differing lengths"

		colIndexToListHeader = {}
		
		for colIndex in [0...numCols]
			do (colIndex) ->
				listHeader = new ColumnObject
				_root.appendListHeader listHeader
				colIndexToListHeader[colIndex] = listHeader
				return

		for rowIndex in [0...numRows]
			do (rowIndex) ->
				firstDataObjectInThisRow = null
				for colIndex in [0...numCols]
					do (colIndex) ->
						return if !matrix[rowIndex][colIndex]
						listHeader = colIndexToListHeader[colIndex]
						dataObject = new DataObject listHeader, rowIndex
						if firstDataObjectInThisRow?
							firstDataObjectInThisRow.appendToRow dataObject
						else
							firstDataObjectInThisRow = dataObject
						return
				return

	_search = ->
	
		if _matrixIsEmpty()
			_solutions.push new Solution _currentSolution if _currentSolution.length > 0
			return

		c = _getListHeaderOfColumnWithLeastRows()
		
		_coverColumn c
		
		c.loopDown (r) ->
			_currentSolution.push r.rowIndex
			r.loopRight (j) -> _coverColumn j.listHeader
			_search()
			r.loopLeft (j) -> _uncoverColumn j.listHeader
			_currentSolution.pop()
			
		_uncoverColumn c

	_matrixIsEmpty = ->
		_root.nextListHeader is _root

	_getListHeaderOfColumnWithLeastRows = ->
		result = null
		smallestNumberOfRows = Number.MAX_VALUE
		_root.loopNext (listHeader) ->
			if listHeader.numberOfRows < smallestNumberOfRows
				result = listHeader
				smallestNumberOfRows = listHeader.numberOfRows
		result

	_coverColumn = (c) ->
		c.unlinkListHeader()
		c.loopDown (i) -> i.loopRight (j) -> j.listHeader.unlinkDataObject j

	_uncoverColumn = (c) ->
		c.loopUp (i) -> i.loopLeft (j) -> j.listHeader.relinkDataObject j
		c.relinkListHeader()

if module?
	module.exports = Dlx
