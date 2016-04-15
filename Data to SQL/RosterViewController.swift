//
//  RosterViewController.swift
//  Data to SQL
//
//  Created by Tao Sun on 1/7/28 H.
//  Copyright © 28 Heisei Yikkuro's Workshop. All rights reserved.
//

import Cocoa

class RosterViewController: NSViewController, NSXMLParserDelegate {

    @IBOutlet weak var Output_file_name: NSTextField!
    @IBOutlet weak var browse_file_name: NSTextField!
    @IBOutlet weak var BrowseFileScript: NSButton!
    @IBOutlet weak var BrowseFileWord: NSButton!
    var xmlParser:NSXMLParser!
    var roster_test:ROSTER_TEMP=ROSTER_TEMP()
    var output:RosterOutput=RosterOutput()
    var word_output:RosterWordOutput=RosterWordOutput()
    
    @IBAction func Generate(sender: AnyObject) {
        if Output_file_name.stringValue != ""{
            self.output.OutputToFile(self.Output_file_name.stringValue+".sql")
            
            let alert = NSAlert()
            alert.messageText="Finished"
            alert.informativeText="Output Finished"
            alert.alertStyle = NSAlertStyle.WarningAlertStyle
            alert.addButtonWithTitle("OK")
            let _ = alert.runModal()
        }
        else {
            let alert = NSAlert()
            alert.messageText="Error"
            alert.informativeText="Please specify a name"
            alert.alertStyle = NSAlertStyle.WarningAlertStyle
            alert.addButtonWithTitle("OK")
            let _ = alert.runModal()
        }
    }
    
    @IBAction func browseFileAction(sender: AnyObject) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.beginWithCompletionHandler { (result) -> Void in
            if result == NSFileHandlingPanelOKButton {
                //Do what you will
                //If there's only one URL, surely 'openPanel.URL'
                //but otherwise a for loop works
                //print(openPanel.URL!.lastPathComponent!)
                self.roster_test=ROSTER_TEMP()
                self.output=RosterOutput()
                
                
                self.refreshParser(openPanel.URL!)
                self.browse_file_name.stringValue=String(openPanel.URL!);
                self.roster_test.dataset.filename=openPanel.URL!.lastPathComponent!
                self.output=RosterOutput(dataset:self.roster_test.dataset)
                //self.ShowCustomAlert()
            }
        }
    }
    @IBAction func browseFileWordAction(sender: AnyObject) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.beginWithCompletionHandler { (result) -> Void in
            if result == NSFileHandlingPanelOKButton {
                //Do what you will
                //If there's only one URL, surely 'openPanel.URL'
                //but otherwise a for loop works
                //print(openPanel.URL!.lastPathComponent!)
                self.refreshParser(openPanel.URL!)
                self.word_output=RosterWordOutput(data: self.roster_test.dataset, startDate:NSDate(), endDate:NSDate(), currentMonth:NSDate())
                //self.ShowCustomAlert()
            }
        }
    }
/*
    func ShowCustomAlert() {
        let alert = NSAlert()
        alert.messageText = "Commands"
        alert.informativeText = ""
        for i in 0..<output.commands.count {
            alert.informativeText+=output.commands[i]!+"\n"
        }
        alert.addButtonWithTitle("OK")
        let _ = alert.runModal()
        
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let data = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if roster_test.elementName=="value" {
            roster_test.value=VALUE(value: data)
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName=="value" {
            roster_test.value_list.append(roster_test.value)
        }
        else if elementName=="row" {
            roster_test.row=ROW(value_list: roster_test.value_list)
            roster_test.row_list.append(roster_test.row)
            roster_test.value_list=[]
        }
        else if elementName=="metadata" {
            roster_test.metadata=METADATA(item_list: roster_test.item_list)
        }
        else if elementName=="data" {
            roster_test.data=DATA(row_list: roster_test.row_list)
        }
        else if elementName=="dataset" {
            roster_test.dataset=DATASET(metadata: roster_test.metadata, data: roster_test.data)
        }
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
            roster_test.elementName=elementName
        
            //print(elementName)
            if elementName=="item" {
                roster_test.item=ITEM(name:String(stringInterpolationSegment: attributeDict["name"]))
                roster_test.item_list.append(roster_test.item)
            }
            else if elementName=="value" {
                roster_test.value=VALUE()
                roster_test.value.value=nil
            }
        
    }
    
    
    
    func refreshParser(URL:NSURL){
        //print()
        let url:NSURL = URL
        xmlParser = NSXMLParser(contentsOfURL: url)
        xmlParser.delegate = self
        xmlParser.parse()
        //print(roster_test.data.row_list[0].value_list[0].value)

    }
    
}
