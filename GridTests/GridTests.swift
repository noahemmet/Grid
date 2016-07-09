//
//  GridTestCase.swift
//  Grid
//
//  Created by Noah Emmet on 3/12/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import XCTest
import Grid

private struct Position: Hashable {
	let row: Int
	let column: Int
	var hashValue: Int {
		return row.hashValue * column.hashValue
	}
}

private func ==(lhs: Position, rhs: Position) -> Bool {
	return lhs.column == rhs.column && lhs.row == rhs.row
}

class GridTestCase: XCTestCase {
	
	private var grid: Grid<Position> = Grid(rows: 100, columns: 100) { (row, column) in
		return Position(row: row, column: column)
	}
	
	override func setUp() {
		super.setUp()
		
//		grid = Grid(rows: 100, columns: 100) { (row, column) in
//			return Position(row: row, column: column)
//		}
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testRangeSubscript() {
		let rangedGrid = grid[rows: 0..<2, columns: 0..<2]
		XCTAssertEqual(rangedGrid.rows, 2)
		XCTAssertEqual(rangedGrid.columns, 2)
	}
	
	func testRangeSubscriptOffset() {
		let rangedGrid = grid[rows: 1..<3, columns: 0..<3]
		XCTAssertEqual(rangedGrid.rows, 2)
		XCTAssertEqual(rangedGrid.columns, 3)
		
		var element = rangedGrid[0, 1]
		XCTAssertEqual(element.row, 1)
		XCTAssertEqual(element.column, 1)
		
		element = rangedGrid[1, 1]
		XCTAssertEqual(element.row, 2)
		XCTAssertEqual(element.column, 1)
	}
	
	func testRangeSubscriptTrimming() {
		let rangedGrid = grid[rows: 1..<200, columns: 0..<2]
		XCTAssertEqual(rangedGrid.rows, 99)
		XCTAssertEqual(rangedGrid.columns, 2)
	}
	
	func testRangeSubscriptWithin() {
		self.measure {
			var rangedGrid = self.grid[nearPoint: GridPoint(5, 5), within: 1]
			XCTAssertEqual(rangedGrid.rows, 3)
			XCTAssertEqual(rangedGrid.columns, 3)
			
			rangedGrid = self.grid[nearPoint: GridPoint(5, 5), within: 2]
			XCTAssertEqual(rangedGrid.rows, 5)
			XCTAssertEqual(rangedGrid.columns, 5)
			
			
			// with trimming
			rangedGrid = self.grid[nearPoint: GridPoint(0, 0), within: 1]
			XCTAssertEqual(rangedGrid.rows, 2)
			XCTAssertEqual(rangedGrid.columns, 2)
			
			
			rangedGrid = self.grid[nearPoint: GridPoint(0, 0), within: 2]
			XCTAssertEqual(rangedGrid.rows, 3)
			XCTAssertEqual(rangedGrid.columns, 3)
			
			rangedGrid = self.grid[nearPoint: GridPoint(100, 100), within: 1]
			XCTAssertEqual(rangedGrid.rows, 1)
			XCTAssertEqual(rangedGrid.columns, 1)
		}
	}
	
	func testRangeSubscriptOutOfBounds() {
		let rangedGrid = grid[nearPoint: GridPoint(500, 500), within: 1]
		XCTAssertEqual(rangedGrid.rows, 0)
		XCTAssertEqual(rangedGrid.columns, 0)
	}
	
	func testGridSpiral() {
		let center = GridPoint(row: 50, column: 50)
		let spiralGenerator = grid.spiral(from: center)
		let nextPoint = spiralGenerator.next()!
		XCTAssertEqual(nextPoint, grid[50, 51])
	}
}
