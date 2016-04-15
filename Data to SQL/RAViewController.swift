//
//  RAViewController.swift
//  Data to SQL
//
//  Created by Tao Sun on 1/14/28 H.
//  Copyright © 28 Heisei Yikkuro's Workshop. All rights reserved.
//

import Cocoa

class RAViewController: NSViewController {

    var FileContentInline:String=""
    var FileContents:[String]=[]
    var ra_file:RA_FILE=RA_FILE()
    var commands:[String]=[]
    var ra_output:RAOutout?=nil
    @IBOutlet weak var Output_file_name: NSTextField!
    
    @IBOutlet weak var browse_file_name: NSTextField!
    
    @IBOutlet weak var generate_button: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func Generate(sender: AnyObject) {
        if Output_file_name.stringValue != ""{
            self.ra_output?.OutputToFile(Output_file_name.stringValue+".sql")
            
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
    
    func subStringWithRange(oriString:String, start:Int, Len:Int)->String {
        if oriString==""{
            return ""
        }
        
        return oriString.substringWithRange(Range<String.Index>(start:oriString.startIndex.advancedBy(start-1), end:oriString.startIndex.advancedBy(start-1+Len)))
    }
    
    func subStringWithStart(oriString:String, start:Int)->String {
        if oriString==""{
            return ""
        }
        return oriString.substringFromIndex(oriString.startIndex.advancedBy(start-1))
    }
    
    func subStringWithEnd(oriString:String, end:Int)->String {
        if oriString==""{
            return ""
        }
        return oriString.substringToIndex(oriString.startIndex.advancedBy(end))
    }
    
    func create_ra_file() {
        for line in FileContents {
            let identifier=self.subStringWithRange(line, start: 1, Len:3)
            //print(identifier)
            switch identifier {
            case "HR1":
                self.ra_file.file_header=FILE_HEADER_RECORD(data: line)
            case "HR2":
                self.ra_file.address_one=ADDRESS_RECORD_ONE(data: line)
            case "HR3":
                self.ra_file.address_two=ADDRESS_RECORD_TWO(data: line)
            case "HR4":
                self.ra_file.claims.append(CLAIM(claim_header: CLAIM_HEADER_RECORD(data:line), claim_items: []))
            case "HR5":
                self.ra_file.claims.last?.claim_items.append(CLAIM_ITEM_RECORD(data:line))
            case "HR6":
                self.ra_file.balance_forward=BALANCE_FORWARD_RECORD(data:line)
            case "HR7":
                self.ra_file.accounting_transactions.append(ACCOUNTING_TRANSACTION_RECORD(data:line))
            case "HR8":
                ra_file.messages.append(MESSAGE_FACILITY_RECORD(data:line))
            default:
                break
            }
        }
    }
    
    
    @IBAction func browseSQLFileAction(sender: AnyObject) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.beginWithCompletionHandler { (result) -> Void in
            if result == NSFileHandlingPanelOKButton {
                let temp=String(openPanel.URL!)
                do{
                    
                    self.FileContentInline=""
                    self.FileContents=[]
                    self.ra_file=RA_FILE()
                    self.commands=[]
                    self.ra_output=nil
                    
                    
                    self.browse_file_name.stringValue=temp
                    try self.FileContentInline = String(contentsOfFile:self.subStringWithStart(temp, start: 8), encoding: NSUTF8StringEncoding)
                    self.FileContents=self.FileContentInline.componentsSeparatedByString("\n")
                    self.create_ra_file()
                    self.ra_output=RAOutout(ra_file: self.ra_file, file_name:openPanel.URL!.lastPathComponent!)
                    //self.create_commands()
                    //print(self.ra_file.file_header!.group_number)
                    //print(self.FileContents.count)
                }
                catch {
                    print(error)
                }
                
                //Do what you will
                //If there's only one URL, surely 'openPanel.URL'
                //but otherwise a for loop works
                //print(openPanel.URL!.lastPathComponent!)
                //self.ShowCustomAlert()
            }
        }
    }
}
