SolutionModule = require "./Solution"
DlxModule = require "./Dlx"

matrix = [
	[1, 0, 0, 0]
	[0, 1, 1, 0]
	[1, 0, 0, 1]
	[0, 0, 1, 1]
	[0, 1, 0, 0]
	[0, 0, 1, 0]
]
dlx = new DlxModule.Dlx
solutions = dlx.solve matrix
for solution in solutions
	do (solution) ->
		console.log solution
