//
//  SyncViewController.swift
//  Data to SQL
//
//  Created by Tao Sun on 1/13/28 H.
//  Copyright © 28 Heisei Yikkuro's Workshop. All rights reserved.
//

import Cocoa

class SyncViewController: NSViewController, NSXMLParserDelegate {

    @IBOutlet weak var BrowseRosterButton: NSButton!
    @IBOutlet weak var BrowseOutsideUseButton: NSButton!
    @IBOutlet weak var BrowseRAButton: NSButton!
    @IBOutlet weak var doc_name: NSTextField!
    @IBOutlet weak var RosterFolderURL: NSTextField!
    @IBOutlet weak var OutsideUseFolderURL: NSTextField!
    @IBOutlet weak var RAFolderURL: NSTextField!

    @IBOutlet weak var sync_output_file_name: NSTextField!
    
    @IBOutlet weak var roster_start_date: NSDatePicker!
    
    @IBOutlet weak var roster_end_date: NSDatePicker!
    
    var current_generate:Int = 0
    var xmlParser:NSXMLParser!
    
    var roster_word_output:RosterWordOutput=RosterWordOutput()
    var roster_test:ROSTER_TEMP=ROSTER_TEMP()
    
    var report_test:OUTSIDE_USE_TEMP=OUTSIDE_USE_TEMP()
    var outside_use_output:OutsideUseWordOutput=OutsideUseWordOutput()
    var patient_list:[PATIENT]=[]
    
    var ra_file:RA_FILE=RA_FILE()
    var ra_files:[RA_FILE]=[]
    
    var commands:[String] = []
    var utility:UTILITY=UTILITY()
    var ra_word_output:RAWordOutput?=nil
    
