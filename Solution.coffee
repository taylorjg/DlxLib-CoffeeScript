class Solution
	constructor: (rowIndexes) ->
		@rowIndexes = (rowIndex for rowIndex in rowIndexes).sort (a, b) -> a - b

(exports ? this).Solution = Solution
