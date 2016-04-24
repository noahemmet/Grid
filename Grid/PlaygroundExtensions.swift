//
//  PlaygroundExtensions.swift
//  Grid
//
//  Created by Noah Emmet on 4/23/16.
//  Copyright © 2016 Sticks. All rights reserved.
//

import Foundation

public typealias ColorAtIndex = Int -> UIColor

public class GridVisualizer<Element: Hashable>: NSObject {
	public let grid: Grid<Element>
	public let collectionView: UICollectionView
	private let dataSource: DataSource
	
	public init(grid: Grid<Element>, colorAtIndexPath: ColorAtIndex) {
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: 10, height: 10)
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0
		let frame = CGRect(x: 0, y: 0, width: CGFloat(grid.rows) * layout.itemSize.width, height: CGFloat(grid.columns) * layout.itemSize.height)
		print(frame)
		self.collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
		self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: String(UICollectionViewCell))
		self.grid = grid
		self.dataSource = DataSource(rows: grid.rows, columns: grid.columns, colorAtIndexPath: colorAtIndexPath)
		self.collectionView.dataSource = self.dataSource
	}
}

private class DataSource: NSObject, UICollectionViewDataSource {
	let rows: Int
	let columns: Int
	let colorAtIndexPath: ColorAtIndex
	
	init(rows: Int, columns: Int, colorAtIndexPath: ColorAtIndex) {
		self.rows = rows
		self.columns = columns
		self.colorAtIndexPath = colorAtIndexPath
	}
		
	@objc func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	@objc func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return rows * columns
	}
	
	@objc func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(UICollectionViewCell), forIndexPath: indexPath)
		cell.backgroundColor = colorAtIndexPath(indexPath.row)
		return cell
	}
}

extension Grid where Element: CustomPlaygroundQuickLookable {
	public func customPlaygroundQuickLook() -> PlaygroundQuickLook {
		let f = elements.first!.customPlaygroundQuickLook()
		return f
	}
}

extension GridVisualizer: CustomPlaygroundQuickLookable {
	public func customPlaygroundQuickLook() -> PlaygroundQuickLook {
		return PlaygroundQuickLook.View(collectionView)
	}
}
