//
//  Grid.swift
//  Grid
//
//  Created by Noah Emmet on 3/11/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

/**
*	A point on a `Grid`.
*/
public struct GridPoint {
	public init(row: Int, column: Int) {
		self.row = row
		self.column = column
	}
	
	public init(_ row: Int, _ column: Int) {
		self.row = row
		self.column = column
	}
	public var row: Int
	public var column: Int
}

extension GridPoint: Hashable {
	public var hashValue: Int {
		return (row * column).hashValue
	}
}

extension GridPoint: CustomDebugStringConvertible {
	public var debugDescription: String {
		return String(row, column)
	}
}

public func ==(lhs: GridPoint, rhs: GridPoint) -> Bool {
	return lhs.column == rhs.column && lhs.row == rhs.row
}

/**
*	A two-dimensional grid of `Element`s. 
*   The grid is backed by a single array of `Element`s, but provides convenience functions to access it.
*/
public struct Grid<Element: Hashable> {
	/// Number of rows in the grid.
	public let rows: Int
	/// Number of columns in the grid.
	public let columns: Int
	/// The backing `Element` array.
	public var elements: [Element]
	
	/**
	Initializes an empty `Grid`.
	*/
	public init() {
		self.rows = 0
		self.columns = 0
		self.elements = []
	}
	
	/**
	Initializes a `Grid` with identical elements.
	
	- parameter rows:					Number of rows in the grid.
	- parameter columns:				Number of columns in the grid.
	- parameter repeatedValue:	The value that will be copied to each point in the grid.
	*/
	public init(rows: Int, columns: Int, repeatedValue: Element) {
		self.rows = rows
		self.columns = columns
		self.elements = Array<Element>(count: rows * columns, repeatedValue: repeatedValue)
	}
	
	/**
	- parameter rows:					Number of rows in the grid.
	- parameter columns:				Number of columns in the grid.
	- parameter elementInit:	 A closure into which you can initialize an `Element`. The closure provides `row` and `column` parameters for convenience.
	*/
	public init(rows: Int, columns: Int, elementInit: (row: Int, column: Int) -> Element) {
		self.rows = rows
		self.columns = columns
		elements = []
		for row in 0 ..< rows {
			for column in 0 ..< columns {
				elements.append(elementInit(row: row, column: column))
			}
		}
	}
	
	/**
	-returns: An element at a specific row and column. 
	-note: Will assert if out of bounds.
	*/
	public subscript(row: Int, column: Int) -> Element {
		get {
			assert(pointIsWithinBounds(row: row, column: column))
			return elements[(row * columns) + column]
		}
		
		set {
			assert(pointIsWithinBounds(row: row, column: column))
			elements[(row * columns) + column] = newValue
		}
	}
	
	/**
	-returns: An element at a specific row and column, or nil if that point is out of bounds. 
	*/
	public func elementAt(row row: Int, column: Int) -> Element? {
		guard pointIsWithinBounds(row: row, column: column) else {
			return nil
		}
		return self[row, column]
	}
	
	/// Returns the element at a `GridPoint`.
	public subscript(index: GridPoint) -> Element {
		return self[index.row, index.column]
	}
	
	/// Returns the element at an index.
	public subscript(index: Int) -> Element {
		return self.elements[index]
	}
	
	
	/**
	Returns an array of elements in a column, starting at `row`.
	
	- parameter row:		The starting row.
	- parameter range:	The range of columns. This will determine the returned array's count. 
	
	- returns: An array of elements in a column.
	*/
	public func elementsAt(row row: Int, range: Range<Int>) -> [Element] {
		var columns: [Element] = []
		for columnIndex in range {
			if let element = self.elementAt(row: row, column: columnIndex) {
				columns.append(element)
			}
		}
		return columns
	}
	
	/**
	Returns an array of elements in a row, starting at `column`.
	
	- parameter column:		The starting column.
	- parameter range:	The range of rows. This will determine the returned array's count. 
	
	- returns: An array of elements in a row.
	*/
	public func elementsAt(column column: Int, range: Range<Int>) -> [Element] {
		var rows: [Element] = []
		for rowIndex in range {
			if let element = self.elementAt(row: rowIndex, column: column) {
				rows.append(element)
			}
		}
		return rows
	}
	
