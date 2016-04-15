//
//  RosterOutput.swift
//  Data to SQL
//
//  Created by Tao Sun on 1/8/28 H.
//  Copyright © 28 Heisei Yikkuro's Workshop. All rights reserved.
//

import Foundation

class RosterOutput {
    var commands:[String?]=[]
    var dataset:DATASET
    var null="null"
    init(){
        dataset=DATASET()
    }
    init(dataset:DATASET){
        self.dataset=dataset
        commands=[]
        commands.append("use TestDB;")
        
        commands.append("drop procedure IF EXISTS mainFunc;")
        commands.append("DELIMITER //")
        commands.append("CREATE PROCEDURE mainFunc()")
        commands.append("BEGIN")
        commands.append("IF(not exists (select * from unique_tables where unique_value='roster_\(self.dataset.filename)')) THEN")
        
        commands.append("insert into unique_tables values('roster_\(self.dataset.filename)');")
        
        
        for i in self.dataset.data.row_list {
            var temp_command:String
            if i.value_list[0].value=="PREVIOUS MONTH - TOTAL PATIENTS" || i.value_list[0].value=="CURRENT MONTH - TOTAL PATIENTS" || i.value_list[0].value=="ROSTER TYPE" || i.value_list[0].value=="ENROLLED PATIENTS"{
                temp_command="insert into roster_summary values('\(self.dataset.filename)','\(i.value_list[0].otxt())',\(self.remove_comma(i.value_list[1].otxt().isEmpty ? self.null : i.value_list[1].otxt())));"
            }
            else if i.value_list[9].value=="CURRENT" && i.value_list[10].value=="MONTH" &&
                i.value_list[11].value=="TO" && i.value_list[12].value=="TAL" {
                    temp_command="insert into roster_current_month_to_tal values('\(self.dataset.filename)',\(self.remove_comma(i.value_list[13].otxt())),\(self.remove_comma(i.value_list[14].otxt())),\(self.remove_comma(i.value_list[15].otxt())));"
            }
            else if let _=Int(i.value_list[0].otxt()) {
                temp_command="insert into roster_patient values("
                temp_command+="'\(self.dataset.filename)',"
                for j in 0..<i.value_list.count {
                    if [3,11,13,14,15].contains(j) {
                        let input_temp=i.value_list[j].otxt()=="" ? "0.0" : i.value_list[j].otxt()
                        temp_command+="\(input_temp),"
                    }
                    else{
                        temp_command+="'\(i.value_list[j].otxt())',"
                    }
                }
                temp_command.removeAtIndex(temp_command.endIndex.predecessor())
                temp_command+=");"
            }
            else if !(i.value_list[0].value=="ROSTER SUMMARY" || i.value_list[0].value=="STATUS CODE" || (i.value_list[2].value==nil && i.value_list[3].value==nil)) {
                temp_command="insert into roster_change values('\(self.dataset.filename)','\(i.value_list[0].otxt())', '\(i.value_list[1].otxt())', '\(i.value_list[2].otxt())', '\(i.value_list[3].otxt())');"
            }
            else {
                temp_command=""
            }
            
            self.commands.append(temp_command)
        }
        
        commands.append("END IF;")
        commands.append("END //")
        commands.append("DELIMITER ;")
        commands.append("call mainFunc();");
        
    }
    func remove_comma(num:String)->String{
        return num.stringByReplacingOccurrencesOfString(",", withString: "")
    }
    
    func OutputToFile(FilePath:String) {
        
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as [String] {
            let dir = dirs[0] //documents directory
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("/Doctorcare_Data_Sync_Outputs/Scripts/"+FilePath);
            var text = ""
            for i in 0..<self.commands.count {
                text+=self.commands[i]!+"\n"
            }
            do{
                text=text.stringByReplacingOccurrencesOfString("''", withString: "null", options: NSStringCompareOptions.LiteralSearch, range: nil)
                try text.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)

            }
            catch{
                
            }
            
            
        }
    }
}

extension String {
    func customNull()->String {
        if self=="''" {
            return "null"
        } else {
            return self
        }
    }
}