//
//  RAWordOutput.swift
//  Data to SQL
//
//  Created by Tao Sun on 1/19/28 H.
//  Copyright © 28 Heisei Yikkuro's Workshop. All rights reserved.
//

import Foundation

class RAWordOutput{
    var commands:[String]=[]
    var revenue_analysis:[(String, Float)]=[]
    var IOP:[(String, Float)]=[]
    var TEAB:Float=0.0
    var TEAB_YTD:Float=0.0
    var EPOU:Float=0.0
    var EPOU_YTD:Float=0.0
    var BP:Float=0.0
    var BP_YTD:Float=0.0
    var utility:UTILITY=UTILITY()
    var block:String=""
    var added:[Bool]=[]

    var hospital:Float=0.0
    var labour_and_delivery:Float=0.0
    var office_procedures:Float=0.0
    var palliative_care:Float=0.0
    var home_visits:Float=0.0
    var prenatal:Float=0.0
    var long_term_care:Float=0.0
    var pc_smi:Float=0.0
    
    var p_hospital:Float=0.0
    var p_labour_and_delivery:Float=0.0
    var p_office_procedures:Float=0.0
    var p_palliative_care:Float=0.0
    var p_home_visits:Float=0.0
    var p_prenatal:Float=0.0
    var p_long_term_care:Float=0.0
    var p_pc_smi:Float=0.0
    
    var pro_hospital:Float=0.0
    var pro_labour_and_delivery:Float=0.0
    var pro_office_procedures:Float=0.0
    var pro_palliative_care:Float=0.0
    var pro_home_visits:String="0/0"
    var pro_prenatal:Float=0.0
    var pro_long_term_care:Float=0.0
    var pro_pc_smi:Float=0.0
    
    var capitation_payment:Float=0.0
    var MOH_claw_backs:Float=0.0
    var ffs_non_enrolled:Float=0.0
    var bonuses:Float=0.0
    
    var current_value:Float=0.0
    var temp_ytd:Float=0.0
    
    var blended_ffs_premium:Float=0.0
    var ttl_cap:Float=0.0
    var access_bonus:Float=0.0
    var preventive:Float=0.0
    
    var blended_ffs_premuim_ary:[Float]=[]
    var ttl_cap_ary:[Float]=[]
    var access_bonus_ary:[Float]=[]
    var preventive_ary:[Float]=[]
    
    var ra_date_str=""
    var ra_date_ary:[NSDate]=[]
    
    var top_users:[String:Float]=[String:Float]()
    
    //var RAs:[(String, Float)]=[]
    //var IOPs:[(String, Float)]=[]
    
    func addZeroToFloat(var num:Float)->String {
        num=num-num%0.01
        return String(num)+(String(num).componentsSeparatedByString(".")[1].characters.count<2 ? "0" : "")
    }
    

    
    func N_to_float(num:String)->Float {
        return Float(Int(utility.subStringWithEnd(num, end: 4))!)+Float("0."+utility.subStringWithStart(num, start: 5))!
    }
    
