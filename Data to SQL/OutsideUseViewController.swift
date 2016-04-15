//
//  ViewController.swift
//  Data to SQL
//
//  Created by Tao Sun on 1/6/28 H.
//  Copyright © 28 Heisei Yikkuro's Workshop. All rights reserved.
//

import Cocoa
//import sqlite3

class OutsideUseViewController: NSViewController, NSXMLParserDelegate {
    var xmlParser:NSXMLParser!
    var report_test:OUTSIDE_USE_TEMP=OUTSIDE_USE_TEMP()
    var output:OutsideUseOutput=OutsideUseOutput()
    var word_output:OutsideUseWordOutput=OutsideUseWordOutput()
    @IBOutlet weak var BrowseFile: NSButton!
    @IBOutlet weak var browse_file_name: NSTextField!
    @IBOutlet weak var Output_file_name: NSTextField!
    @IBOutlet weak var BrowseWordFile: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(122)
        
        //print(report_test.report.group.provider.patient_list[0].service_dtl1_list[0].service_description.txt)
        // Do any additional setup after loading the view.
    }
    
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
    
    @IBAction func browseWordFileAction(sender: AnyObject) {
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
                self.refreshParser(openPanel.URL)
                //self.word_output=OutsideUseWordOutput(report: self.report_test.report)
                //self.word_output.OutputToFile("TestOutsideUseWord.txt")
                //self.ShowCustomAlert()
            }
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
                
                
                self.report_test=OUTSIDE_USE_TEMP()
                self.output=OutsideUseOutput()
                
                
                self.browse_file_name.stringValue=String(openPanel.URL!)
                self.refreshParser(openPanel.URL)
                self.output=OutsideUseOutput(data:self.report_test.report, file_name:openPanel.URL!.lastPathComponent!)
                //self.ShowCustomAlert()
            }
        }
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
/*    func ShowCustomAlert() {
        let alert = NSAlert()
        alert.messageText = "Commands"
        alert.informativeText = ""
        for i in 0..<output.commands.count {
            alert.informativeText+=output.commands[i]!+"\n"
        }
        alert.addButtonWithTitle("OK")
        let _ = alert.runModal()
        
    }*/
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        report_test.elementName=elementName
    }
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName=="REPORT-DTL" {
            report_test.report_dtl=REPORT_DTL(report_id: report_test.report_id, report_date: report_test.report_date, report_name: report_test.report_name, report_period_start: report_test.report_period_start, report_period_end: report_test.report_period_end)
        }
        else if elementName=="GROUP-DTL" {
            report_test.group_dtl=GROUP_DTL(group_id: report_test.group_id, group_type: report_test.group_type, group_name: report_test.group_name)
        }
        else if elementName=="PROVIDER-DTL" {
            report_test.provider_dtl=PROVIDER_DTL(provider_number: report_test.provider_number, provider_last_name: report_test.provider_last_name, provider_first_name: report_test.provider_first_name, provider_middle_name: report_test.provider_middle_name)
            //print(report_test.provider_dtl.provider_number.txt)
        }
        else if elementName=="PATIENT-DTL" {
            report_test.patient_dtl=PATIENT_DTL(patient_health_number: report_test.patient_health_number, patient_last_name: report_test.patient_last_name, patient_first_name: report_test.patient_first_name, patient_birthdate: report_test.patient_birthdate, patient_sex: report_test.patient_sex)
        }
        else if elementName=="SERVICE-DTL1" {
            report_test.service_dtl1=SERVICE_DTL1(service_date: report_test.service_date, service_code: report_test.service_code, service_amt: report_test.service_amt, service_description: report_test.service_description)
            report_test.service_dtl1_list.append(report_test.service_dtl1)
        }
        else if elementName=="PATIENT" {
            report_test.patient=PATIENT(patient_dtl: report_test.patient_dtl, service_dtl1_list: report_test.service_dtl1_list)
            report_test.patient_list.append(report_test.patient)
            report_test.service_dtl1_list=[]
        }
        else if elementName=="PROVIDER" {
            report_test.provider=PROVIDER(provider_dtl: report_test.provider_dtl, patient_list: report_test.patient_list)
        }
        else if elementName=="GROUP" {
            report_test.group=GROUP(group_dtl: report_test.group_dtl, provider: report_test.provider)
        }
        else if elementName=="REPORT" {
            report_test.report=REPORT(report_dtl: report_test.report_dtl, group: report_test.group)
        }
    }
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let data = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        //print(data)
        if report_test.elementName=="REPORT-ID" {
            report_test.report_id=REPORT_ID(txt: data)
        }
        else if report_test.elementName=="REPORT-DATE"{
            report_test.report_date=REPORT_DATE(txt: data)
        }
        else if report_test.elementName=="REPORT-NAME"{
            report_test.report_name=REPORT_NAME(txt: data)
        }
        else if report_test.elementName=="REPORT-PERIOD-START"{
            report_test.report_period_start=REPORT_PERIOD_START(txt: data)
        }
        else if report_test.elementName=="REPORT-PERIOD-END"{
            report_test.report_period_end=REPORT_PERIOD_END(txt: data)
        }
        else if report_test.elementName=="PROVIDER-NUMBER"{
            report_test.provider_number=PROVIDER_NUMBER(txt: data)
        }
        else if report_test.elementName=="PROVIDER-LAST-NAME"{
            report_test.provider_last_name=PROVIDER_LAST_NAME(txt: data)
        }
        else if report_test.elementName=="PROVIDER-FIRST-NAME"{
            report_test.provider_first_name=PROVIDER_FIRST_NAME(txt: data)
        }
        else if report_test.elementName=="PROVIDER-MIDDLE-NAME"{
            report_test.provider_middle_name=PROVIDER_MIDDLE_NAME(txt: data)
        }
        else if report_test.elementName=="PATIENT-HEALTH-NUMBER"{
            report_test.patient_health_number=PATIENT_HEALTH_NUMBER(txt: data)
        }
        else if report_test.elementName=="PATIENT-LAST-NAME"{
            report_test.patient_last_name=PATIENT_LAST_NAME(txt: data)
        }
        else if report_test.elementName=="PATIENT-FIRST-NAME"{
            report_test.patient_first_name=PATIENT_FIRST_NAME(txt: data)
        }
        else if report_test.elementName=="PATIENT-BIRTHDATE"{
            report_test.patient_birthdate=PATIENT_BIRTHDATE(txt: data)
        }
        else if report_test.elementName=="PATIENT-SEX"{
            report_test.patient_sex=PATIENT_SEX(txt: data)
        }
        else if report_test.elementName=="SERVICE-DATE"{
            report_test.service_date=SERVICE_DATE(txt: data)
        }
        else if report_test.elementName=="SERVICE-CODE"{
            report_test.service_code=SERVICE_CODE(txt: data)
        }
        else if report_test.elementName=="SERVICE-DESCRIPTION"{
            report_test.service_description=SERVICE_DESCRIPTION(txt: data)
        }
        else if report_test.elementName=="SERVICE-AMT"{
            report_test.service_amt=SERVICE_AMT(txt: data)
        }
        else if report_test.elementName=="GROUP-ID"{
            report_test.group_id=GROUP_ID(txt:data)
        }
        else if report_test.elementName=="GROUP-TYPE"{
            report_test.group_type=GROUP_TYPE(txt:data)
        }
        else if report_test.elementName=="GROUP-NAME"{
            report_test.group_name=GROUP_NAME(txt:data)
        }

    }

    /*func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    
    }
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
    
    }
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
            }*/
    
    func refreshParser(URL:NSURL?){
        let url:NSURL = URL!
        xmlParser = NSXMLParser(contentsOfURL: url)
        xmlParser.delegate = self
        xmlParser.parse()
        //print(report_test.report.group.provider.patient_list[0].service_dtl1_list[0].service_description.txt)
    }
}

