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
        refreshControl.addTarget(self, action: "update", forControlEvents: UIControlEvents.ValueChanged)

        update()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return SCModel.getInstance.comparings.count

    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier: NSString = "CellShowCurrency"
        let cell: SCCurrencyCell! = currencyTable.dequeueReusableCellWithIdentifier(cellIdentifier) as SCCurrencyCell
        let ccy = SCModel.getInstance.comparings[indexPath.row]
        cell.flagImageView.image = UIImage(named: ccy.imageName)
        cell.codeTextLabel.text = ccy.code()
        cell.fullNameTextLabel.text = ccy.fullName
        cell.rateLabel!.text = NSString(format: "%f", ccy.rate)
        return cell
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key: NSString = "table_section_title_other"
        return NSLocalizedString(key, comment: "")
    }
    
    @IBAction func closeFromInfo(sender:UIStoryboardSegue) {
        
    }

    func update() {
        SCModel.update({
            self.currencyTable.reloadData()
            self.refreshControl.endRefreshing()
        })
    }

    func rateInputValue() -> Float {
        let rateInputCell: SCMainCurrencyCell = self.currencyTable.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as SCMainCurrencyCell!
        return (rateInputCell.rateInput.text as NSString).floatValue
    }

}