    init(data_list:[RA_FILE],month_amt:Int,roster_start_date:NSDate,roster_end_date:NSDate, roster_list:[String: String]) {
        for i in data_list {
            block=""
            added=[false, false, false, false, false, false]
            //print(i.messages[0].message_text)
            for j in i.accounting_transactions {
                
                switch remove_end_space(j.transaction_message) {
                case "COMP CARE RECONCILIATION","BASE RATE PAYMENT RECONCILIATION ADJMT","COMP CARE CAPITATION","NETWORK BASE RATE PAYMENT" :
                    capitation_payment+=digit_to_float(j.transaction_amount, sign: j.transaction_amount_sign)
                    break
                case "PAYMENT REDUCTION-OPTED-IN","PAYMENT REDUCTION-PRIMARY CARE","PAYMENT REDUCTION-AUTOMATED PREMIUMS":
                    MOH_claw_backs+=digit_to_float(j.transaction_amount, sign: j.transaction_amount_sign)
                    break
                case "BLENDED FEE-FOR-SERVICE PREMIUM":
                    ffs_non_enrolled+=digit_to_float(j.transaction_amount, sign: j.transaction_amount_sign)
                    break
                default:
                    break
                }
                //revenue_analysis.append((remove_end_space(j.transaction_message), digit_to_float(j.transaction_amount, sign: j.transaction_amount_sign)))
                //print(j.transaction_message)
            }
            
            
            
        
            for j in i.messages {
                
                
                if j.message_text.rangeOfString("NON-LTC ACCESS BONUS:") != nil{
                    //print("block!")
                    block="non-ltc"
                }
                
                if block=="non-ltc"{
                    if j.message_text.rangeOfString("ACCESS BONUS PAYMENT") != nil {
                        bonuses+=view_to_float(utility.subStringWithRange(j.message_text, start: 38, Len: 15))
                    }
                }
                
                if block=="non-ltc" && (!added[0] || !added[1] || !added[2] || !added[3] || !added[4] || !added[5]) {
                    if j.message_text.rangeOfString("MAXIMUM SPECIAL PAYMENT") != nil {
                        TEAB+=view_to_float(utility.subStringWithRange(j.message_text, start: 38, Len: 18))
                        temp_ytd=view_to_float(utility.subStringWithRange(j.message_text, start: 53, Len: 17))
                        TEAB_YTD=temp_ytd > TEAB_YTD ? temp_ytd : TEAB_YTD
                        added[0]=true;
                        added[1]=true;
                    }
                    else if j.message_text.rangeOfString("ENROLLED PATIENTS OUTSIDE USE TOTAL") != nil {
                        EPOU+=view_to_float(utility.subStringWithRange(j.message_text, start: 38, Len: 18))
                        temp_ytd=view_to_float(utility.subStringWithRange(j.message_text, start: 53, Len: 17))
                        EPOU_YTD=temp_ytd > EPOU_YTD ? temp_ytd : EPOU_YTD
                        added[2]=true;
                        added[3]=true;
                    }
                    else if j.message_text.rangeOfString("ACCESS BONUS PAYMENT") != nil {
                        BP+=view_to_float(utility.subStringWithRange(j.message_text, start: 38, Len: 18))
                        temp_ytd=view_to_float(utility.subStringWithRange(j.message_text, start: 53, Len: 17))
                        BP_YTD=temp_ytd > BP_YTD ? temp_ytd : BP_YTD
                        added[4]=true;
                        added[5]=true;
                    }
                }
            }
            
            blended_ffs_premium=0
            ttl_cap=0

            access_bonus=0
            preventive=0
            
            for j in 0..<i.messages.count {
                if i.messages[j].message_text.rangeOfString("CURRENT FISCAL            PREMIUM ACCUMULATIONS       PREMIUM PAYMENT") != nil {
                    block="current fiscal"
                }
                else if i.messages[j].message_text.rangeOfString("PREVIOUS FISCAL           PREMIUM ACCUMULATIONS       PREMIUM PAYMENT ") != nil {
                    block="previous fiscal"
                }
                
                
                if utility.subStringWithEnd(i.messages[j].message_text, end: 35).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())=="BLENDED FEE-FOR-SERVICE PREMIUM" {
                    blended_ffs_premium += view_to_float(utility.subStringWithRange(i.messages[j].message_text, start: 40, Len: 16))
                } else if utility.subStringWithEnd(i.messages[j].message_text, end: 35).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())=="TOTAL BASE RATE" {
                    ttl_cap+=view_to_float(utility.subStringWithRange(i.messages[j].message_text, start: 40, Len: 16))
                } else if i.messages[j].message_text.rangeOfString("TOTAL COMPREHENSIVE CARE") != nil {
                    ttl_cap+=view_to_float(utility.subStringWithRange(i.messages[j].message_text, start: 40, Len: 16))
                } else if i.messages[j].message_text.rangeOfString("LTC ACCESS BONUS:") != nil {
                    access_bonus+=view_to_float(utility.subStringWithRange(i.messages[j+5].message_text, start: 40, Len: 16))
                } else if i.messages[j].message_text.rangeOfString("PREVENTIVE CARE BONUS ACCUMULATIONS AND PAYMENT:") != nil {
                    preventive+=view_to_float(utility.subStringWithRange(i.messages[j+7].message_text, start: 25, Len: 15))
                }
                
                
                if block=="current fiscal" {
                    if i.messages[j].message_text.rangeOfString("HOSPITAL:") != nil {
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+3].message_text, start: 61, Len: 9))
                        hospital = current_value > hospital ? current_value : hospital
                        
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+3].message_text, start: 37, Len: 11))
                        pro_hospital = current_value > pro_hospital ? current_value : pro_hospital
                    }
                    else if i.messages[j].message_text.rangeOfString("LABOUR AND DELIVERY:") != nil {
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+3].message_text, start: 61, Len: 9))
                        labour_and_delivery = current_value > labour_and_delivery ? current_value : labour_and_delivery
                        
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+3].message_text, start: 37, Len: 11))
                        pro_labour_and_delivery = current_value > pro_labour_and_delivery ? current_value : pro_labour_and_delivery
                    }
                    else if i.messages[j].message_text.rangeOfString("OFFICE PROCEDURES:") != nil {
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+3].message_text, start: 61, Len: 9))
                        office_procedures = current_value > office_procedures ? current_value : office_procedures
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+3].message_text, start: 37, Len: 11))
                        pro_office_procedures = current_value > pro_office_procedures ? current_value : pro_office_procedures
                    }
                    else if i.messages[j].message_text.rangeOfString("PALLIATIVE CARE:") != nil {
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+3].message_text, start: 61, Len: 9))
                        palliative_care = current_value > palliative_care ? current_value : palliative_care
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+3].message_text, start: 37, Len: 11))
                        pro_palliative_care = current_value > pro_palliative_care ? current_value : pro_palliative_care
                    }
                    else if i.messages[j].message_text.rangeOfString("HOME VISITS:") != nil {
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+4].message_text, start: 61, Len: 9))
                        
                        if current_value > home_visits {
                            home_visits = current_value
                        }
                        
                        let prev_str_value=utility.subStringWithRange(i.messages[j+4].message_text, start: 37, Len: 11).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).stringByReplacingOccurrencesOfString("/", withString: "")
                        
                        if  Int(prev_str_value)! > Int(pro_home_visits.stringByReplacingOccurrencesOfString("/", withString: ""))! {
                            pro_home_visits=utility.subStringWithRange(i.messages[j+4].message_text, start: 37, Len: 11).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                        }
                    }
                    else if i.messages[j].message_text.rangeOfString("PRENATAL:") != nil {
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+3].message_text, start: 61, Len: 9))
                        prenatal = current_value > prenatal ? current_value : prenatal
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+3].message_text, start: 37, Len: 11))
                        pro_prenatal = current_value > pro_prenatal ? current_value : pro_prenatal
                    }
                    else if i.messages[j].message_text.rangeOfString("LONG TERM CARE:") != nil {
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+3].message_text, start: 61, Len: 9))
                        long_term_care = current_value > long_term_care ? current_value : long_term_care
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+3].message_text, start: 37, Len: 11))
                        pro_long_term_care = current_value > pro_long_term_care ? current_value : pro_long_term_care
                    }
                    else if i.messages[j].message_text.rangeOfString("PC-SMI:") != nil {
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+3].message_text, start: 61, Len: 9))
                        pc_smi = current_value > pc_smi ? current_value : pc_smi
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+3].message_text, start: 37, Len: 11))
                        pro_pc_smi = current_value > pro_pc_smi ? current_value : pro_pc_smi
                    }
                    else if i.messages[j].message_text.rangeOfString("CURRENT FISCAL TOTAL") != nil {
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+3].message_text, start: 49, Len: 10))
                        bonuses+=current_value
                        
                    }
                } else if block=="previous fiscal" {
                    if i.messages[j].message_text.rangeOfString("HOSPITAL:") != nil {
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+3].message_text, start: 61, Len: 9))
                        p_hospital = current_value > p_hospital ? current_value : p_hospital
                    }
                    else if i.messages[j].message_text.rangeOfString("LABOUR AND DELIVERY:") != nil {
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+3].message_text, start: 61, Len: 9))
                        p_labour_and_delivery = current_value > p_labour_and_delivery ? current_value : p_labour_and_delivery
                    }
                    else if i.messages[j].message_text.rangeOfString("OFFICE PROCEDURES:") != nil {
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+3].message_text, start: 61, Len: 9))
                        p_office_procedures = current_value > p_office_procedures ? current_value : p_office_procedures
                    }
                    else if i.messages[j].message_text.rangeOfString("PALLIATIVE CARE:") != nil {
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+3].message_text, start: 61, Len: 9))
                        p_palliative_care = current_value > p_palliative_care ? current_value : p_palliative_care
                    }
                    else if i.messages[j].message_text.rangeOfString("HOME VISITS:") != nil {
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+4].message_text, start: 61, Len: 9))
                        p_home_visits = current_value > p_home_visits ? current_value : p_home_visits
                    }
                    else if i.messages[j].message_text.rangeOfString("PRENATAL:") != nil {
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+3].message_text, start: 61, Len: 9))
                        p_prenatal = current_value > p_prenatal ? current_value : p_prenatal
                    }
                    else if i.messages[j].message_text.rangeOfString("LONG TERM CARE:") != nil {
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+3].message_text, start: 61, Len: 9))
                        p_long_term_care = current_value > p_long_term_care ? current_value : p_long_term_care
                    }
                    else if i.messages[j].message_text.rangeOfString("PC-SMI:") != nil {
                        current_value=view_to_float(utility.subStringWithRange(i.messages[j+3].message_text, start: 61, Len: 9))
                        p_pc_smi = current_value > p_pc_smi ? current_value : p_pc_smi
                    }
                }
            }
            let payment_date_formatter=NSDateFormatter()
            payment_date_formatter.dateFormat="yyyyMMdd"
            
            
            let components = NSDateComponents()
            components.setValue(-1, forComponent: NSCalendarUnit.Month);
            let expirationDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: payment_date_formatter.dateFromString(i.file_header!.payment_date)!, options: NSCalendarOptions())
            
            ra_date_ary.append(expirationDate!)
            
            
            blended_ffs_premuim_ary.append(blended_ffs_premium)
            ttl_cap_ary.append(ttl_cap)
            access_bonus_ary.append(access_bonus)
            preventive_ary.append(preventive)
            
            
        }
        
        if data_list.count==0 {
            commands.append("outside_summary| |No Data Available|No Data Available|")
        } else {
        commands.append("outside_summary|"+"Total Eligible Access Bonus|"+"$\(format_float_string(String(TEAB)))|"+"$\(format_float_string(String(TEAB_YTD)))|"+"Enrolled Patients Outside Use|"+"$\(format_float_string(String(EPOU)))|"+"$\(format_float_string(String(EPOU_YTD)))|"+"Bonus Payment|"+"$\(format_float_string(String(BP)))|"+"$\(format_float_string(String(TEAB_YTD-EPOU_YTD)))|")
        }
        
        
        var single:String="revenue_analysis|"
        
        
        let payment_date_formatter=NSDateFormatter()
        payment_date_formatter.dateFormat="MMM yyyy"
        
        for var i=0;i<ra_date_ary.count-1;i++ {
            for var j=i+1;j<ra_date_ary.count;j++ {
                if ra_date_ary[i].compare(ra_date_ary[j])==NSComparisonResult.OrderedDescending {
                    let ra_date_temp=ra_date_ary[i]
                    ra_date_ary[i]=ra_date_ary[j]
                    ra_date_ary[j]=ra_date_temp
                    
                    let cap_temp=ttl_cap_ary[i]
                    ttl_cap_ary[i]=ttl_cap_ary[j]
                    ttl_cap_ary[j]=cap_temp
                    
                    let ffs_temp=blended_ffs_premuim_ary[i]
                    blended_ffs_premuim_ary[i]=blended_ffs_premuim_ary[j]
                    blended_ffs_premuim_ary[j]=ffs_temp
                    
                    let bonus_temp=access_bonus_ary[i]
                    access_bonus_ary[i]=access_bonus_ary[j]
                    access_bonus_ary[j]=bonus_temp
                }
            }
        }
        
        for ra_date in ra_date_ary{
            ra_date_str+=payment_date_formatter.stringFromDate(ra_date)
        }
        
        
        single+=ra_date_str+"|"
        var single_cap_pay_str="Capitation Payments|30000|"
        var single_ffs_str="Fee For Service|1014|"
        var single_bonuses_str="Bonuses|2500|"
        
        for var i=0;i<ttl_cap_ary.count;i++ {
            single_cap_pay_str+="\(ttl_cap_ary[i])|"
            single_ffs_str+="\(blended_ffs_premuim_ary[i])|"
            single_bonuses_str+="\(access_bonus_ary[i])|"
        }
        
        single+=single_cap_pay_str
        single+=single_ffs_str
        single+=single_bonuses_str
        
        if data_list.count != 0 {
            commands.append(single)
            commands.append("IOP|Hospital|5000|\(hospital)|\(p_hospital)|Labour & Delivery|8000|\(labour_and_delivery)|\(p_labour_and_delivery)|Office Procedures|2000|\(office_procedures)|\(p_office_procedures)|Palliative Care|5000|\(palliative_care)|\(p_palliative_care)|Home Visits|8000|\(home_visits)|\(p_home_visits)|Prenatal|2000|\(prenatal)|\(p_prenatal)|Long Term Care|5000|\(long_term_care)|\(p_long_term_care)|PC-SMI|2000|\(pc_smi)|\(p_pc_smi)|")
        }
        
        commands.append("PBEC_Chart|$\(self.addZeroToFloat(pro_hospital))|\(Int(pro_labour_and_delivery)) pts|$\(self.addZeroToFloat(pro_office_procedures))|\(Int(pro_palliative_care)) pts|\(pro_home_visits) pts/srvs|\(Int(pro_prenatal)) pts|\(Int(pro_long_term_care)) pts|\(Int(pro_pc_smi)) pts|")
        
        
        
        
        
        var month_code_array:[[String]]=[]
        let month_code_date_formater=NSDateFormatter()
        let claim_item_date_formatter=NSDateFormatter()
        claim_item_date_formatter.dateFormat="yyyyMMdd"
        month_code_date_formater.dateFormat="yyyy-MM"
        let components = NSDateComponents()
        let month_diff=get_month_diff(roster_start_date, end_date: roster_end_date)
        for var i=0;i<=month_diff;i++ {
            components.setValue(i, forComponent: NSCalendarUnit.Month);
            month_code_array.append([])
            month_code_array[i].append(month_code_date_formater.stringFromDate(NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: roster_start_date, options: NSCalendarOptions())!))
        }
        
        var temp_num_array:[Int]=[]
        for _ in month_code_array {
            temp_num_array.append(0)
        }
        var has_claims=false
        
        let only_codes=["K039A","Q040A","E079A","A888A","K032A","K037A","K028A","K023A","Q050A","Q015A","K030A"]
        let out_of_bsk_codes=["Smoking cessation follow-up visit (K039A)","Diabetes management incentive (Q040A)","Smoking cessation discussion add-on (E079A)","Emergency department equivalent (A888A)","Neurocognitive assessment (K032A)","Fibromyalgia/chronic fatigue syndrome (K037A)","STD management (K028A)","Palliative care support (K023A)","Heart Failure Management Incentive (Q050A)","Newborn Care Episodic Fee (Q015A)","Diabetic Management Assessment (K030A)"]
        for var i=0;i<out_of_bsk_codes.count;i++ {
            for var i=0;i<month_code_array.count;i++ {
                temp_num_array[i]=0
            }
            for ra_file in data_list {
                for claim in ra_file.claims {
                    for claim_item in claim.claim_items {
                        has_claims=true;
                        for var j=0;j<month_code_array.count;j++ {
                            if only_codes[i]==claim_item.service_code && month_code_date_formater.stringFromDate(claim_item_date_formatter.dateFromString(claim_item.service_date)!) == month_code_array[j][0] {
                                temp_num_array[j]+=1
                            }
                        }
                    }
                }
            }
            
            for var i=0;i<temp_num_array.count;i++ {
                month_code_array[i].append("\(temp_num_array[i])")
            }
        }
        for var i=0;i<month_code_array.count;i++ {
            var temp_num:Int=0
            for var j=1;j<month_code_array[i].count;j++ {
                temp_num+=Int(month_code_array[i][j])!
            }
            month_code_array[i].append("\(temp_num)")
        }
        var title_row:[String]=["Codes"]
        for var i=0;i<out_of_bsk_codes.count;i++ {
            title_row.append(out_of_bsk_codes[i])
        }
        title_row.append("Grand Total")
        var end_row:[String]=["Grand Total"]
        
        for var i=1;i<month_code_array[0].count;i++ {
            var temp_num:Int=0
            for var j=0;j<month_code_array.count;j++ {
                if let num=Int(month_code_array[j][i]) {
                    temp_num+=num
                }
            }
            end_row.append("\(temp_num)")
        }
        month_code_array.append(end_row)
        month_code_array.insert(title_row, atIndex: 0)
        
        var rotate_month_code_array:[[String]]=[]
        
        for var i=0;i<month_code_array.count;i++ {
            for var j=0;j<month_code_array[i].count;j++ {
                if j>=rotate_month_code_array.count {
                    rotate_month_code_array.append([])
                }
                rotate_month_code_array[j].append(month_code_array[i][j])
            }
        }
        //print(month_code_array)

        if has_claims {
            single="out_of_bsk|\(rotate_month_code_array[0].count)|"
            for row in rotate_month_code_array {
                for cell in row {
                    single+=cell+"|"
                }
            }
        }
        else {
            single="out_of_bsk|5| | | | |No Data Available|"
        }
        commands.append(single)
        
        class DetailClass {
            init(amount_submitted:Float, amount_claim_number:String, service_date:String, service_code:String, amount_paid:Float) {
                self.amount_submitted=amount_submitted
                self.amount_claim_number=amount_claim_number
                self.service_code=service_code
                self.service_date=service_date
                self.amount_paid=amount_paid
            }
            
            var amount_submitted:Float
            var amount_claim_number:String
            var amount_paid:Float
            var service_date:String
            var service_code:String
        }
        
        var top_users_detail:[String:[DetailClass]]=[String:[DetailClass]]()
        
        for ra in data_list {
            for claim in ra.claims {
                if top_users[claim.claim_header.health_registration_number]==nil {
                    top_users[claim.claim_header.health_registration_number]=0.0
                    top_users_detail[claim.claim_header.health_registration_number]=[]
                }
                
                for claim_item in claim.claim_items {
                    top_users[claim.claim_header.health_registration_number]!+=self.N_to_float(claim_item.amount_submitted)
                    top_users_detail[claim.claim_header.health_registration_number]!.append(DetailClass(amount_submitted: self.N_to_float(claim_item.amount_submitted), amount_claim_number:claim_item.claim_number, service_date:claim_item.service_date, service_code:claim_item.service_code, amount_paid:claim_item.amount_paid_sign=="-" ? -self.N_to_float(claim_item.amount_paid) : self.N_to_float(claim_item.amount_paid)))
                }
            }
        }
        
        var sorted_top_users:[(String, Float)]=[]
        
        for user in top_users {
            var inserted=false
            for var i=0;i<sorted_top_users.count;i++ {
                if sorted_top_users[i].1<user.1 {
                    inserted=true
                    sorted_top_users.insert(user, atIndex: i)
                    break
                }
            }
            if !inserted {
                sorted_top_users.append(user)
            }
        }
        
        single="top_RA_use|"
        var counter:Int=0;
        
        var single_detail="top_RA_use_detail|"
                
        for var i=0;i<sorted_top_users.count;i++ {
            var amount_paid_ttl:Float=0.0
            if i<sorted_top_users.count  {
                
                if (roster_list[sorted_top_users[i].0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())] != nil) {
                    
                    var firstNum="\(roster_list[sorted_top_users[i].0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())]!)"
                    
                    for claim_item in top_users_detail[sorted_top_users[i].0]! {
                        single_detail+="\(firstNum)|\(utility.subStringWithRange(claim_item.service_date, start: 1, Len: 4))-\(utility.subStringWithRange(claim_item.service_date, start: 5, Len: 2))-\(utility.subStringWithRange(claim_item.service_date, start: 7, Len: 2))|\(claim_item.service_code)|$\(self.addZeroToFloat(claim_item.amount_submitted))|$\(self.addZeroToFloat(claim_item.amount_paid))|"
                        firstNum=" "
                        amount_paid_ttl+=claim_item.amount_paid;
                    }
                    single_detail+="\(roster_list[sorted_top_users[i].0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())]!) Total| | |$\(sorted_top_users[i].1)|$\(amount_paid_ttl)|"
                    
                    single+="\(roster_list[sorted_top_users[i].0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())]!)|$\(self.addZeroToFloat(sorted_top_users[i].1))|$\(amount_paid_ttl)|"
                    
                    counter+=1
                }

            }
            if(counter>=20) {
                break
            }
            
        }
        commands.append(single_detail)
        commands.append(single)

    }
    
    func format_float_string(var str:String)->String {
        
        var negative=false
        
        if(str.characters.contains("-")) {
            str=str.componentsSeparatedByString("-")[1]
            negative=true
        }
        let end_zero=str.componentsSeparatedByString(".")[1].characters.count==1 ? "0" : ""
        let int_part=str.componentsSeparatedByString(".")[0]
        var char_set=Array(Array(int_part.characters).reverse())
        
        var comma_pos:[Int]=[]
        
        for var i=0;i<char_set.count;i++ {
            if i != 0 && i%3==0 {
                comma_pos.append(i)
            }
        }
        comma_pos.sortInPlace()
        for var i=comma_pos.count-1;i>=0;i-- {
            char_set.insert(",", atIndex: comma_pos[i])
        }
        
        var return_1:[String]=[]
        
        for i in char_set.reverse() {
            return_1.append(String(i))
        }
        
        let returnValue = return_1.joinWithSeparator("")+"."+str.componentsSeparatedByString(".")[1]+end_zero
        
        return negative ? "-"+returnValue : returnValue
    }
    func get_month_diff(start_date:NSDate, end_date:NSDate)->Int {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: start_date, toDate: end_date, options: NSCalendarOptions()).month
    }
    
    func remove_end_space(data:String)->String {
        return data.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
    }
    
    func collect_charts(data:[(String, Float)])->[String] {
        var collect_value:[(String, Float)]=[]
        var return_value:[String]=[]
        var added:Bool
        for i in data {
            added=false
            for var j=0;j<collect_value.count;j++ {
                if i.0==collect_value[j].0 {
                    collect_value[j].1+=i.1
                    added=true
                    break
                }
            }
            if added==false {
                collect_value.append(i)
            }
        }
        for i in collect_value {
            return_value.append(i.0)
            return_value.append(String(i.1))
        }
        return return_value
    }
    
    func view_to_float(num:String)->Float {
        var returnValue:Float=0.0
        var charset:[Character]=[]
        for i in num.characters {
            if ["0","1","2","3","4","5","6","7","8","9",".","-"].contains(i){
                charset.append(i)
            }
        }
        var exp:Float = -2
        var negative:Bool=false
        for var i = charset.count-1; i>=0; i-- {
            if charset[i] != "." {
                if charset[i] == "-" {
                    negative=true
                } else {
                    returnValue+=Float(String(charset[i]))! * pow(10.0 , exp)
                    exp += 1
                }
                //print(returnValue)

            }
        }
        return negative ? -returnValue : returnValue
    }
    
    func digit_to_float(num:String, sign:String)->Float {
        var returnValue:Float=0.0
        var charset:[Character]=[]
        for i in num.characters {
            charset.append(i)
        }
        var position:Int=0
        for i in charset {
            //let position:Int=Int(num.characters)
            returnValue+=Float(Int(String(i))!)*pow(10, Float(5-position))
            position+=1
        }
        return sign=="-" ? -returnValue : returnValue
    }
}