if module?
	DataObject		= require "./DataObject"
	ColumnObject	= require "./ColumnObject"
	Solution		= require "./Solution"

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
			
		return

	_search = ->
	
		if _matrixIsEmpty()
			_solutions.push new Solution _currentSolution if _currentSolution.length > 0
			return

		c = _getListHeaderOfColumnWithLeastRows()
		_coverColumn c
		
		r = c.down
		loop
			break if r is c
			_currentSolution.push r.rowIndex
			j = r.right
			loop
				break if j is r
				_coverColumn j.listHeader
				j = j.right
				
			_search()
			
			j = r.left
			loop
				break if j is r
				_uncoverColumn j.listHeader
				j = j.left
				
			_currentSolution.pop()
			
			r = r.down
		
		_uncoverColumn c
			
		return

	_matrixIsEmpty = ->
		_root.nextListHeader is _root

	_getListHeaderOfColumnWithLeastRows = ->
		result = null
		smallestNumberOfRows = Number.MAX_VALUE
		listHeader = _root.nextListHeader
		loop
			break if listHeader is _root
			if listHeader.numberOfRows < smallestNumberOfRows
				result = listHeader
				smallestNumberOfRows = listHeader.numberOfRows
			listHeader = listHeader.nextListHeader
		result

	_coverColumn = (c) ->
		c.unlinkListHeader()
		i = c.down
		loop
			break if i is c
			j = i.right
			loop
				break if j is i
				j.listHeader.unlinkDataObject j
				j = j.right
			i = i.down
		return

	_uncoverColumn = (c) ->
		i = c.up
		loop
			break if i is c
			j = i.left
			loop
				break if j is i
				j.listHeader.relinkDataObject j
				j = j.left
			i = i.up
		c.relinkListHeader()
		return

if module?
	module.exports = Dlx
