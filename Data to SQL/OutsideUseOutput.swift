//
//  OutsideOutput.swift
//  Data to SQL
//
//  Created by Tao Sun on 1/7/28 H.
//  Copyright © 28 Heisei Yikkuro's Workshop. All rights reserved.
//

import Foundation

class OutsideUseOutput {
    var commands:[String?]
    var data:REPORT
    init() {
        commands=[]
        data=REPORT()
    }
    init(data:REPORT, file_name:String) {
        self.data=data.copy()
        commands=[]
        
        commands.append("use TestDB;")
        
        commands.append("drop procedure IF EXISTS mainFunc;")
        commands.append("DELIMITER //")
        commands.append("CREATE PROCEDURE mainFunc()")
        commands.append("BEGIN")
        commands.append("IF(not exists (select * from unique_tables where unique_value='outside_use_\(file_name)')) THEN")
        
        commands.append("insert into unique_tables values('outside_use_\(file_name)');")
        
        
        commands.append("insert into outside_use_report values('\(file_name)', '\(self.data.report_dtl.report_id.otxt())', '\(self.data.report_dtl.report_date.otxt())', '\(self.data.report_dtl.report_name.otxt())', '\(self.data.report_dtl.report_period_start.otxt())', '\(self.data.report_dtl.report_period_end.otxt())');")
        
        commands.append("insert into outside_use_group values(CONCAT('\(file_name)','G'),'\(file_name)','\(self.data.group.group_dtl.group_id.otxt())','\(self.data.group.group_dtl.group_type.otxt())','\(self.data.group.group_dtl.group_name.otxt())');")
        
        commands.append("insert into outside_use_provider values(CONCAT('\(file_name)','GPR'),CONCAT('\(file_name)','G'),'\(self.data.group.provider.provider_dtl.provider_number.otxt())','\(self.data.group.provider.provider_dtl.provider_last_name.otxt())','\(self.data.group.provider.provider_dtl.provider_first_name.otxt())','\(self.data.group.provider.provider_dtl.provider_middle_name.otxt())');")
        
        for i in 0..<self.data.group.provider.patient_list.count {  
            commands.append("insert into outside_use_patient values(CONCAT('\(file_name)','GPR'),CONCAT('\(file_name)','GPRPA','\(i)'),'\(self.data.group.provider.patient_list[i].patient_dtl.patient_health_number.otxt())','\(self.data.group.provider.patient_list[i].patient_dtl.patient_last_name.otxt())','\(self.data.group.provider.patient_list[i].patient_dtl.patient_first_name.otxt())','\(self.data.group.provider.patient_list[i].patient_dtl.patient_birthdate.otxt())','\(self.data.group.provider.patient_list[i].patient_dtl.patient_sex.otxt())');")
            
            for j in 0..<self.data.group.provider.patient_list[i].service_dtl1_list.count {
                commands.append("insert into outside_use_service_dtl1 values(CONCAT('\(file_name)','GPRPA','\(i)','S','\(j)'),CONCAT('\(file_name)','GPRPA','\(i)'),'\(self.data.group.provider.patient_list[i].service_dtl1_list[j].service_date.otxt())','\(self.data.group.provider.patient_list[i].service_dtl1_list[j].service_code.otxt())','\(self.data.group.provider.patient_list[i].service_dtl1_list[j].service_description.otxt())',\(self.data.group.provider.patient_list[i].service_dtl1_list[j].service_amt.otxt()));")
            }
        }
        
        commands.append("END IF;")
        commands.append("END //")
        commands.append("DELIMITER ;")
        commands.append("call mainFunc();");
    }
    
    func OutputToFile(FilePath:String) {
        
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as [String] {
            let dir = dirs[0] //documents directory
            //dir.stringByAppendingPathComponent(FilePath)
            let path=NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("/Doctorcare_Data_Sync_Outputs/Scripts/"+FilePath);
            //let path = NSURL(fileURLWithPath: dir).stringByAppendingPathComponent(FilePath);
            var text = ""
            for i in 0..<self.commands.count {
                text+=self.commands[i]!+"\n"
            }
            do{
                text=text.stringByReplacingOccurrencesOfString("''", withString: "null", options: NSStringCompareOptions.LiteralSearch, range: nil)
                try text.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
                //try text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch{
            
            }
            
        }
    }
}