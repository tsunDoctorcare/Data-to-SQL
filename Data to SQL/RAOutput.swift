//
//  RAOutput.swift
//  Data to SQL
//
//  Created by Tao Sun on 1/14/28 H.
//  Copyright © 28 Heisei Yikkuro's Workshop. All rights reserved.
//

import Foundation

class RAOutout {
    var commands:[String]=[]
    init (ra_file:RA_FILE, file_name:String) {
        
        commands.append("use TestDB;")
        
        commands.append("drop procedure IF EXISTS mainFunc;")
        commands.append("DELIMITER //")
        commands.append("CREATE PROCEDURE mainFunc()")
        commands.append("BEGIN")
        commands.append("IF(not exists (select * from unique_tables where unique_value='RA_\(file_name)')) THEN")
        
        commands.append("insert into unique_tables values('RA_\(file_name)');")
        
        commands.append("insert into RA_file_header values('\(ra_file.file_header!.group_number)', '\(ra_file.file_header!.healthcare_number)', '\(ra_file.file_header!.specialty)', '\(ra_file.file_header!.MOH_office_code)', '\(ra_file.file_header!.RA_data_sequence)', '\(ra_file.file_header!.payment_date)', '\(ra_file.file_header!.payee_name)', '\(ra_file.file_header!.total_amount_payable)', '\(ra_file.file_header!.total_amount_sign)', '\(ra_file.file_header!.cheque_number)', '\(file_name)');")
        commands.append("insert into RA_address_one values('\(ra_file.address_one!.billing_agent_name)', '\(ra_file.address_one!.address_line_one)', '\(file_name)');")
        commands.append("insert into RA_address_two values('\(ra_file.address_two!.address_line_2)', '\(ra_file.address_two!.address_line_3)', '\(file_name)');")
        for claim in ra_file.claims {
            commands.append("insert into RA_claim_header values('\(claim.claim_header.claim_number)', '\(claim.claim_header.transaction_type)', '\(claim.claim_header.healthcare_number)', '\(claim.claim_header.specialty)', '\(claim.claim_header.accounting_number)', '\(claim.claim_header.patient_last_name)', '\(claim.claim_header.patient_first_name)', '\(claim.claim_header.province_code)', '\(claim.claim_header.health_registration_number)', '\(claim.claim_header.version_code)', '\(claim.claim_header.payment_program)', '\(claim.claim_header.service_location_indicator)', '\(claim.claim_header.MOH_group_identifier)', '\(file_name)');")
            for claim_item in claim.claim_items {
                    commands.append("insert into RA_claim_item values('\(claim_item.claim_number)', '\(claim_item.transaction_type)','\(toDate(claim_item.service_date))',\(claim_item.number_of_service),'\(claim_item.service_code)','\(claim_item.amount_submitted)','\(claim_item.amount_paid)','\(claim_item.amount_paid_sign)','\(claim_item.explanatory_code)');")
            }
        }
        if ra_file.balance_forward != nil {
            commands.append("insert into RA_balance_forward values('\(ra_file.balance_forward!.amount_brought_forward_claims_adjustment)', '\(ra_file.balance_forward!.amount_brought_forward_claims_adjustment_sign)', '\(ra_file.balance_forward!.amount_brought_forward_advances)', '\(ra_file.balance_forward!.amount_brought_forward_advances_sign)', '\(ra_file.balance_forward!.amount_brought_forward_reductions)', '\(ra_file.balance_forward!.amount_brought_forward_reductions_sign)', '\(ra_file.balance_forward!.amount_brought_forward_other_deductions)', '\(ra_file.balance_forward!.amount_brought_forward_other_deductions_sign)', '\(file_name)');")
        }
        
        for trans in ra_file.accounting_transactions {
            commands.append("insert into RA_accounting_transaction values('\(trans.transaction_code)', '\(trans.cheque_indicator)', '\(toDate(trans.transaction_date))', '\(trans.transaction_amount)', '\(trans.transaction_amount_sign)', '\(trans.transaction_message)', '\(file_name)');")
        }
        
        commands.append("END IF;")
        commands.append("END //")
        commands.append("DELIMITER ;")
        commands.append("call mainFunc();");    }
    
    func OutputToFile(FilePath:String) {
        if let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as [String] {
            let dir = dirs[0] //documents directory
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("/Doctorcare_Data_Sync_Outputs/Scripts/"+FilePath);
            
            //let path=NSURL(string: dir)!.URLByAppendingPathComponent(FilePath)
            var text = ""
            for i in 0..<self.commands.count {
                text+=self.commands[i]+"\n"
            }
            do{
                text=text.stringByReplacingOccurrencesOfString("''", withString: "null", options: NSStringCompareOptions.LiteralSearch, range: nil)
                try text.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch{
                print("error")
            }
        }
    }
    
    func toDate(var stringValue:String)->String {
        //stringValue.startIndex.advancedBy(4)
        stringValue.insert("-", atIndex:stringValue.startIndex.advancedBy(4))
        stringValue.insert("-", atIndex:stringValue.startIndex.advancedBy(7))
        return stringValue
    }
}