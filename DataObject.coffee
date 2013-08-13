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

(exports ? this).DataObject = DataObject
