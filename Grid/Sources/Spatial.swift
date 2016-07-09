//
//  Units.swift
//  Grid
//
//  Created by Noah Emmet on 2/29/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public protocol CasesProtocol {
	static var cases: [Self] { get }
}

public typealias Degree = CGFloat
public typealias Radian = CGFloat

extension Degree {
	var radians: Radian {
		return self * CGFloat(M_PI) / 180
	}
}

public enum RelativeDirection {
	case forward
	case backward
	case left
	case right
	
	public var degrees: Degree {
		let degrees: Degree
		switch self {
		case .forward:  degrees =   0
		case .backward: degrees = 180
		case .right:		degrees =  90
		case .left:		degrees = 270
		}
		return degrees
	}
}

public enum CardinalDirection: CasesProtocol {
	case north
	case east
	case south
	case west
	
	public var degrees: Degree {
		let degrees: Degree
		switch self {
		case .north: degrees =   0
		case .east:  degrees =  90
		case .south: degrees = 180
		case .west:  degrees = 270
		}
		return degrees
	}
	
	public static var cases: [CardinalDirection] {
		return [.north, .east, .south, .west]
	}
	
	public func rangeAroundPoint() {
		
	}
	
	public var opposite: CardinalDirection {
		switch self {
		case .north: 
			return .south
		case .east:  
			return .west
		case .south:
			return .north
		case .west:  
			return .east
		}
	}
}

public enum PrincipalCardinalDirection: Int, CasesProtocol {
	case north
	case northEast
	case east
	case southEast
	case south
	case southWest
	case west
	case northWest
	
	public var degrees: Degree {
		let degrees: Degree
		switch self {
		case .north: degrees =   0
		case .northEast: degrees = 45
		case .east:  degrees =  90
		case .southEast: degrees = 135
		case .south: degrees = 180
		case .southWest: degrees = 225
		case .west:  degrees = 270
		case .northWest: degrees = 315
		}
		return degrees
	}
	
	public static var cases: [PrincipalCardinalDirection] { 
		return [.north, .northEast, .east, .southEast, .south, .southWest, .west, .northWest]
	}
	
	public var cases: [PrincipalCardinalDirection] {
		let total = PrincipalCardinalDirection.cases.count
		var cases: [PrincipalCardinalDirection] = []
		let iterator = self.makeIterator()
		for _ in 0 ..< total {
			if let next = iterator.next() { 
				cases.append(next) 
			}
		}
		return cases
	}
	
	public var opposite: PrincipalCardinalDirection {
		switch self {
		case .north: 
			return .south
		case .northEast: 
			return .southWest
		case .east:  
			return .west
		case .southEast: 
			return .northWest
		case .south:
			return .north
		case .southWest: 
			return .northEast
		case .west:  
			return .east
		case .northWest: 
			return .southEast
		}
	}
	
	public func circularHeading(_ circlingDirection: CircularDirection) -> CardinalDirection {
		let heading: CardinalDirection
		switch self {
		case .north: 
			heading = .east
		case .northEast: 
			heading = .south
		case .east:  
			heading = .south
		case .southEast: 
			heading = .west
		case .south:
			heading = .west
		case .southWest: 
			heading = .north
		case .west:  
			heading = .north
		case .northWest: 
			heading = .east
		}
		return (circlingDirection == .clockwise) ? heading : heading.opposite
	}
}

extension PrincipalCardinalDirection: Sequence {
	public func makeIterator() -> AnyIterator<PrincipalCardinalDirection> {
		var isFirstRun = true
		var next = self
		let directions = PrincipalCardinalDirection.cases
		return AnyIterator<PrincipalCardinalDirection> {
			if isFirstRun {
				isFirstRun = false
				return self
			}
			if let i = directions.index(of: next) where i < directions.count - 1 {
				next = directions[i + 1]
			} else {
				next = directions.first!
			}
			return next
		}
	}
}

extension PrincipalCardinalDirection {
	
}

public enum CircularDirection {
	case clockwise
	case counterClockwise
}
