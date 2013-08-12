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
