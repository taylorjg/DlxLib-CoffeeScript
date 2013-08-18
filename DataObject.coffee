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

	appendToColumn: (dataObject) ->
		@up.down = dataObject
		dataObject.down = this
		dataObject.up = @up
		@up = dataObject

	unlinkFromColumn: ->
		@down.up = @up
		@up.down = @down

	relinkIntoColumn: ->
		@down.up = this
		@up.down = this
		
	loopUp: (fn) ->
		@_loop(
			(dataObject) -> dataObject.up
			fn
		)

	loopDown: (fn) ->
		@_loop(
			(dataObject) -> dataObject.down
			fn
		)
		
	loopLeft: (fn) ->
		@_loop(
			(dataObject) -> dataObject.left
			fn
		)
		
	loopRight: (fn) ->
		@_loop(
			(dataObject) -> dataObject.right
			fn
		)
		
	_loop: (getNext, fn) ->
		next = getNext this
		loop
			break if next is this
			fn next
			next = getNext next

if module?
	module.exports = DataObject