	/**
	Filter by ranges of columns and rows. 
	
	- parameter rowsInRange:		Range of rows to filter by. Range will automatically trim to stay within bounds.
	- parameter columnsInRange:	Range of columns to filter by. Range will automatically trim to stay within bounds.
	
	- returns: A trimmed `Grid`.
	*/
	public subscript(rows rowsInRange: Range<Int>, columns columnsInRange: Range<Int>) -> Grid<Element> {
		let trimmedRowRange = max(0, rowsInRange.startIndex) ..< min(rows, rowsInRange.endIndex)
		let trimmedColumnRange = max(0, columnsInRange.startIndex) ..< min(columns, columnsInRange.endIndex)
		
		return Grid(rows: trimmedRowRange.count, columns: trimmedColumnRange.count) { (row, column) in
			let offsetRow = row + trimmedRowRange.startIndex
			let offsetColumn = column + trimmedColumnRange.startIndex
			return self[offsetRow, offsetColumn]
		}
	}
	
	/**
	Filter by indexes within a point.
	
	- parameter point:	The center point around which to filter.
	- parameter within:	The number of vertical and horizontal elements around the point.
	
	- returns: A trimmed `Grid`.
	*/
	public subscript(nearPoint point: GridPoint, within within: Int) -> Grid<Element> {
		let rowRange = (point.row - within) ... (point.row + within)
		let columnRange = (point.column - within) ... (point.column + within)
		guard rowRange.startIndex <= rows && columnRange.startIndex <= columns else {
			// out of bounds; return empty Grid
			return Grid<Element>()
		}
		return self[rows: rowRange, columns: columnRange]
	}
	
	/**
	- parameter row:	 The index of the row.
	
	- returns: A column of `Element`s.
	*/
	public func columnForRow(row: Int) -> [Element] {
//		get {
			assert(row < rows)
			let startIndex = row * columns
			let endIndex = row * columns + columns
			return Array(elements[startIndex..<endIndex])
//		}
//		
//		set {
//			assert(row < rows)
//			assert(newValue.count == columns)
//			let startIndex = row * columns
//			let endIndex = row * columns + columns
//			elements.replaceRange(startIndex..<endIndex, with: newValue)
//		}
	}
	
	/**
	Returns a nearby `GridPoint`. Returns `nil` if point is outside bounds. 
	
	- parameter point:				The starting point.
	- parameter cardinality:	 The direction from the starting point to traverse.
	- parameter distance:		The distance from the starting point.
	
	- returns: A `GridPoint`, or `nil` if point is outside bounds.
	*/
	public subscript(point point: GridPoint, cardinality cardinality: PrincipalCardinalDirection, distance distance: Int) -> GridPoint? {
		var newPoint = point
		switch cardinality {
		case .North:
			newPoint.row -= distance
		case .NorthEast:
			newPoint.row -= distance
			newPoint.column += distance
		case .East:
			newPoint.column += distance
		case .SouthEast:
			newPoint.row += distance
			newPoint.column += distance
		case .South:
			newPoint.row += distance
		case .SouthWest:
			newPoint.row += distance
			newPoint.column -= distance
		case .West:
			newPoint.column -= distance
		case .NorthWest:
			newPoint.row -= distance
			newPoint.column += distance
		}
		guard pointIsWithinBounds(row: newPoint.row, column: newPoint.column) else {
			return nil
		}
		return newPoint
	}
	
	/**
	Gets the index of an `Element`, or `nil` if it does not exist in the grid.
	
	- parameter element:	 The `Element` to search for. 
	*/
	public subscript(element: Element) -> Int? {
		return elements.indexOf(element)
	}
	
	/**
	Returns a `GridPoint` from an index.
	
	- parameter index:	The index of the point.
	*/
	public func gridPointOfIndex(index: Int) -> GridPoint {
		let row = index / rows
		let column = index % columns
		return GridPoint(row: row, column: column)
	}
	
	/**
	- returns: Returns `true` if a point is within bounds.
	*/
	private func pointIsWithinBounds(row row: Int, column: Int) -> Bool {
		return row >= 0 && row < rows && column >= 0 && column < columns
	}
	
	/**
	- returns: Returns `true` if a point is within bounds.
	*/
	private func pointIsWithinBounds(point: GridPoint) -> Bool {
		return pointIsWithinBounds(row: point.row, column: point.column)
	}
	
	/**
	- returns: A random `GridPoint`.
	*/
	public var randomIndex: GridPoint {
		let x = Int(rand()) % rows
		let y = rand() % Int32(columns)
		let index = GridPoint(row: x, column: Int(y))
		return index
	}
	
	/// The center `GridPoint` in the grid.
	public var center: GridPoint {
		let centerElement = self[Int(rows/2), Int(columns/2)]
		let index = self[centerElement]!
		return gridPointOfIndex(index)
	}
	
