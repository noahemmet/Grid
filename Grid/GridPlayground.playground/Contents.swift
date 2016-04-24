//: Playground - noun: a place where people can play

import Cocoa
import Grid
import XCPlayground

/*
o o o o o
o o o o o
o o x o o
o o o o o
o o o o o
*/

let world = World(rows: 25, columns: 25)
let worldSequence = WorldSequence(initial: world)
let worldView = WorldView(worldSequence: worldSequence)
XCPlaygroundPage.currentPage.liveView = worldView

// elementsAt

// elements at
//let elements = world.cells.elementsAt(row: 5, range:  4 ..< 16)
//print(elements.count)
//elements.forEach { $0.color = .redColor() } 

// extended selection

//let rings = world.cells.extendedSelection(around: GridPoint(row: 4, column: 4), range: 1..<4)
//
//var hue:  CGFloat = 0.5
//var saturation: CGFloat = 0.8
//let colorIncrement: CGFloat = 0.05
//for (r, ring) in rings.enumerate() {
//	for (i, cell) in ring.enumerate() {
//		cell.color = Color(hue: hue, saturation: saturation, brightness: 0.8, alpha: 1.0)
//	}
//	hue += colorIncrement
//	saturation -= colorIncrement
//}


var hue: CGFloat = 0.5
var saturation: CGFloat = 0.8
let colorIncrement: CGFloat = 0.01
for cell in world.cells.spiral(from: world.cells.center, clockwise: true) {
	cell.color = Color(hue: hue, saturation: saturation, brightness: 0.8, alpha: 1.0)
	hue += colorIncrement
	saturation -= colorIncrement
	cell
}
let cell = world.cells.elements[10]
cell
worldSequence.generate().next()
worldView
