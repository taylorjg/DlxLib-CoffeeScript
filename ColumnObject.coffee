if module?
	DataObject = require "./DataObject"

class ColumnObject extends DataObject

	constructor: ->
		super null, -1
		@previousListHeader = this
		@nextListHeader = this
		@numberOfRows = 0

	appendListHeader: (listHeader) ->
		@previousListHeader.nextListHeader = listHeader
		listHeader.nextListHeader = this
		listHeader.previousListHeader = @previousListHeader
		@previousListHeader = listHeader
		return

	unlinkListHeader: ->
		@nextListHeader.previousListHeader = @previousListHeader
		@previousListHeader.nextListHeader = @nextListHeader
		return

	relinkListHeader: ->
		@nextListHeader.previousListHeader = this
		@previousListHeader.nextListHeader = this
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

if module?
	module.exports = ColumnObject
