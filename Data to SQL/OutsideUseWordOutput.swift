//
//  OutsideUseWordOutput.swift
//  Data to SQL
//
//  Created by Tao Sun on 1/12/28 H.
//  Copyright © 28 Heisei Yikkuro's Workshop. All rights reserved.
//

import Foundation

class OutsideUseWordOutput {
    var contents:[String]
    var single:String=String()
    var patients:[OUTSIDEUSE_PATIENT_CALC]=[]
    var codes:[OUTSIDE_CODE]=[]
    var toDate:NSDate=NSDate()
    var cap_lib_f:[Int:Float]=[4:166.53, 9:90.67, 14:78.35, 19:136.67, 24:170.95, 29:177.56, 34:178.87, 39:194.10, 44:200.36, 49:217.88, 54:244.03, 59:246.53, 64: 252.55, 69: 304.97, 74: 328.34, 79: 398.34, 84: 429.16, 89: 518.40, 99:640.70]
    var cap_lab_m:[Int:Float]=[4:174.89, 9: 92.82, 14:74.68, 19: 78.40, 24: 77.62, 29: 83.98, 34: 97.96, 39: 120.29, 44: 135.09, 49: 147.84, 54: 171.41, 59: 194.59, 64: 214.80, 69: 276.60, 74: 322.37, 79: 391.36, 84: 420.87, 89: 493.98, 99: 606.58]
    
    func calc_cap(age:Int, gender:String, month_amt:Int)->Float {
        var track_val=Int((age-4)/5)*5+4
        if track_val>99 {
            track_val=99
        } else if track_val<4 {
            track_val=4
        } else if track_val==94 {
            track_val=89
        }

        
        let ori_float:Float=(gender=="M" ? self.cap_lab_m[track_val] : self.cap_lib_f[track_val])!/12.00 * Float(month_amt)
        
        return ori_float - (ori_float % 0.01)
    }
    init() {
        contents=[]
        patients=[]
    }
    init(report:REPORT, toDate:NSDate,month_amt:Int) {
        //print(report.group.provider.patient_list.count)
        contents=[]
        patients=[]
        self.toDate=toDate
        single="top_outside_use|"
        var single_2="short_top_outside_use|"
        for i in report.group.provider.patient_list {
            //print("test")
            let patient_name = i.patient_dtl.patient_last_name.otxt()+", "+i.patient_dtl.patient_first_name.otxt()
            add_patient(patient_name, patient_dtl: i)
        }
        
        for var i=0;i<patients.count;i++ {
            patients[i].amt=0.0
            for service in patients[i].service_lst {
                patients[i].amt+=service.amt
            }
        }
        
        patients.sortInPlace({$0.amt>$1.amt})
        
        for patient in report.group.provider.patient_list {
            for service in patient.service_dtl1_list {
                add_code(service)
            }
        }
        //print(patients.count)\
        
        let tempDateFormatter=NSDateFormatter()
        tempDateFormatter.dateFormat = "yyyy-MM-dd"
        
        
        for i in 0..<20 {
            if i<patients.count {
                var ttl_amt:Float=0.0
                
                
                for (var t=0;t<patients[i].service_lst.count-1;t++) {
                    for(var j=t+1;j>patients[i].service_lst.count;j++) {
                        if (tempDateFormatter.dateFromString(patients[i].service_lst[t].date)!.compare(tempDateFormatter.dateFromString( patients[i].service_lst[j].date)!)==NSComparisonResult.OrderedDescending) {
                            
                            let temp2=OUTSIDEUSE_SERVICE(date: patients[i].service_lst[t].date, code: patients[i].service_lst[t].code, amt: patients[i].service_lst[t].amt)
                            patients[i].service_lst[t]=OUTSIDEUSE_SERVICE(date: patients[i].service_lst[j].date, code: patients[i].service_lst[j].code, amt: patients[i].service_lst[j].amt)
                            patients[i].service_lst[j]=OUTSIDEUSE_SERVICE(date: temp2.date, code: temp2.code, amt: temp2.amt)
                        }
                    }
                }
                
                //let temp=patients[i]

                
                var first_add=true
                for service in patients[i].service_lst {
                    let name=first_add ? patients[i].name : " "
                    first_add=false
                    ttl_amt+=service.amt
                    let end_zero = service.amt*10-Float(Int(service.amt*10)) == 0.0 ? "0" : ""
                    
                    single+=("\(name)|\(service.date)|\(service.code)|$\(String(service.amt)+end_zero)| | |")
                }
                
                let cap_val=calc_cap(patients[i].age, gender: patients[i].gender, month_amt:month_amt)
                let cap_val_end_zero=cap_val*10-Float(Int(cap_val*10)) == 0.0 ? "0" : ""
                
                ttl_amt=ttl_amt-ttl_amt%0.01
                
                let end_zero = ttl_amt*10-Float(Int(ttl_amt*10)) == 0.0 ? "0" : ""

                
                single+=(patients[i].name+" Total| | |$"+String(ttl_amt)+end_zero+"|$\(String(cap_val)+cap_val_end_zero)|☐|")
                single_2+=patients[i].name+"|$"+String(Float(ttl_amt))+end_zero+"|$\(String(cap_val)+cap_val_end_zero)|"
                
            }
        }
        contents.append(single)
        contents.append(single_2)
        
        single="quarterlyChart|"
        
        var week_amt:[Float]=[0,0,0,0,0,0,0]
        let dateFormatter=NSDateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd"
        
        
        for patient in report.group.provider.patient_list {
            for service in patient.service_dtl1_list {
                if(NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!.components(.Weekday, fromDate: dateFormatter.dateFromString(service.service_date.otxt())!).weekday==7) {
                    //print(patient.patient_dtl.patient_first_name.otxt())
                    //print(service.service_date.otxt())
                }
                var weekday:Int=NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!.components(.Weekday, fromDate: dateFormatter.dateFromString(service.service_date.otxt())!).weekday
                if weekday==7 {
                    weekday=0
                }
                week_amt[weekday]+=Float(service.service_amt.otxt())!
            }
        }
        
        for week_day in week_amt {
            single+="\(week_day)|"
        }
        
        contents.append(single)
        
        single="codeChart|"
        for code in codes {
            //print(code.code)
            single+="\(code.code)|\(code.amt)|"
        }
        if single.characters.count>10 {
            contents.append(single)
        }
        //print(self.contents[0])
        //OutputToFile("TestOutsideUseWord.txt")
    }
    
