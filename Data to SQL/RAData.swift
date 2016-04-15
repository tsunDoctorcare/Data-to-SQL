//
//  RAData.swift
//  Data to SQL
//
//  Created by Tao Sun on 1/14/28 H.
//  Copyright © 28 Heisei Yikkuro's Workshop. All rights reserved.
//

import Foundation

class ADDRESS_RECORD_ONE {
    var billing_agent_name=""
    var address_line_one=""

    var utility:UTILITY=UTILITY()
    
    init(data:String) {
        billing_agent_name=utility.subStringWithRange(data,start:4, Len:30)
        address_line_one=utility.subStringWithRange(data, start:34, Len:25)
    }
}

class ACCOUNTING_TRANSACTION_RECORD {
    var transaction_code=""
    var cheque_indicator=""
    var transaction_date=""
    var transaction_amount=""
    var transaction_amount_sign=""
    var transaction_message=""
    
    var utility:UTILITY=UTILITY()
    
    init(data:String) {
        transaction_code=utility.subStringWithRange(data, start: 4, Len: 2)
        cheque_indicator=utility.subStringWithRange(data, start: 6, Len: 1)
        transaction_date=utility.subStringWithRange(data, start: 7, Len: 8)
        transaction_amount=utility.subStringWithRange(data, start: 15, Len: 8)
        transaction_amount_sign=utility.subStringWithRange(data, start: 23, Len: 1)
        transaction_message=utility.subStringWithRange(data, start: 24, Len: 50)

    }
}

class MESSAGE_FACILITY_RECORD {
    var message_text=""
    
    var utility:UTILITY=UTILITY()
    
    init(data:String) {
        message_text=utility.subStringWithRange(data, start: 4, Len: 70)

    }
}

class BALANCE_FORWARD_RECORD {
    var amount_brought_forward_claims_adjustment=""
    var amount_brought_forward_claims_adjustment_sign=""
    var amount_brought_forward_advances=""
    var amount_brought_forward_advances_sign=""
    var amount_brought_forward_reductions=""
    var amount_brought_forward_reductions_sign=""
    var amount_brought_forward_other_deductions=""
    var amount_brought_forward_other_deductions_sign=""
    
    var utility:UTILITY=UTILITY()
    init(data:String) {
        amount_brought_forward_claims_adjustment=utility.subStringWithRange(data, start: 4, Len: 9)
        amount_brought_forward_claims_adjustment_sign=utility.subStringWithRange(data, start: 13, Len: 1)
        amount_brought_forward_advances=utility.subStringWithRange(data, start: 14, Len: 9)
        amount_brought_forward_advances_sign=utility.subStringWithRange(data, start: 23, Len: 1)
        amount_brought_forward_reductions=utility.subStringWithRange(data, start: 24, Len: 9)
        amount_brought_forward_reductions_sign=utility.subStringWithRange(data, start: 33, Len: 1)
        amount_brought_forward_other_deductions=utility.subStringWithRange(data, start: 34, Len: 9)
        amount_brought_forward_other_deductions_sign=utility.subStringWithRange(data, start: 43, Len: 1)

    }
}

class CLAIM_ITEM_RECORD {
    var claim_number=""
    var transaction_type=""
    var service_date=""
    var number_of_service=""
    var service_code=""
    var amount_submitted=""
    var amount_paid=""
    var amount_paid_sign=""
    var explanatory_code=""
    
    var utility:UTILITY=UTILITY()
    
    init(data:String) {
        
        claim_number=utility.subStringWithRange(data, start: 4, Len: 11)
        transaction_type=utility.subStringWithRange(data, start: 15, Len: 1)
        service_date=utility.subStringWithRange(data, start: 16, Len: 8)
        number_of_service=utility.subStringWithRange(data, start: 24, Len: 2)
        service_code=utility.subStringWithRange(data, start: 26, Len: 5)
        amount_submitted=utility.subStringWithRange(data, start: 32, Len: 6)
        amount_paid=utility.subStringWithRange(data, start: 38, Len: 6)
        amount_paid_sign=utility.subStringWithRange(data, start: 44, Len: 1)
        explanatory_code=utility.subStringWithRange(data, start: 45, Len: 2)
    }
}

