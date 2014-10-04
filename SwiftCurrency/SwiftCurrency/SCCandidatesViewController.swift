//
//  SCCandidatesViewController.swift
//  SwiftCurrency
//
//  Created by Teaualune Tseng on 2014/10/4.
//  Copyright (c) 2014年 corrugater. All rights reserved.
//

import UIKit


protocol SCCandidatesTableDelegate: NSObjectProtocol {
    func candidateDidChanged()
}

class SCCandidatesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private var currencyTable: UITableView!
    @IBOutlet private var navigationBarItem: UINavigationItem!
    private var selectedStatus: [Bool] = []
    private var mainIndex: Int = -1
    var delegate: SCCandidatesTableDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBarItem.title = NSLocalizedString("table_plus", comment: "table plus text")
        for ccy in SCModel.getInstance.currencies {
            selectedStatus.append(find(SCModel.getInstance.comparings, ccy) != nil)
        }
        mainIndex = find(SCModel.getInstance.currencies, SCModel.getInstance.selected!)!
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SCModel.getInstance.currencies.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier: NSString = "CellCurrencyCandidates"
        let cell: SCCurrencyCell! = currencyTable.dequeueReusableCellWithIdentifier(cellIdentifier) as SCCurrencyCell
        let ccy = SCModel.getInstance.currencies[indexPath.row]
        let rateValue = SCModel.getInstance.selected == nil ? ccy.rate : ccy.rate * SCModel.getInstance.selected!.rate
        cell.flagImageView.image = UIImage(named: ccy.imageName)
        cell.codeTextLabel.text = ccy.code()
        cell.fullNameTextLabel.text = ccy.fullName
        updateAccessoryType(cell, selected: selectedStatus[indexPath.row])
        return cell
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selectedStatus[indexPath.row] = self.addOrRemoveItemToComparings(indexPath.row)
        updateAccessoryType(tableView.cellForRowAtIndexPath(indexPath), selected: selectedStatus[indexPath.row])
        delegate?.candidateDidChanged()
    }

    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.row == self.mainIndex {
            return nil
        } else {
            return indexPath
        }
    }

    func updateAccessoryType(cell: UITableViewCell?, selected: Bool) {
        cell?.accessoryType = selected ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None
    }

    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func addOrRemoveItemToComparings(index: Int) -> Bool {
        let ccy = SCModel.getInstance.currencies[index]
        let found = find(SCModel.getInstance.comparings, ccy)
        if found == nil {
            SCModel.getInstance.comparings.append(ccy)
            return true
        } else {
            SCModel.getInstance.comparings.removeAtIndex(found!)
            return false
        }
    }
}
