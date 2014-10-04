//
//  ViewController.swift
//  SwiftCurrency
//
//  Created by man27382210 on 2014/9/21.
//  Copyright (c) 2014年 corrugater. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, SCCandidatesTableDelegate {

    @IBOutlet private var currencyTable: UITableView!
    @IBOutlet private var currencyTextField: UITextField!

    @IBOutlet private var mainCurrencyFlagImageView: UIImageView!
    @IBOutlet private var mainCurrencyCodeTextLabel: UILabel!
    @IBOutlet private var mainCurrencyFullNameTextLabel: UILabel!

    private let refreshControl: UIRefreshControl = UIRefreshControl()

    private let editText = NSLocalizedString("Edit", comment: "Edit")
    private let aboutText = NSLocalizedString("About", comment: "About")
    private let doneText = NSLocalizedString("Done", comment: "Done")

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = NSLocalizedString("navigation_title", comment: "navigation_title")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: editText, style: UIBarButtonItemStyle.Plain, target: self, action: "toggleEdit:")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: aboutText, style: UIBarButtonItemStyle.Plain, target: self, action: "showAbout:")

        currencyTable.addSubview(refreshControl)
        refreshControl.addTarget(self, action: "update", forControlEvents: UIControlEvents.ValueChanged)

        let keyboardToolbar = UIToolbar()
        let fixedSpaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        fixedSpaceItem.width = 30.0
        keyboardToolbar.sizeToFit()
        keyboardToolbar.setItems([
            UIBarButtonItem(title: "1.0", style: UIBarButtonItemStyle.Bordered, target: self, action: "resetTextNumber:"),
            fixedSpaceItem,
            UIBarButtonItem(title: " \u{2022} ", style: UIBarButtonItemStyle.Bordered, target: self, action: "addDot:"),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: doneText, style: UIBarButtonItemStyle.Bordered, target: self, action: "dismissKeyboard:")
        ], animated: false)
        self.currencyTextField.inputAccessoryView = keyboardToolbar

        setMainCurrency()
        update()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func update() {
        SCModel.update {
            self.currencyTable.reloadData()
            self.refreshControl.endRefreshing()
        }
    }

    func rateInputValue() -> Float {
        let rateInputCell: SCMainCurrencyCell = self.currencyTable.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as SCMainCurrencyCell!
        return (rateInputCell.rateInput.text as NSString).floatValue
    }

    func toggleEdit(sender: AnyObject) {
        self.currencyTable.setEditing(!self.currencyTable.editing, animated: true)
        self.navigationItem.leftBarButtonItem?.title = self.currencyTable.editing ? doneText : editText
        self.currencyTable.reloadRowsAtIndexPaths([NSIndexPath(forRow: SCModel.getInstance.comparings.count, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
    }

    func showAbout(sender: AnyObject) {
        self.performSegueWithIdentifier("ShowAboutSegue", sender: self)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    func dismissKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }

    func addDot(sender: AnyObject) {
        let text = self.currencyTextField.text
        if text.rangeOfString(".") == nil {
            self.currencyTextField.text = self.currencyTextField.text + "."
        }
    }

    func resetTextNumber(sender: AnyObject) {
        self.currencyTextField.text = "1.0"
        self.updateCurrencyValue(self.currencyTextField.text)
        self.dismissKeyboard(sender)
    }

    @IBAction func textFieldValueDidChanged(sender: UITextField) {
        self.updateCurrencyValue(sender.text)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPlusSegue" {
            let vc = segue.destinationViewController as SCCandidatesViewController
            vc.delegate = self
        }
    }

    func updateCurrencyValue(text: NSString) {
        let ccy = text.doubleValue
        let selected = SCModel.getInstance.selected
        if selected != nil {
            selected!.rate(ccy)
            self.currencyTable.reloadData()
        }
    }

    func setMainCurrency() {
        let selected = SCModel.getInstance.selected
        if selected != nil {
            self.currencyTextField.text = "1.0"
            self.mainCurrencyFlagImageView.image = UIImage(named: selected!.imageName)
            self.mainCurrencyCodeTextLabel.text = selected!.code()
            self.mainCurrencyFullNameTextLabel.text = selected!.fullName
        }
    }

    func setupCurrencyCell(index: Int) -> UITableViewCell {
        let cellIdentifier: NSString = "CellShowCurrency"
        let cell: SCCurrencyCell! = currencyTable.dequeueReusableCellWithIdentifier(cellIdentifier) as SCCurrencyCell
        let ccy = SCModel.getInstance.comparings[index]
        let rateValue = SCModel.getInstance.selected == nil ? ccy.rate : ccy.rate * SCModel.getInstance.selected!.rate
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.flagImageView.image = UIImage(named: ccy.imageName)
        cell.codeTextLabel.text = ccy.code()
        cell.fullNameTextLabel.text = ccy.fullName
        cell.rateLabel!.text = NSString(format: "%f", rateValue)
        return cell
    }

    func setupPlusCell() -> UITableViewCell {
        let cellIdentifier: NSString = "CellPlus"
        let cell: SCPlusCell! = currencyTable.dequeueReusableCellWithIdentifier(cellIdentifier) as SCPlusCell
        cell.titleLabel.text = NSLocalizedString("table_plus", comment: "table plus text")
        cell.titleLabel.hidden = !self.currencyTable.editing
        return cell
    }

    func candidateDidChanged() {
        self.currencyTable.reloadData()
    }

// pragma mark - UITableView delegate and dataSource

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SCModel.getInstance.comparings.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == SCModel.getInstance.comparings.count {
            return setupPlusCell()
        } else {
            return setupCurrencyCell(indexPath.row)
        }
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("table_section_title_other", comment: "")
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if self.currencyTable.editing && indexPath.row < SCModel.getInstance.comparings.count {
            return true
        } else {
            return false
        }
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        SCModel.getInstance.comparings.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == SCModel.getInstance.comparings.count {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.performSegueWithIdentifier("ShowPlusSegue", sender: self)
        }
    }

    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if self.currencyTable.editing && indexPath.row == SCModel.getInstance.comparings.count {
            return indexPath
        } else {
            return nil
        }
    }
}
