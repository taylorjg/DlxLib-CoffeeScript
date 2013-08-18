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

	unlinkListHeader: ->
		@nextListHeader.previousListHeader = @previousListHeader
		@previousListHeader.nextListHeader = @nextListHeader

	relinkListHeader: ->
		@nextListHeader.previousListHeader = this
		@previousListHeader.nextListHeader = this

	addDataObject: (dataObject) ->
		@appendToColumn dataObject
		@numberOfRows++
		
	unlinkDataObject: (dataObject) ->
		dataObject.unlinkFromColumn()
		@numberOfRows--
		
	relinkDataObject: (dataObject) ->
		dataObject.relinkIntoColumn()
		@numberOfRows++
		
	loopNext: (fn) ->
		next = @nextListHeader
		loop
			break if next is this
			fn next
			next = next.nextListHeader

if module?
	module.exports = ColumnObject
