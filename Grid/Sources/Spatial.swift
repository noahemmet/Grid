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
	case Forward
	case Backward
	case Left
	case Right
	
	public var degrees: Degree {
		let degrees: Degree
		switch self {
		case .Forward:  degrees =   0
		case .Backward: degrees = 180
		case .Right:		degrees =  90
		case .Left:		degrees = 270
		}
		return degrees
	}
}

public enum CardinalDirection: CasesProtocol {
	case North
	case East
	case South
	case West
	
	public var degrees: Degree {
		let degrees: Degree
		switch self {
		case .North: degrees =   0
		case .East:  degrees =  90
		case .South: degrees = 180
		case .West:  degrees = 270
		}
		return degrees
	}
	
	public static var cases: [CardinalDirection] {
		return [.North, .East, .South, .West]
	}
	
	public func rangeAroundPoint() {
		
	}
	
	public var opposite: CardinalDirection {
		switch self {
		case .North: 
			return .South
		case .East:  
			return .West
		case .South:
			return .North
		case .West:  
			return .East
		}
	}
}

public enum PrincipalCardinalDirection: Int, CasesProtocol {
	case North
	case NorthEast
	case East
	case SouthEast
	case South
	case SouthWest
	case West
	case NorthWest
	
	public var degrees: Degree {
		let degrees: Degree
		switch self {
		case .North: degrees =   0
		case .NorthEast: degrees = 45
		case .East:  degrees =  90
		case .SouthEast: degrees = 135
		case .South: degrees = 180
		case .SouthWest: degrees = 225
		case .West:  degrees = 270
		case .NorthWest: degrees = 315
		}
		return degrees
	}
	
	public static var cases: [PrincipalCardinalDirection] { 
		return [.North, .NorthEast, .East, .SouthEast, .South, .SouthWest, .West, .NorthWest]
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
		case .North: 
			return .South
		case .NorthEast: 
			return .SouthWest
		case .East:  
			return .West
		case .SouthEast: 
			return .NorthWest
		case .South:
			return .North
		case .SouthWest: 
			return .NorthEast
		case .West:  
			return .East
		case .NorthWest: 
			return .SouthEast
		}
	}
	
	public func circularHeading(circlingDirection: CircularDirection) -> CardinalDirection {
		let heading: CardinalDirection
		switch self {
		case .North: 
			heading = .East
		case .NorthEast: 
			heading = .South
		case .East:  
			heading = .South
		case .SouthEast: 
			heading = .West
		case .South:
			heading = .West
		case .SouthWest: 
			heading = .North
		case .West:  
			heading = .North
		case .NorthWest: 
			heading = .East
		}
		return (circlingDirection == .Clockwise) ? heading : heading.opposite
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
	case Clockwise
	case CounterClockwise
}