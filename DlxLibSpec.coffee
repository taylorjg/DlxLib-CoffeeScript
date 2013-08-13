describe "Tests for DlxLib-CoffeeScript", ->

	it "null matrix throws an error", ->
		dlx = new Dlx
		expect(-> dlx.solve null).toThrow new Error "invalid matrix - null"
	
	it "matrix with rows of different lengths throws an error", ->
		matrix = [
			[1, 0, 0]
			[0, 1, 0]
			[0, 0]
		]
		dlx = new Dlx
		expect(-> dlx.solve matrix).toThrow new Error "invalid matrix - rows have differing lengths"

	it "empty matrix returns no solutions", ->
		matrix = []
		dlx = new Dlx
		solutions = dlx.solve matrix
		expect(solutions.length).toBe 0

	it "matrix with a single row of all ones returns one solution", ->
		matrix = [
			[1, 1, 1]
		]
		dlx = new Dlx
		solutions = dlx.solve matrix
		expect(solutions.length).toBe 1
		firstSolution = solutions[0]
		expect(firstSolution.rowIndexes).toEqual [0]

	it "matrix with a single row of all zeros returns no solutions", ->
		matrix = [
			[0, 0, 0]
		]
		dlx = new Dlx
		solutions = dlx.solve matrix
		expect(solutions.length).toBe 0

	it "3x3 identity matrix returns one solution", ->
		matrix = [
			[1, 0, 0]
			[0, 1, 0]
			[0, 0, 1]
		]
		dlx = new Dlx
		solutions = dlx.solve matrix
		expect(solutions.length).toBe 1
		firstSolution = solutions[0]
		expect(firstSolution.rowIndexes).toEqual [0, 1, 2]

	it "matrix from the original DLX paper returns the correct single solution", ->
		matrix = [
			[0, 0, 1, 0, 1, 1, 0]
			[1, 0, 0, 1, 0, 0, 1]
			[0, 1, 1, 0, 0, 1, 0]
			[1, 0, 0, 1, 0, 0, 0]
			[0, 1, 0, 0, 0, 0, 1]
			[0, 0, 0, 1, 1, 0, 1]
		]
		dlx = new Dlx
		solutions = dlx.solve matrix
		expect(solutions.length).toBe 1
		firstSolution = solutions[0]
		expect(firstSolution.rowIndexes).toEqual [0, 3, 4]

	it "matrix with three solutions returns the correct three solutions", ->
		matrix = [
			[1, 0, 0, 0]
			[0, 1, 1, 0]
			[1, 0, 0, 1]
			[0, 0, 1, 1]
			[0, 1, 0, 0]
			[0, 0, 1, 0]
		]
		dlx = new Dlx
		solutions = dlx.solve matrix
		expect(solutions.length).toBe 3
		firstSolution = solutions[0]
		secondSolution = solutions[1]
		thirdSolution = solutions[2]
		expect(firstSolution.rowIndexes).toEqual [0, 3, 4]
		expect(secondSolution.rowIndexes).toEqual [1, 2]
		expect(thirdSolution.rowIndexes).toEqual [2, 4, 5]
