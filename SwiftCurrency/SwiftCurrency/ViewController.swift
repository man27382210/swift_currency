//
//  ViewController.swift
//  SwiftCurrency
//
//  Created by man27382210 on 2014/9/21.
//  Copyright (c) 2014年 corrugater. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var currencyTable: UITableView!
    private var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshControl = UIRefreshControl()
        currencyTable.addSubview(refreshControl)
        refreshControl.addTarget(self, action: "tableRefresh", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return SCModel.getInstance.currencies.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier: NSString = (indexPath.section == 0) ? "CellMainCurrency" : "CellShowCurrency"
        let cell: SCCurrencyCell! = currencyTable.dequeueReusableCellWithIdentifier(cellIdentifier) as SCCurrencyCell
        let ccy: SCCurrency = SCModel.getInstance.currencies[indexPath.item] as SCCurrency
        cell.flagImageView.image = UIImage(named: ccy.imageName)
        
        return cell
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0) ? 20 : 30
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key: NSString = (section == 0) ? "table_section_title_main" : "table_section_title_other"
        return NSLocalizedString(key, comment: "")
    }

    func tableRefresh() {
        refreshControl.endRefreshing()
        currencyTable.reloadData()
    }
    
    @IBAction func closeFromInfo(sender:UIStoryboardSegue) {
        
    }
}

