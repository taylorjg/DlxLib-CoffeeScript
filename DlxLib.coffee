# TODO
# - checks re the validity of the matrix
# - split into separate files - DataObject.coffee, ColumnObject.coffee, Dlx.coffee, Solution.coffee
# - the loops over the doubly linked lists are not nice - how can we use comprehensions instead ?
# - presumably, as written, two instances are not independent because of _root, _solutions and _currentSolution ?

class DataObject

	constructor: (listHeader, rowIndex) ->
		@left = this
		@right = this
		@up = this
		@down = this
		@listHeader = listHeader
		@rowIndex = rowIndex
		listHeader.addDataObject this if listHeader?

	appendToRow: (dataObject) ->
		@left.right = dataObject
		dataObject.right = this
		dataObject.left = @left
		@left = dataObject
		return

	appendToColumn: (dataObject) ->
		@up.down = dataObject
		dataObject.down = this
		dataObject.up = @up
		@up = dataObject
		return

	unlinkFromColumn: ->
		@down.up = @up
		@up.down = @down
		return

	relinkIntoColumn: ->
		@down.up = this
		@up.down = this
		return

class ColumnObject extends DataObject

	constructor: ->
		super null, -1
		@previousColumnObject = this
		@nextColumnObject = this
		@numberOfRows = 0

	appendColumnHeader: (columnObject) ->
		@previousColumnObject.nextColumnObject = columnObject
		columnObject.nextColumnObject = this
		columnObject.previousColumnObject = @previousColumnObject
		@previousColumnObject = columnObject
		return

	unlinkColumnHeader: ->
		@nextColumnObject.previousColumnObject = @previousColumnObject
		@previousColumnObject.nextColumnObject = @nextColumnObject
		return

	relinkColumnHeader: ->
		@nextColumnObject.previousColumnObject = this
		@previousColumnObject.nextColumnObject = this
		return

	addDataObject: (dataObject) ->
		@appendToColumn dataObject
		@numberOfRows++
		return
		
	unlinkDataObject: (dataObject) ->
		dataObject.unlinkFromColumn()
		@numberOfRows--
		return
		
	relinkDataObject: (dataObject) ->
		dataObject.relinkIntoColumn()
		@numberOfRows++
		return

class Solution

	constructor: (rowIndexes) ->
		@rowIndexes = (rowIndex for rowIndex in rowIndexes).sort (a, b) -> a - b

class Dlx

	_root = null
	_solutions = []
	_currentSolution = []

	_buildInternalStructure = (matrix) ->
	
		# TODO: add checks to ensure that matrix is valid...
		
		_root = new ColumnObject
		_solutions = []
		_currentSolution = []
		
		numRows = matrix.length
		numCols = if numRows > 0 then matrix[0].length else 0
		colIndexToListHeader = {}
		
		for colIndex in [0...numCols]
			do (colIndex) ->
				listHeader = new ColumnObject
				_root.appendColumnHeader listHeader
				colIndexToListHeader[colIndex] = listHeader
				return

		for rowIndex in [0...numRows]
			do (rowIndex) ->
				firstDataObjectInThisRow = null
				for colIndex in [0...numCols]
					do (colIndex) ->
						return if matrix[rowIndex][colIndex] is 0
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
		_root.nextColumnObject is _root

	_getListHeaderOfColumnWithLeastRows = ->
		listHeader = null
		smallestNumberOfRows = Number.MAX_VALUE
		columnHeader = _root.nextColumnObject
		loop
			break if columnHeader is _root
			if columnHeader.numberOfRows < smallestNumberOfRows
				listHeader = columnHeader
				smallestNumberOfRows = columnHeader.numberOfRows
			columnHeader = columnHeader.nextColumnObject
		listHeader

	_coverColumn = (c) ->
		c.unlinkColumnHeader()
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
		c.relinkColumnHeader()
		return
		
	solve: (matrix) ->
		_buildInternalStructure matrix
		_search()
		_solutions
