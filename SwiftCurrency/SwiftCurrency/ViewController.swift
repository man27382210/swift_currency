//
//  ViewController.swift
//  SwiftCurrency
//
//  Created by man27382210 on 2014/9/21.
//  Copyright (c) 2014年 corrugater. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableCurrecny:UITableView!
    var refreshController:UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshController = UIRefreshControl()
        tableCurrecny.addSubview(refreshController)
        refreshController.addTarget(self, action: "tableRefresh", forControlEvents: UIControlEvents.ValueChanged)
        var filePath = NSBundle.mainBundle().pathForResource("countries", ofType: "json")
        var data = NSData(contentsOfFile: filePath!)
        var json: NSArray = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSArray
        NSLog("%@", json)
        NSLog("%@", NSLocalizedString("XDR", tableName: "Currencies", comment: ""))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        if(indexPath.section == 0){
            cell = tableCurrecny.dequeueReusableCellWithIdentifier("CellMainCurrency") as UITableViewCell
        }else{
            cell = tableCurrecny.dequeueReusableCellWithIdentifier("CellShowCurrency") as UITableViewCell
        }
        
        return cell
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 20;
        }else{
            return 20;
        }
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return NSLocalizedString("table_section_title_main", comment: "")
        } else {
            return NSLocalizedString("table_section_title_other", comment: "")
        }
    }
    func tableRefresh() {
        refreshController.endRefreshing()
        tableCurrecny.reloadData()
    }
    
    @IBAction func closeFromInfo(sender:UIStoryboardSegue) {
        
    }
}

