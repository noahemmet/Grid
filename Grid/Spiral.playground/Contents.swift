//: Playground - noun: a place where people can play

import UIKit
import Grid
import XCPlayground

let grid = Grid(rows: 20, columns: 20, repeatedValue: UIColor(hue: 0.5, saturation: 0.2, brightness: 1.0, alpha: 1.0))
let spiral = grid.spiral(from: grid.center)

var hue: CGFloat = 0
var saturation: CGFloat = 1
let colorIncrement: CGFloat = 0.02
var incrementing = true

var colorsForPoints: [GridPoint: UIColor] = [:]
for element in spiral {
	let color = UIColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1.0)
	saturation -= colorIncrement * (incrementing ? 1 : -1)
	hue += colorIncrement * (incrementing ? 1 : -1)
	if hue >= 1 || hue < 0 {
		incrementing = !incrementing
	}
	let index = grid[element]
	print(index)
//	let point = grid.gridPointOfIndex(index)
//	print(point)
//	colorsForPoints[point] = color
}

let visualizer = GridVisualizer<UIColor>(grid: grid) { index in
	let point = grid.gridPointOfIndex(index)
	return colorsForPoints[point]!
}

XCPlaygroundPage.currentPage.liveView = visualizer.collectionView
