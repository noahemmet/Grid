//: Playground - noun: a place where people can play

import UIKit
import Grid
import XCPlayground

var hue: CGFloat = 0
var saturation: CGFloat = 1
let colorIncrement: CGFloat = 0.02
var incrementing = true
let grid = Grid(rows: 20, columns: 20) { (row, column) -> UIColor in
	let color = UIColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1.0)
	saturation -= colorIncrement * (incrementing ? 1 : -1)
	hue += colorIncrement * (incrementing ? 1 : -1)
	if hue >= 1 || hue < 0 {
		incrementing = !incrementing
	}
	return color
}

let visualizer = GridVisualizer<UIColor>(grid: grid) { index in
	return grid[index]
}

XCPlaygroundPage.currentPage.liveView = visualizer.collectionView