    var num_name_dict:[String:String]=[String:String]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func browseRAFolder(sender: AnyObject) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = false
        openPanel.beginWithCompletionHandler { (result) -> Void in
            if result == NSFileHandlingPanelOKButton {
                //Do what you will
                //If there's only one URL, surely 'openPanel.URL'
                //but otherwise a for loop works
                //self.ShowCustomAlert()
                self.RAFolderURL.stringValue=String(openPanel.URL!)
            }
        }
    }
    
    @IBAction func browseRosterFolder(sender: AnyObject) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = false
        openPanel.beginWithCompletionHandler { (result) -> Void in
            if result == NSFileHandlingPanelOKButton {
                //Do what you will
                //If there's only one URL, surely 'openPanel.URL'
                //but otherwise a for loop works
                //self.ShowCustomAlert()
                self.RosterFolderURL.stringValue=String(openPanel.URL!)
            }
        }
    }
    @IBAction func browseOutsideUseFolder(sender: AnyObject) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = false
        openPanel.beginWithCompletionHandler { (result) -> Void in
            if result == NSFileHandlingPanelOKButton {
                //Do what you will
                //If there's only one URL, surely 'openPanel.URL'
                //but otherwise a for loop works
                //self.ShowCustomAlert()
                self.OutsideUseFolderURL.stringValue=String(openPanel.URL!)
            }
        }
    }
    
    func get_month_diff(start_date:NSDate, end_date:NSDate)->Int {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: start_date, toDate: end_date, options: NSCalendarOptions()).month
    }
    
    
    
    @IBAction func Generate(sender: AnyObject) {
        
        let alert = NSAlert()
        
        if RAFolderURL.stringValue=="" {
            alert.messageText="Error"
            alert.informativeText="Please Choose RA Folder"
            alert.alertStyle = NSAlertStyle.WarningAlertStyle
            alert.addButtonWithTitle("OK")
            let _ = alert.runModal()
        }
        else if RosterFolderURL.stringValue=="" {
            alert.messageText="Error"
            alert.informativeText="Please Choose Roseter Folder"
            alert.alertStyle = NSAlertStyle.WarningAlertStyle
            alert.addButtonWithTitle("OK")
            let _ = alert.runModal()
        }
        else if OutsideUseFolderURL.stringValue=="" {
            alert.messageText="Error"
            alert.informativeText="Please Choose Outside Use Folder"
            alert.alertStyle = NSAlertStyle.WarningAlertStyle
            alert.addButtonWithTitle("OK")
            let _ = alert.runModal()
        }
        else if doc_name.stringValue=="" {
            alert.messageText="Error"
            alert.informativeText="Please Enter Doctor's Name"
            alert.alertStyle = NSAlertStyle.WarningAlertStyle
            alert.addButtonWithTitle("OK")
            let _ = alert.runModal()
        }
        else if roster_start_date.dateValue.compare(roster_end_date.dateValue) == NSComparisonResult.OrderedDescending {
            alert.messageText="Error"
            alert.informativeText="Start Date is larger than End date"
            alert.alertStyle = NSAlertStyle.WarningAlertStyle
            alert.addButtonWithTitle("OK")
            let _ = alert.runModal()
        }
        else if self.sync_output_file_name.stringValue=="" {
            alert.messageText="Error"
            alert.informativeText="Please Enter Output File Name"
            alert.alertStyle = NSAlertStyle.WarningAlertStyle
            alert.addButtonWithTitle("OK")
            let _ = alert.runModal()
        }
        else {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM, yyyy"
            
            commands=[]
            commands.append("docname|"+self.doc_name.stringValue)
            commands.append("time|"+dateFormatter.stringFromDate(self.roster_start_date.dateValue)+" - "+dateFormatter.stringFromDate(self.roster_end_date.dateValue))
            
            current_generate = 1
            var temp_commands:[String]=[]
            let filemanager:NSFileManager = NSFileManager()
            var files = filemanager.enumeratorAtPath(self.ReplaceSpace(self.RosterFolderURL.stringValue.substringFromIndex(RosterFolderURL.stringValue.startIndex.successor().successor().successor().successor().successor().successor().successor())))
            //print(self.RosterFolderURL.stringValue)
            dateFormatter.dateFormat="MMMyyyy"
            
            let month_amt:Int=get_month_diff(self.roster_start_date.dateValue, end_date: roster_end_date.dateValue)
            var ra_missing=true, outside_use_missing=true, roster_missing=true
            while let file = files?.nextObject() as? String {
                if file.hasSuffix(".xml"){
                    roster_test.reset()
                    roster_missing=false
                    refreshParser(NSURL(string: self.RosterFolderURL.stringValue+file)!)
                    
                    
                    self.roster_word_output=RosterWordOutput(data: self.roster_test.dataset, startDate:self.roster_start_date.dateValue, endDate:self.roster_end_date.dateValue, currentMonth:dateFormatter.dateFromString(file.substringWithRange(Range<String.Index>(start:file.endIndex.advancedBy(-11), end:file.endIndex.advancedBy(-4))))!)
                    
                    for pair in self.roster_word_output.num_name_dict {
                        self.num_name_dict[pair.0]=pair.1
                    }
                    
                    //advance(file.endIndex, -11)
                    
                    
                    for i in self.roster_word_output.contents {
                        temp_commands.append(i!)
                    }
                }
            }
            CollectRoster(temp_commands, missing:roster_missing)
            
            current_generate=2
            temp_commands=[]
            patient_list=[]
            files=filemanager.enumeratorAtPath(self.ReplaceSpace(self.OutsideUseFolderURL.stringValue.substringFromIndex(OutsideUseFolderURL.stringValue.startIndex.successor().successor().successor().successor().successor().successor().successor())))
            while let file = files?.nextObject() as? String {
                if file != ".DS_Store"{
                    //print(file)
                    report_test.reset()
                    outside_use_missing=false
                    //print(self.OutsideUseFolderURL.stringValue+file)
                    refreshParser(NSURL(string: self.OutsideUseFolderURL.stringValue+file)!)
                    patient_list+=self.report_test.report.group.provider.patient_list
                    //print(file)
                    // print(self.roster_test.dataset.metadata.item_list[0].otxt())
                }
            }
            
            self.report_test.report.group.provider.patient_list=self.patient_list
            self.outside_use_output=OutsideUseWordOutput(report: self.report_test.report, toDate:self.roster_end_date.dateValue, month_amt:month_amt)
            for i in self.outside_use_output.contents{
                temp_commands.append(i)
            }
            
            files=filemanager.enumeratorAtPath(self.ReplaceSpace(self.RAFolderURL.stringValue.substringFromIndex(RAFolderURL.stringValue.startIndex.successor().successor().successor().successor().successor().successor().successor())))
            self.ra_files=[]
            while let file = files?.nextObject() as? String {
                if file != ".DS_Store"{
                do{
                    ra_missing=false
                    let FileContents=try String(contentsOfFile:self.utility.subStringWithStart(self.RAFolderURL.stringValue.stringByReplacingOccurrencesOfString("%20", withString: " "), start: 8)+file, encoding: NSUTF8StringEncoding).componentsSeparatedByString("\n")
                    
                self.ra_file=RA_FILE()
                self.create_ra_file(FileContents)
                self.ra_files.append(ra_file)
                }
                catch {
                    print(error)
                }
                }
            }
            
            self.ra_word_output=RAWordOutput(data_list: self.ra_files,month_amt:month_amt, roster_start_date:roster_start_date.dateValue, roster_end_date:roster_end_date.dateValue, roster_list:self.num_name_dict)
            
            self.commands+=self.ra_word_output!.commands
            
            CollectOutsideUse(temp_commands, patient_list: self.patient_list, missing:outside_use_missing)
            
            
            
            self.OutputToFile(self.sync_output_file_name.stringValue+".txt")
            
            alert.messageText="Finished"
            alert.informativeText="Output to File Finished"
            alert.alertStyle = NSAlertStyle.WarningAlertStyle
            alert.addButtonWithTitle("OK")
            let _ = alert.runModal()
        }
        
    }
    
    func create_ra_file(FileContents:[String]) {
        for line in FileContents {
            let identifier=self.utility.subStringWithRange(line, start: 1, Len:3)
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
    
    
    func ReplaceSpace (ori:String) -> String {
        return ori.stringByReplacingOccurrencesOfString("%20", withString: " ")
    }
    
    func CollectOutsideUse(data:[String], patient_list:[PATIENT], missing:Bool) {
        //print(data)
        var top_outside_use:String="top_outside_use|"
        var short_top_outside_use:String="short_top_outside_use|"
        var quarter="quarterlyChart|"
        var codeChart="codeChart|"
        var week_amt:[Float]=[0,0,0,0,0,0,0]
        var codes:[(String, Float)]=[]

        if missing {
            top_outside_use+="Sample Patient 1|$256.6|$12.93|☐|Sample Patient 2|$218.60|$22.77|☐|Sample Patient 3|$213.65|$15.47|☐|Sample Patient 4|$130.15|$32.35|☐|Sample Patient 5|$121.95|$27.75|☐|Sample Patient 6|$101.1|$32.43|☐|Sample Patient 7|$96.45|$13.05|☐|Sample Patient 8|$77.20|$33.39|☐|Sample Patient 9|$75.18|$13.99|☐|Sample Patient 10|$67.40|$46.10|☐|Sample Patient 11|$67.40|$32.35|☐|Sample Patient 12|$67.40|$29.14|☐|Sample Patient 13|$67.40|$29.59|☐|Sample Patient 14|$67.40|$66.39|☐|Sample Patient 15|$67.40|$32.35|☐|Sample Patient 16|$62.75|$33.39|☐|Sample Patient 17|$55.40|$33.39|☐|Sample Patient 18|$45.47|$40.67|☐|Sample Patient 19|$43.40|$71.52|☐|Sample Patient 20|$37.99|$71.52|☐|"
            commands.append(top_outside_use)
        } else {
            for i in data {
                //print(i.substringWithRange(Range<String.Index>(start:i.startIndex, end:advance(i.startIndex, 10))))
                if i.substringWithRange(Range<String.Index>(start:i.startIndex, end:i.startIndex.advancedBy(9)))=="codeChart" {
                    var components=i.substringFromIndex(i.startIndex.advancedBy(10)).componentsSeparatedByString("|")
                    components.popLast()
                    for var j=0;j<components.count;j+=2 {
                        var added=false
                        for var code in codes {
                            if components[j]==code.0 {
                                added=true
                                code.1+=Float(components[j+1])!
                            }
                        }
                        if !added {
                            codes.append((components[j], Float(components[j+1])!))
                        }
                    }
                } else if i.substringWithRange(Range<String.Index>(start:i.startIndex, end:i.startIndex.advancedBy(14)))=="quarterlyChart" {
                    var quarter_i:[String]=i.substringFromIndex(i.startIndex.advancedBy(15)).componentsSeparatedByString("|")
                    quarter_i.popLast()
                    for var j=0;j<quarter_i.count;j++ {
                        week_amt[j]+=Float(quarter_i[j])!
                    }
                } else if i.substringWithRange(Range<String.Index>(start:i.startIndex, end:i.startIndex.advancedBy(15)))=="top_outside_use" {
                    top_outside_use+=i.substringFromIndex(i.startIndex.advancedBy(16))
                } else if i.substringWithRange(Range<String.Index>(start:i.startIndex, end:i.startIndex.advancedBy(21)))=="short_top_outside_use" {
                    short_top_outside_use+=i.substringFromIndex(i.startIndex.advancedBy(22))
                }
            }
            
            var sorted_codes:[(String, Float)]=[]
            
            for code in codes {
                var added:Bool=false
                for var i=0;i<sorted_codes.count;i++ {
                    if code.1>sorted_codes[i].1{
                        added=true
                        sorted_codes.insert(code, atIndex: i)
                        break
                    }
                }
                if !added {
                    sorted_codes.append(code)
                }
            }
            if sorted_codes.count>0 {
                for var i=0;i<8;i++ {
                    codeChart+="\(sorted_codes[i].0)|\(sorted_codes[i].1)|"
                }
                commands.append(codeChart)
            }
            
            
            
            
            quarter+="Sunday|\(week_amt[1])|Monday|\(week_amt[2])|Tuesday|\(week_amt[3])|Wednesday|\(week_amt[4])|Thursday|\(week_amt[5])|Friday|\(week_amt[6])|Saturday|\(week_amt[0])|"
            commands.append(top_outside_use)
            commands.append(short_top_outside_use)
            commands.append(quarter)
        }
        
        
        
        
        
    }
    
    
    func CollectRoster(data:[String], missing:Bool) {
        var roster_add:String="roster_add|"
        var roster_remove:String="roster_remove|"
        var roster_summary:String="roster_summary|"
        
        var period_start_amt:String="0"
        var period_end_amt:String="0"
        
        if missing {
            roster_remove+="0000000000|M|1990-01-01|20|Sample Last Name|Sample First Name|1990-01-01|1990-01-01|$100.00|0000000001|M|1990-01-01|20|Sample Last Name|Sample First Name|1990-01-01|1990-01-01|$100.00|0000000002|M|1990-01-01|20|Sample Last Name|Sample First Name|1990-01-01|1990-01-01|$100.00|0000000003|M|1990-01-01|20|Sample Last Name|Sample First Name|1990-01-01|1990-01-01|$100.00|0000000004|M|1990-01-01|20|Sample Last Name|Sample First Name|1990-01-01|1990-01-01|$100.00|"
            roster_add+="0000000000|M|1990-01-01|20|Sample Last Name|Sample First Name|1990-01-01|$100.00|0000000001|M|1990-01-01|20|Sample Last Name|Sample First Name|1990-01-01|$100.00|0000000002|M|1990-01-01|20|Sample Last Name|Sample First Name|1990-01-01|$100.00|0000000003|M|1990-01-01|20|Sample Last Name|Sample First Name|1990-01-01|$100.00|0000000004|M|1990-01-01|20|Sample Last Name|Sample First Name|1990-01-01|$100.00|"
            roster_summary+="No Data Available|No Data Available|"
            commands.append(roster_add)
            commands.append(roster_remove)
            commands.append(roster_summary)
        } else {
            for i in data {
                //print(i.substringWithRange(Range<String.Index>(start:i.startIndex, end:advance(i.startIndex, 10))))
                if i.substringWithRange(Range<String.Index>(start:i.startIndex, end:i.startIndex.advancedBy(10)))=="roster_add" {
                    roster_add+=i.substringFromIndex(i.startIndex.advancedBy(11))
                }
        
                else if i.substringWithRange(Range<String.Index>(start:i.startIndex, end:i.startIndex.advancedBy(13)))=="roster_remove" {
                    roster_remove+=i.substringFromIndex(i.startIndex.advancedBy(14))
                }
                else if i.substringWithRange(Range<String.Index>(start:i.startIndex, end:i.startIndex.advancedBy(14)))=="roster_summary" {
                    let summary_content:String=i.substringFromIndex(i.startIndex.advancedBy(15))
                    var summary_seperate=summary_content.componentsSeparatedByString("|")
                    summary_seperate.popLast()
                    
                    
                    for var j=0;j<summary_seperate.count;j+=2 {
                        var amt_seperate:[String]=summary_seperate[j+1].componentsSeparatedByString(" - ")
                        if amt_seperate[0] != "0" {
                            if summary_seperate[j]=="Last Month Total Patients" {
                                if collectRosterAST_equalStart(amt_seperate[1]) {
                                    period_start_amt=amt_seperate[0]
                                }
                            } else if summary_seperate[j]=="This Month Total Patients" {
                                if collectRosterAST_equalEnd(amt_seperate[1]) {
                                    period_end_amt=amt_seperate[0]
                                }
                            }
                        }
                    }
                    
                    //roster_summary+=i.substringFromIndex(i.startIndex.advancedBy(15))
                }
                //advance(i.startIndex, 11)
            }
            
            roster_summary+="Period Start|\(period_start_amt)|Period End|\(period_end_amt)|"
            
            roster_add="roster_add|"+CollectRosterAST_delete_dup(roster_add.substringFromIndex(roster_add.startIndex.advancedBy(11)), array_len: 8, first_name_index: 6, last_name_index: 5)
            roster_remove="roster_remove|"+CollectRosterAST_delete_dup(roster_remove.substringFromIndex(roster_remove.startIndex.advancedBy(14)), array_len: 9, first_name_index: 6, last_name_index: 5)
            commands.append(roster_add)
            commands.append(roster_remove)
            commands.append(roster_summary)
        }
        
    }
    
    func CollectRosterAST_delete_dup(add_str:String,array_len:Int, first_name_index:Int, last_name_index:Int)->String {
        
        var array=add_str.componentsSeparatedByString("|")
        var table_array:[[String]]=[]
        var returnValue:String=""
        
        array.popLast()
        
        
        for var i=0;i+array_len<=array.count;i+=array_len {
            var temp_array:[String]=[]
            for var j=0;j<array_len;j++ {
                temp_array.append(array[i+j])
            }
            table_array.append(temp_array)
        }
        outer: for var i=0;i<table_array.count-1;i++ {
            for var j=i+1;j<table_array.count;j++ {
                if table_array[i][first_name_index]+table_array[i][last_name_index]==table_array[j][first_name_index]+table_array[j][last_name_index] {
                    table_array.removeAtIndex(i)
                    i-=1
                    continue outer
                }
            }
        }
        
        for row in table_array {
            for element in row {
                returnValue+=element+"|"
            }
        }
        return returnValue
        
    }
    
    func collectRosterAST_equalStart(date:String) -> Bool {
        let dateFormatter=NSDateFormatter()
        dateFormatter.dateFormat="MMM, yyyy"
        return NSCalendar.currentCalendar().compareDate(dateFormatter.dateFromString(date)!, toDate: self.roster_start_date.dateValue, toUnitGranularity: .Month) == .OrderedSame
    }
    
    func collectRosterAST_equalEnd(date:String) -> Bool {
        let dateFormatter=NSDateFormatter()
        dateFormatter.dateFormat="MMM, yyyy"
        return NSCalendar.currentCalendar().compareDate(dateFormatter.dateFromString(date)!, toDate: self.roster_end_date.dateValue, toUnitGranularity: .Month) == .OrderedSame
    }
    
    func OutputToFile(FilePath:String) {
        
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as [String] {
            let dir = dirs[0] //documents directory
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("/Doctorcare_Data_Sync_Outputs/sync_files/"+FilePath);
            var text = ""
            for i in 0..<self.commands.count {
                text+=self.commands[i]+"\n"
            }
            do{
                try text.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch{
                
            }
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if self.current_generate == 1 {
            
            let data = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            //print(data)
            if roster_test.elementName=="value" {
                roster_test.value=VALUE(value: data)
            }
        }
        else if self.current_generate==2{
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
        
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        //print(elementName)
        if self.current_generate == 1 {
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
                //print("ttttt")
                roster_test.dataset=DATASET(metadata: roster_test.metadata, data: roster_test.data)
            }
        }
        else if self.current_generate==2 {
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
        
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        roster_test.elementName=elementName
        //print(elementName)
        
        
        
        if self.current_generate == 1 {
            if elementName=="item" {
                roster_test.item=ITEM(name:String(stringInterpolationSegment: attributeDict["name"]))
                roster_test.item_list.append(roster_test.item)
            }
            else if elementName=="value" {
                roster_test.value=VALUE()
                roster_test.value.value=nil
            }
        }
        else if self.current_generate==2 {
            report_test.elementName=elementName
        }
    }
    
    func refreshParser(URL:NSURL){
        let url:NSURL = URL
        xmlParser = NSXMLParser(contentsOfURL: url)
        xmlParser.delegate = self
        xmlParser.parse()
        //print(roster_test.data.row_list[0].value_list[0].value)
        
    }
    
    
    
}
