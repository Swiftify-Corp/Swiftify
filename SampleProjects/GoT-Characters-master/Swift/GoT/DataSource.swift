//
//  DataSource.swift
//  GoT
//
//  Created by piotrom1 on 26/10/15.
//  Copyright © 2015 Maciej Piotrowski. All rights reserved.
//

import UIKit

typealias CellConfigureBlock = (UITableViewCell, IndexPath, Any) -> Void

class DataSource: NSObject, UITableViewDataSource {
    weak var tableView: UITableView?
    var cellReuseIdentifier: String {
        return reuseIdentifier
    }
    var cellConfigureBlock: CellConfigureBlock?

    private var reuseIdentifier = ""
    private var mutableItems: [AnyHashable] = []

    init(cellConfigureBlock configureBlock: CellConfigureBlock?, cellReuseIdentifier reuseIdentifier: String) {
        super.init()
        
        cellConfigureBlock = configureBlock
        self.reuseIdentifier = reuseIdentifier
        mutableItems = [AnyHashable]()
    
    }

    func addItems(_ items: [Any]!) {
        if let anItems = items as? [AnyHashable] {
            mutableItems.append(contentsOf: anItems)
        }
        mutableItems = (mutableItems as NSArray).sortedArray(using: [NSSortDescriptor(key: "title", ascending: true)]) as? [AnyHashable] ?? mutableItems // Hack for sorting Articles by their title. Crash if anything other than
        // Article stored as item. Solution: use objc generics and protocol -
        // func keyForSorting -> String
        if tableView != nil {
            DispatchQueue.main.async(execute: {
                self.tableView?.reloadData()
            })
        }
    } // reloads tableView on main queue

    func setItems(_ items: [Any]) {
        mutableItems.removeAll()
        addItems(items)
    } // reloads tableView on main queue

    func item(at indexPath: IndexPath) -> Any? {
        var item: Any?
        let index: Int = indexPath.row
        if index < mutableItems.count {
            item = mutableItems[index]
        }
        return item
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mutableItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let item = self.item(at: indexPath)
        if item != nil {
            cellConfigureBlock?(cell, indexPath, item!)
        }
        return cell
    }
}