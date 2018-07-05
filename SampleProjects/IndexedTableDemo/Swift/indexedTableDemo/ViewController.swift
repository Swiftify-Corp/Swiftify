//
//  ViewController.swift
//  indexedTableDemo
//
//  Created by Arthur Knopper on 12/13/12.
//  Copyright (c) 2012 Arthur Knopper. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var tableData: [Any] = []
    private var indexTitlesArray: [Any] = []

    override func viewDidLoad() {
        super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            /*self.tableData = [[NSArray alloc] initWithObjects:@"Aaron", @"Bailey", @"Cadan", @"Dafydd",  @"Eamonn", @"Fabian", @"Gabrielle", @"Hafwen", @"Isaac", @"Jacinta", @"Kathleen", @"Lucy", @"Maurice", @"Nadia", @"Octavia", @"Padraig", @"Quinta", @"Rachel", @"Sabina", @"Tabitha", @"Uma", @"Valentina", @"Wallis", @"Xanthe", @"Yvonne", @"Zebediah", nil];*/
        var numbers = "100 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500"
        tableData = numbers.components(separatedBy: " ")
        numbers = "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15"
        indexTitlesArray = numbers.components(separatedBy: " ")
        /*NSString *letters = @"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z";
            self.indexTitlesArray = [letters componentsSeparatedByString:@" "];*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cellIdentifier"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell?.textLabel?.text = tableData[indexPath.section] as? String
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return indexTitlesArray.count
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return indexTitlesArray as? [String]
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return (indexTitlesArray as NSArray).index(of: title)
    }
}