class CLAIM_HEADER_RECORD {
    var claim_number=""
    var transaction_type=""
    var healthcare_number=""
    var specialty=""
    var accounting_number=""
    var patient_last_name=""
    var patient_first_name=""
    var province_code=""
    var health_registration_number=""
    var version_code=""
    var payment_program=""
    var service_location_indicator=""
    var MOH_group_identifier=""
    
    var utility:UTILITY=UTILITY()

    init(data:String) {
        claim_number=utility.subStringWithRange(data, start: 4, Len: 11)
        transaction_type=utility.subStringWithRange(data, start: 15, Len: 1)
        healthcare_number=utility.subStringWithRange(data, start: 16, Len: 6)
        specialty=utility.subStringWithRange(data, start: 22, Len: 2)
        accounting_number=utility.subStringWithRange(data, start: 24, Len: 8)
        patient_last_name=utility.subStringWithRange(data, start: 32, Len: 14)
        patient_first_name=utility.subStringWithRange(data, start: 46, Len: 5)
        province_code=utility.subStringWithRange(data, start: 51, Len: 2)
        health_registration_number=utility.subStringWithRange(data, start: 53, Len: 12)
        version_code=utility.subStringWithRange(data, start: 65, Len: 2)
        payment_program=utility.subStringWithRange(data, start: 67, Len: 3)
        service_location_indicator=utility.subStringWithRange(data, start: 70, Len: 4)
        MOH_group_identifier=utility.subStringWithRange(data, start: 74, Len: 4)
    }
}

class ADDRESS_RECORD_TWO {
    var address_line_2=""
    var address_line_3=""
    
    var utility:UTILITY=UTILITY()
    
    init(data:String) {
        address_line_2=utility.subStringWithRange(data, start:4, Len:25)
        address_line_3=utility.subStringWithRange(data, start:29, Len:25)
    }
}

class FILE_HEADER_RECORD {
    var group_number=""
    var healthcare_number=""
    var specialty=""
    var MOH_office_code=""
    var RA_data_sequence=""
    var payment_date=""
    var payee_name=""
    var total_amount_payable=""
    var total_amount_sign=""
    var cheque_number=""
    var utility:UTILITY=UTILITY()
    init() {
    
    }
    init(data:String) {
        group_number=utility.subStringWithRange(data, start: 8, Len: 4)
        healthcare_number=utility.subStringWithRange(data, start: 12, Len: 6)
        specialty=utility.subStringWithRange(data, start: 18, Len: 2)
        MOH_office_code=utility.subStringWithRange(data, start: 20, Len: 1)
        RA_data_sequence=utility.subStringWithRange(data, start: 21, Len: 1)
        payment_date=utility.subStringWithRange(data, start: 22, Len: 8)
        payee_name=utility.subStringWithRange(data, start: 30, Len: 30)
        total_amount_payable=utility.subStringWithRange(data, start: 60, Len: 9)
        total_amount_sign=utility.subStringWithRange(data, start: 69, Len: 1)
        cheque_number=utility.subStringWithRange(data, start: 70, Len: 8)
    }
}

class RA_FILE {
    var file_header:FILE_HEADER_RECORD?
    var address_one:ADDRESS_RECORD_ONE?
    var address_two:ADDRESS_RECORD_TWO?
    var claims:[CLAIM]
    var balance_forward:BALANCE_FORWARD_RECORD?
    var accounting_transactions:[ACCOUNTING_TRANSACTION_RECORD]
    var messages:[MESSAGE_FACILITY_RECORD]
    
    init() {
        file_header=nil
        address_one=nil
        address_two=nil
        claims=[]
        balance_forward=nil
        accounting_transactions=[]
        messages=[]
    }
}

class CLAIM {
    var claim_header:CLAIM_HEADER_RECORD
    var claim_items:[CLAIM_ITEM_RECORD]
    
    init(claim_header:CLAIM_HEADER_RECORD, claim_items:[CLAIM_ITEM_RECORD]) {
        self.claim_header=claim_header
        self.claim_items=[]
        self.claim_items+=claim_items
    }
}

class UTILITY {
    func subStringWithRange(oriString:String, start:Int, Len:Int)->String {
        if oriString==""{
            return ""
        }
        
        //print(oriString)
        
        //return oriString[oriString.startIndex.advancedBy(start-1)..<oriString.startIndex.advancedBy(-1).advancedBy(Len)]
        
        return oriString.substringWithRange(Range<String.Index>(start:oriString.startIndex.advancedBy(start-1), end: oriString.startIndex.advancedBy(start-1+Len)))
        
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
}