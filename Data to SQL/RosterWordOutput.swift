//
//  RosterWordOutput.swift
//  Data to SQL
//
//  Created by Tao Sun on 1/12/28 H.
//  Copyright © 28 Heisei Yikkuro's Workshop. All rights reserved.
//

import Foundation

class RosterWordOutput {
    var contents:[String?]
    var single:String=String()
    var num_name_dict:[String:String]=[String:String]()
    var cap_lib_f:[Int:Float]=[4:166.53, 9:90.67, 14:78.35, 19:136.67, 24:170.95, 29:177.56, 34:178.87, 39:194.10, 44:200.36, 49:217.88, 54:244.03, 59:246.53, 64: 252.55, 69: 304.97, 74: 328.34, 79: 398.34, 84: 429.16, 89: 518.40, 99:640.70]
    var cap_lab_m:[Int:Float]=[4:174.89, 9: 92.82, 14:74.68, 19: 78.40, 24: 77.62, 29: 83.98, 34: 97.96, 39: 120.29, 44: 135.09, 49: 147.84, 54: 171.41, 59: 194.59, 64: 214.80, 69: 276.60, 74: 322.37, 79: 391.36, 84: 420.87, 89: 493.98, 99: 606.58]
    
    func OutputToFile(FilePath:String) {
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as [String] {
            let dir = dirs[0] //documents directory
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(FilePath);
            var text = ""
            for i in 0..<self.contents.count {
                text+=self.contents[i]!+"\n"
            }
            do{
                try text.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch{
            
            }
            
        }
    }
    
    func calc_cap(age:Int, gender:String)->Float {
        var track_val=Int((age-4)/5)*5+4
        if track_val>99 {
            track_val=99
        } else if track_val<4 {
            track_val=4
        } else if track_val==94 {
            track_val=89
        }
        
        return (gender=="M" ? self.cap_lab_m[track_val] : self.cap_lib_f[track_val])!
    }
    
    init() {
        contents=[]
    }
    init(data:DATASET, startDate:NSDate, endDate:NSDate, currentMonth:NSDate) {
        contents=[]
        single="roster_summary|"
        let dateFormatter=NSDateFormatter()
        let calendar = NSCalendar.currentCalendar()
        dateFormatter.dateFormat="MMM, yyyy"
        let current_row_list:[ROW] = data.data.row_list
        for i in 0..<current_row_list.count {
            if current_row_list[i].value_list[0].value=="PREVIOUS MONTH - TOTAL PATIENTS" {
                single+="Last Month Total Patients|"+current_row_list[i].value_list[1].otxt()+" - "+dateFormatter.stringFromDate(calendar.dateByAddingUnit(.Month, value: -1, toDate: currentMonth, options: [])!)+"|"
                //single+="Last Month Total Patients|"+current_row_list[i].value_list[1].otxt()+" - "+dateFormatter.stringFromDate(calendar.dateByAddingUnit(.Month, value: -1, toDate: currentMonth, options: [])!)+"|"
            }
            else if current_row_list[i].value_list[0].value=="CURRENT MONTH - TOTAL PATIENTS" {
                single+="This Month Total Patients|"+current_row_list[i].value_list[1].otxt()+" - "+dateFormatter.stringFromDate(calendar.dateByAddingUnit(.Month, value: -1, toDate: currentMonth, options: [])!)+"|"
                //single+="This Month Total Patients|"+current_row_list[i].value_list[1].otxt()+" - "+dateFormatter.stringFromDate(calendar.dateByAddingUnit(.Month, value: -1, toDate: currentMonth, options: [])!)+"|"
            }
        }
        
        contents.append(single)
        
        single="roster_remove|"
        for i in 0..<current_row_list.count {
            if Int(current_row_list[i].value_list[0].otxt()) != nil {
                if current_row_list[i].value_list[7].value != nil {
                    /*var last_name:String=split(current_row_list[i].value_list[4].otxt().characters){", "}[0], first_name=split(current_row_list[i].value_list[4].otxt()){", "}[1]*/
                    let last_name=current_row_list[i].value_list[4].otxt().componentsSeparatedByString(", ")[0], first_name=current_row_list[i].value_list[4].otxt().componentsSeparatedByString(", ")[1]
                    single+=current_row_list[i].value_list[0].otxt()+"|"+current_row_list[i].value_list[1].otxt()+"|"+current_row_list[i].value_list[2].otxt()+"|"+current_row_list[i].value_list[3].otxt()+"|"+last_name+"|"+first_name+"|"+current_row_list[i].value_list[6].otxt()+"|"+current_row_list[i].value_list[7].otxt()+"|\(float_to_dollar(calc_cap(Int(current_row_list[i].value_list[3].otxt())!, gender: current_row_list[i].value_list[1].otxt())))|"
                }
            }
        }
        contents.append(single)
        single="roster_add|"
        var userStartDate:NSDate
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //print(dateFormatter.stringFromDate(startDate))
        //print(dateFormatter.stringFromDate(endDate))
        for i in 0..<current_row_list.count {
            
            if Int(current_row_list[i].value_list[0].otxt()) != nil {
                var first_name=" ", last_name=" "
                    let name_sep=current_row_list[i].value_list[4].otxt().componentsSeparatedByString(", ")
                if name_sep.count==2 {
                    last_name=name_sep[0]
                    first_name=name_sep[1]
                } else {
                    last_name=current_row_list[i].value_list[4].otxt()
                }
                
                self.num_name_dict[current_row_list[i].value_list[0].otxt()]=last_name+", "+first_name
                
            //print(current_row_list[i].value_list[0].otxt())
                userStartDate=NSDate()
                if current_row_list[i].value_list[6].value != nil {
                    if let date=dateFormatter.dateFromString(current_row_list[i].value_list[6].otxt()) {
                        userStartDate=date
                    }
                    
                    //userStartDate=dateFormatter.dateFromString(current_row_list[i].value_list[6].otxt())!
                }
                if userStartDate.isBetween(startDate, date2: endDate) {
                    single+=current_row_list[i].value_list[0].otxt()+"|"+current_row_list[i].value_list[1].otxt()+"|"+current_row_list[i].value_list[2].otxt()+"|"+current_row_list[i].value_list[3].otxt()+"|"+last_name+"|"+first_name+"|"+current_row_list[i].value_list[6].otxt()+"|\(float_to_dollar(calc_cap(Int(current_row_list[i].value_list[3].otxt())!, gender: current_row_list[i].value_list[1].otxt())))|"
                }
            }
        }
        contents.append(single)
        
    }
}

func float_to_dollar(num:Float)->String{
    return num*10-Float(Int(num*10)) == 0.0 ? "$\(num)0" : "$\(num)"
}

extension NSDate {
    func isBetween(date1: NSDate, date2: NSDate) -> Bool {
        return date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
    }
}