    func OutputToFile(FilePath:String) {
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as [String] {
            let dir = dirs[0] //documents directory
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(FilePath);
            var text = ""
            for i in 0..<self.contents.count {
                text+=self.contents[i]+"\n"
            }
            do{
                //print(self.contents.count)
                try text.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch{
                
            }
            
        }
    }
    
    func add_code(service:SERVICE_DTL1) {
        var added=false
        for code in self.codes {
            if code.code==service.service_code.otxt() {
                added=true
                code.amt+=Float(service.service_amt.otxt())!
            }
        }
        if !added {
            self.codes.append(OUTSIDE_CODE(code: service.service_code.otxt(), amt: Float(service.service_amt.otxt())!))
            //print(service.service_code.txt)
        }
    }
    
    
    func add_patient(patient_name:String, patient_dtl:PATIENT) {
        var added:Bool=false
        let dateFormatter=NSDateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd"
        for i in self.patients {
            if i.name == patient_name {
                i.service_time+=patient_dtl.service_dtl1_list.count
                for j in patient_dtl.service_dtl1_list {
                    i.amt+=Float(j.service_amt.otxt())!
                    i.service_lst.append(OUTSIDEUSE_SERVICE(date: j.service_date.otxt(), code: j.service_code.otxt(), amt: Float(j.service_amt.otxt())!))
                }
                added=true
            }
        }
            if !added {
                var amt:Float=0.0
                
                let age=NSCalendar.currentCalendar().components(.Year, fromDate: dateFormatter.dateFromString(patient_dtl.patient_dtl.patient_birthdate.otxt())!, toDate:self.toDate, options:NSCalendarOptions()).year
                
                //print(patient_dtl.patient_dtl.patient_birthdate.otxt())
                //print(age)
                
                let temp = OUTSIDEUSE_PATIENT_CALC(name: patient_name, service_time: patient_dtl.service_dtl1_list.count, amt: amt,age:age, gender:patient_dtl.patient_dtl.patient_sex.otxt())
                for i in patient_dtl.service_dtl1_list {
                    amt+=(Float(i.service_amt.otxt())==nil ? 0.0 : Float(i.service_amt.otxt()))!
                    temp.service_lst.append(OUTSIDEUSE_SERVICE(date: i.service_date.otxt(), code: i.service_code.otxt(), amt: Float(i.service_amt.otxt())!))
                }
                patients.append(temp)
            }
        //print(patients.count)
    }
}

class OUTSIDE_CODE {
    var amt:Float
    var code:String
    init(code:String, amt:Float) {
        self.amt=amt
        self.code=code
    }
}

class OUTSIDEUSE_SERVICE {
    var date:String
    var code:String
    var amt:Float
    
    init(date:String, code:String, amt:Float) {
        self.date=date
        self.code=code
        self.amt=amt
    }
}

class OUTSIDEUSE_PATIENT_CALC {
    var name:String
    var service_time:Int
    var age:Int
    var gender:String
    var amt:Float
    var service_lst:[OUTSIDEUSE_SERVICE]=[]
    init(name:String, service_time:Int, amt:Float, age:Int, gender:String) {
        self.age=age
        self.gender=gender
        self.name = name
        self.service_time=service_time
        self.amt = amt
    }
}