	/// Returns a `Generator` of every point on the grid.
	public func points() -> AnyGenerator<GridPoint> {
		var elementIndex = 0
		return AnyGenerator<GridPoint> {
			guard elementIndex < self.elements.count else {
				return nil
			}
			defer {
				elementIndex += 1
			}
			return self.gridPointOfIndex(elementIndex)
		}
	}
	
	/**
	Returns an array of rings of `Element`s.
	
	- parameter centerPoint:	 The point around which the rings will be based.
	- parameter range:				The range extending from the `centerPoint`.
	- parameter clockwise:		Clockwise or counter-clockwise.
	*/
	public func ringsAround(point centerPoint: GridPoint, range: Range<Int> = 1..<2, clockwise: Bool = true) -> [[Element]] {
		var rings: [[Element]] = []
		for ringIndex in range {
			
			// Corners
			let topLeft = GridPoint(row: centerPoint.row - ringIndex, column: centerPoint.column + ringIndex)
			let topRight = GridPoint(row: centerPoint.row + ringIndex, column: centerPoint.column + ringIndex)
			let bottomRight = GridPoint(row: centerPoint.row + ringIndex, column: centerPoint.column - ringIndex)
			let bottomLeft = GridPoint(row: centerPoint.row - ringIndex, column: centerPoint.column - ringIndex)
			
			// Edges
			let offset = 1 // ? I think this allows space between the edges.
			let topRow: [Element] = elementsAt(column: topLeft.column, range: topLeft.row+offset..<bottomRight.row+offset)
			let rightColumn: [Element] = elementsAt(row: bottomRight.row, range: bottomRight.column..<topRight.column)
			let bottomRow: [Element] = elementsAt(column: bottomLeft.column, range: bottomLeft.row..<bottomRight.row)
			let leftColumn: [Element] = elementsAt(row: bottomLeft.row, range: bottomLeft.column+offset..<topLeft.column+offset)
			
			let ring: [Element]
			// reversed arrays are separated for better compile times.
			if clockwise {
				let rightColumnReversed = rightColumn.reverse()
				let bottomRowReversed = bottomRow.reverse()
				ring = topRow + rightColumnReversed + bottomRowReversed + leftColumn
			} else {
				let topRowReversed = topRow.reverse()
				let rightColumnReversed = rightColumn.reverse()
				ring = topRowReversed + leftColumn + bottomRow + rightColumnReversed
			}
			rings.append(ring)
		}
		return rings
	}
	
	/**
	Returns a `Generator` of finite `Element`s, spiraling out from a `centerPoint`.
	
	- parameter centerPoint:	 The point around which the spiral will circle.
	- parameter cardinality:	 The starting point of each concurrent ring.
	- parameter clockwise:		Clockwise or counter-clockwise.
	
	- returns: A `Generator`.
	*/
	public func spiral(from centerPoint: GridPoint, start cardinality: PrincipalCardinalDirection = .NorthWest, clockwise: Bool = true) -> AnyGenerator<Element> {
		
		var ringIndex = 1
		var elementIndex = 0
		var nextRing = ringsAround(point: centerPoint, clockwise: clockwise).first!
//		let _ = PrincipalCardinalDirection.cases.count % cardinality.rawValue
		return AnyGenerator<Element> { 
			if elementIndex < nextRing.count {
				// Traverse each ring
				let element = nextRing[elementIndex]
				elementIndex += 1
				return element
			} else {
				// end of ring
				ringIndex += 1
				elementIndex = 0
				let nextRange = ringIndex..<ringIndex+1
				if let possibleNextRing = self.ringsAround(point: centerPoint, range: nextRange, clockwise: clockwise).first where !possibleNextRing.isEmpty {
					nextRing = possibleNextRing
					let element = nextRing[0]
					return element
				} else {
					// All elements are out of bounds.
					return nil
				}
			}
		}
	}
}

// MARK: - SequenceType / SequenceType

extension Grid: SequenceType {
	public func generate() -> AnyGenerator<Element> {
		var isFirstElement = true
		var nextPoint: GridPoint = GridPoint(row: 0, column: 0)
		return AnyGenerator<Element> {
			if isFirstElement {
				isFirstElement = false
				return self[nextPoint.column, nextPoint.row]
			}
			
			if nextPoint.row == self.rows - 1 && nextPoint.column == self.columns - 1 {
				// last row in last column
				return nil
			} else if nextPoint.row == self.rows - 1 {
				// last row in a column
				nextPoint.row = 0
				nextPoint.column += 1
			} else {
				// a row in a column
				nextPoint.row += 1
			}
			return self[nextPoint.row, nextPoint.column] // this seems backwards
		}
	}
}

