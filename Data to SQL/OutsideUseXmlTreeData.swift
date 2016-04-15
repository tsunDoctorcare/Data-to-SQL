//
//  xmlTreeData.swift
//  Data to SQL
//
//  Created by Tao Sun on 1/6/28 H.
//  Copyright © 28 Heisei Yikkuro's Workshop. All rights reserved.
//

import Foundation

class REPORT_ID {
    init(txt:String?) {
        self.txt=txt
    }
    init() {
        self.txt=nil
    }
    var txt:String?=String()
    func otxt()->String!{
        return ((self.txt==nil) ? "" : self.txt!)
    }
}
class REPORT_DATE{
    init(txt:String?) {
        self.txt=txt
    }
    init() {
        self.txt=nil
    }
    var txt:String?=String()
    func otxt()->String!{
        return ((self.txt==nil) ? "" : self.txt!)
    }
}
class REPORT_NAME{
    init(txt:String?) {
        self.txt=txt
    }
    init() {
        self.txt=nil
    }
    var txt:String?=String()
    func otxt()->String!{
        return ((self.txt==nil) ? "" : self.txt!)
    }
}
class REPORT_PERIOD_START{
    init(txt:String?) {
        self.txt=txt
    }
    init() {
        self.txt=nil
    }
    var txt:String?=String()
    func otxt()->String!{
        return ((self.txt==nil) ? "" : self.txt!)
    }
}
class REPORT_PERIOD_END{
    init(txt:String?) {
        self.txt=txt
    }
    init() {
        self.txt=nil
    }
    var txt:String?=String()
    func otxt()->String!{
        return ((self.txt==nil) ? "" : self.txt!)
    }
}
class GROUP_ID {
    init(txt:String?) {
        self.txt=txt
    }
    init() {
        self.txt=nil
    }
    var txt:String?=String()
    func otxt()->String!{
        return ((self.txt==nil) ? "" : self.txt!)
    }
}
class GROUP_TYPE {
    init(txt:String?) {
        self.txt=txt
    }
    init() {
        self.txt=nil
    }
    var txt:String?=String()
    func otxt()->String!{
        return ((self.txt==nil) ? "" : self.txt!)
    }
}
class GROUP_NAME {
    init(txt:String?) {
        self.txt=txt
    }
    init() {
        self.txt=nil
    }
    var txt:String?=String()
    func otxt()->String!{
        return ((self.txt==nil) ? "" : self.txt!)
    }
}
class PROVIDER_NUMBER {
    init(txt:String?) {
        self.txt=txt
    }
    init() {
        self.txt=nil
    }
    var txt:String?=String()
    func otxt()->String!{
        return ((self.txt==nil) ? "" : self.txt!)
    }
}
class PROVIDER_LAST_NAME {
    init(txt:String?) {
        self.txt=txt
    }
    init() {
        self.txt=nil
    }
    var txt:String?=String()
    func otxt()->String!{
        return ((self.txt==nil) ? "" : self.txt!)
    }
}
class PROVIDER_FIRST_NAME {
    init(txt:String?) {
        self.txt=txt
    }
    init() {
        self.txt=nil
    }
    var txt:String?=String()
    func otxt()->String!{
        return ((self.txt==nil) ? "" : self.txt!)
    }
}
class PROVIDER_MIDDLE_NAME {
    init(txt:String?) {
        self.txt=txt
    }
    init() {
        self.txt=nil
    }
    var txt:String?=String()
    func otxt()->String!{
        return ((self.txt==nil) ? "" : self.txt!)
    }
}
class PATIENT_HEALTH_NUMBER {
    init(txt:String?) {
        self.txt=txt
    }
    init() {
        self.txt=nil
    }
    var txt:String?=String()
    func otxt()->String!{
        return ((self.txt==nil) ? "" : self.txt!)
    }
}
class PATIENT_LAST_NAME {
    init(txt:String?) {
        self.txt=txt
    }
    init() {
        self.txt=nil
    }
    var txt:String?=String()
    func otxt()->String!{
        return ((self.txt==nil) ? "" : self.txt!)
    }
}

class PATIENT_FIRST_NAME {
    init(txt:String?) {
        self.txt=txt
    }
    init() {
        self.txt=nil
    }
    var txt:String?=String()
    func otxt()->String!{
        return ((self.txt==nil) ? "" : self.txt!)
    }
}

class PATIENT_BIRTHDATE {
    init(txt:String?) {
        self.txt=txt
    }
    init() {
        self.txt=nil
    }
    var txt:String?=String()
    func otxt()->String!{
        return ((self.txt==nil) ? "" : self.txt!)
    }
}

class PATIENT_SEX {
    init(txt:String?) {
        self.txt=txt
    }
    init() {
        self.txt=nil
    }
    var txt:String?=String()
    func otxt()->String!{
        return ((self.txt==nil) ? "" : self.txt!)
    }
}

class SERVICE_DATE {
    init(txt:String?) {
        self.txt=txt
    }
    init() {
        self.txt=nil
    }
    var txt:String?=String()
    func otxt()->String!{
        return ((self.txt==nil) ? "" : self.txt!)
    }
}
class SERVICE_CODE {
    init(txt:String?) {
        self.txt=txt
    }
    init() {
        self.txt=nil
    }
    var txt:String?=String()
    func otxt()->String!{
        return ((self.txt==nil) ? "" : self.txt!)
    }
}
class SERVICE_DESCRIPTION {
    init(txt:String?) {
        self.txt=txt
    }
    init() {
        self.txt=nil
    }
    var txt:String?=String()
    func otxt()->String!{
        return ((self.txt==nil) ? "" : self.txt!)
    }
}
class SERVICE_AMT {
    init(txt:String?) {
        self.txt=txt
    }
    init() {
        self.txt=nil
    }
    var txt:String?=String()
    func otxt()->String!{
        return ((self.txt==nil) ? "" : self.txt!)
    }
}
class REPORT_DTL{
    func copy()->REPORT_DTL {
        let returnValue:REPORT_DTL=REPORT_DTL(report_id: self.report_id, report_date: self.report_date, report_name: self.report_name, report_period_start: self.report_period_start, report_period_end: self.report_period_end)
        return returnValue
    }
    init(report_id:REPORT_ID, report_date:REPORT_DATE, report_name:REPORT_NAME, report_period_start:REPORT_PERIOD_START,report_period_end:REPORT_PERIOD_END) {
        self.report_id=REPORT_ID(txt: report_id.txt)
        self.report_date=REPORT_DATE(txt: report_date.txt)
        self.report_name=REPORT_NAME(txt: report_name.txt)
        self.report_period_start=REPORT_PERIOD_START(txt: report_period_start.txt)
        self.report_period_end=REPORT_PERIOD_END(txt: report_period_end.txt)

    }
    init() {
        self.report_date=REPORT_DATE()
        self.report_id=REPORT_ID()
        self.report_name=REPORT_NAME()
        self.report_period_start=REPORT_PERIOD_START()
        self.report_period_end=REPORT_PERIOD_END()
    }
    
    var report_id:REPORT_ID=REPORT_ID()
    var report_date:REPORT_DATE=REPORT_DATE()
    var report_name:REPORT_NAME=REPORT_NAME()
    var report_period_start:REPORT_PERIOD_START=REPORT_PERIOD_START()
    var report_period_end:REPORT_PERIOD_END=REPORT_PERIOD_END()
}
class GROUP_DTL {
    func copy()->GROUP_DTL {
        let returnValue:GROUP_DTL=GROUP_DTL(group_id: self.group_id, group_type: self.group_type, group_name: self.group_name)
        return returnValue
    }
    init(group_id:GROUP_ID, group_type:GROUP_TYPE, group_name:GROUP_NAME) {
        self.group_id=GROUP_ID(txt: group_id.txt)
        self.group_type=GROUP_TYPE(txt: group_type.txt)
        self.group_name=GROUP_NAME(txt: group_name.txt)
    }
    init() {
        self.group_id=GROUP_ID()
        self.group_name=GROUP_NAME()
        self.group_type=GROUP_TYPE()
    }
    var group_id:GROUP_ID=GROUP_ID()
    var group_type:GROUP_TYPE=GROUP_TYPE()
    var group_name:GROUP_NAME=GROUP_NAME()
}
class PROVIDER_DTL {
    func copy()->PROVIDER_DTL {
        let returnValue:PROVIDER_DTL=PROVIDER_DTL(provider_number: self.provider_number, provider_last_name: self.provider_last_name, provider_first_name: self.provider_first_name, provider_middle_name:self.provider_middle_name)
        return returnValue
    }
    init(provider_number:PROVIDER_NUMBER, provider_last_name:PROVIDER_LAST_NAME, provider_first_name:PROVIDER_FIRST_NAME, provider_middle_name:PROVIDER_MIDDLE_NAME) {
        self.provider_number=PROVIDER_NUMBER(txt: provider_number.txt)
        self.provider_last_name=PROVIDER_LAST_NAME(txt: provider_last_name.txt)
        self.provider_first_name=PROVIDER_FIRST_NAME(txt: provider_first_name.txt)
        self.provider_middle_name=PROVIDER_MIDDLE_NAME(txt: provider_middle_name.txt)
    }
    init() {
        self.provider_number=PROVIDER_NUMBER()
        self.provider_middle_name=PROVIDER_MIDDLE_NAME()
        self.provider_last_name=PROVIDER_LAST_NAME()
        self.provider_first_name=PROVIDER_FIRST_NAME()
    }
    
    var provider_number:PROVIDER_NUMBER=PROVIDER_NUMBER()
    var provider_last_name:PROVIDER_LAST_NAME=PROVIDER_LAST_NAME()
    var provider_first_name:PROVIDER_FIRST_NAME=PROVIDER_FIRST_NAME()
    var provider_middle_name:PROVIDER_MIDDLE_NAME=PROVIDER_MIDDLE_NAME()
}
class SERVICE_DTL1 {
    func copy()->SERVICE_DTL1 {
        let returnValue:SERVICE_DTL1=SERVICE_DTL1(service_date: self.service_date, service_code: self.service_code, service_amt: self.service_amt, service_description:self.service_description)
        return returnValue
    }
    init(service_date:SERVICE_DATE, service_code:SERVICE_CODE, service_amt:SERVICE_AMT,service_description:SERVICE_DESCRIPTION) {
        self.service_date=SERVICE_DATE(txt: service_date.txt)
        self.service_code=SERVICE_CODE(txt: service_code.txt)
        self.service_description=SERVICE_DESCRIPTION(txt: service_description.txt)
        self.service_amt=SERVICE_AMT(txt: service_amt.txt)
    }
    init() {
        self.service_date=SERVICE_DATE()
        self.service_code=SERVICE_CODE()
        self.service_amt=SERVICE_AMT()
        self.service_description=SERVICE_DESCRIPTION()
    }

    var service_date:SERVICE_DATE=SERVICE_DATE()
    var service_code:SERVICE_CODE=SERVICE_CODE()
    var service_description:SERVICE_DESCRIPTION=SERVICE_DESCRIPTION()
    var service_amt:SERVICE_AMT=SERVICE_AMT()
}
class PATIENT_DTL {
    func copy()->PATIENT_DTL {
        let returnValue:PATIENT_DTL=PATIENT_DTL(patient_health_number: self.patient_health_number, patient_last_name: self.patient_last_name, patient_first_name: self.patient_first_name, patient_birthdate:self.patient_birthdate,patient_sex:self.patient_sex)
        return returnValue
    }
    init(patient_health_number:PATIENT_HEALTH_NUMBER, patient_last_name:PATIENT_LAST_NAME, patient_first_name:PATIENT_FIRST_NAME,patient_birthdate:PATIENT_BIRTHDATE, patient_sex:PATIENT_SEX) {
        self.patient_health_number=PATIENT_HEALTH_NUMBER(txt: patient_health_number.txt)
        self.patient_last_name=PATIENT_LAST_NAME(txt: patient_last_name.txt)
        self.patient_first_name=PATIENT_FIRST_NAME(txt: patient_first_name.txt)
        self.patient_birthdate=PATIENT_BIRTHDATE(txt: patient_birthdate.txt)
        self.patient_sex=PATIENT_SEX(txt:patient_sex.txt)
    }
    init() {
        self.patient_health_number=PATIENT_HEALTH_NUMBER()
        self.patient_birthdate=PATIENT_BIRTHDATE()
        self.patient_first_name=PATIENT_FIRST_NAME()
        self.patient_last_name=PATIENT_LAST_NAME()
        self.patient_sex=PATIENT_SEX()
    }
    
    var patient_health_number:PATIENT_HEALTH_NUMBER=PATIENT_HEALTH_NUMBER()
    var patient_last_name:PATIENT_LAST_NAME=PATIENT_LAST_NAME()
    var patient_first_name:PATIENT_FIRST_NAME=PATIENT_FIRST_NAME()
    var patient_birthdate:PATIENT_BIRTHDATE=PATIENT_BIRTHDATE()
    var patient_sex:PATIENT_SEX=PATIENT_SEX()
}
class PATIENT {
    init(patient_dtl:PATIENT_DTL, service_dtl1_list:[SERVICE_DTL1]) {
        self.patient_dtl=patient_dtl
        self.service_dtl1_list=[]
        for i in 0..<service_dtl1_list.count {
            self.service_dtl1_list.append(service_dtl1_list[i])
        }
    }
    init() {
        self.patient_dtl=PATIENT_DTL()
        self.service_dtl1_list=[]
    }
    func copy()->PATIENT {
        let returnValue:PATIENT=PATIENT(patient_dtl:self.patient_dtl, service_dtl1_list:self.service_dtl1_list)
        return returnValue
    }
    var patient_dtl:PATIENT_DTL=PATIENT_DTL()
    var service_dtl1_list:[SERVICE_DTL1]
}
class PROVIDER {
    init(provider_dtl:PROVIDER_DTL, patient_list:[PATIENT]) {
        self.provider_dtl=provider_dtl
        self.patient_list=[]
        for i in 0..<patient_list.count {
            self.patient_list.append(patient_list[i])
        }
    }
    init() {
        self.provider_dtl=PROVIDER_DTL()
        self.patient_list=[]
    }
    func copy()->PROVIDER {
        let returnValue:PROVIDER=PROVIDER(provider_dtl: self.provider_dtl, patient_list:self.patient_list)
        return returnValue
    }

    var provider_dtl:PROVIDER_DTL=PROVIDER_DTL()
    var patient_list:[PATIENT]
}
class GROUP {
    init(group_dtl:GROUP_DTL, provider:PROVIDER) {
        self.group_dtl=group_dtl
        self.provider=provider
    }
    init() {
        self.group_dtl=GROUP_DTL()
        self.provider=PROVIDER()
    }
    func copy()->GROUP {
        let returnValue:GROUP=GROUP(group_dtl: self.group_dtl, provider: self.provider)
        return returnValue
    }
    var group_dtl:GROUP_DTL=GROUP_DTL()
    var provider:PROVIDER=PROVIDER()
}
class REPORT {
    init(report_dtl:REPORT_DTL, group:GROUP) {
        self.report_dtl=report_dtl
        self.group=group
    }
    init() {
        self.report_dtl=REPORT_DTL()
        self.group=GROUP()
    }
    func copy()->REPORT {
        let returnValue:REPORT=REPORT(report_dtl: self.report_dtl, group: self.group)
        return returnValue
    }
    var report_dtl:REPORT_DTL=REPORT_DTL()
    var group:GROUP=GROUP()
}

class OUTSIDE_USE_TEMP {
    var report:REPORT=REPORT()
    var report_dtl:REPORT_DTL=REPORT_DTL()
    var report_id:REPORT_ID=REPORT_ID()
    var report_date:REPORT_DATE=REPORT_DATE()
    var report_name:REPORT_NAME=REPORT_NAME()
    var report_period_start:REPORT_PERIOD_START=REPORT_PERIOD_START()
    var report_period_end:REPORT_PERIOD_END=REPORT_PERIOD_END()
    var group:GROUP=GROUP()
    var group_dtl:GROUP_DTL=GROUP_DTL()
    var group_id:GROUP_ID=GROUP_ID()
    var group_type:GROUP_TYPE=GROUP_TYPE()
    var group_name:GROUP_NAME=GROUP_NAME()
    var provider:PROVIDER=PROVIDER()
    var provider_dtl:PROVIDER_DTL=PROVIDER_DTL()
    var provider_number:PROVIDER_NUMBER=PROVIDER_NUMBER()
    var provider_last_name:PROVIDER_LAST_NAME=PROVIDER_LAST_NAME()
    var provider_first_name:PROVIDER_FIRST_NAME=PROVIDER_FIRST_NAME()
    var provider_middle_name:PROVIDER_MIDDLE_NAME=PROVIDER_MIDDLE_NAME()
    var patient:PATIENT=PATIENT()
    var patient_dtl:PATIENT_DTL=PATIENT_DTL()
    var patient_health_number:PATIENT_HEALTH_NUMBER=PATIENT_HEALTH_NUMBER()
    var patient_last_name:PATIENT_LAST_NAME=PATIENT_LAST_NAME()
    var patient_first_name:PATIENT_FIRST_NAME=PATIENT_FIRST_NAME()
    var patient_birthdate:PATIENT_BIRTHDATE=PATIENT_BIRTHDATE()
    var patient_sex:PATIENT_SEX=PATIENT_SEX()
    var service_dtl1:SERVICE_DTL1=SERVICE_DTL1()
    var service_date:SERVICE_DATE=SERVICE_DATE()
    var service_code:SERVICE_CODE=SERVICE_CODE()
    var service_description:SERVICE_DESCRIPTION=SERVICE_DESCRIPTION()
    var service_amt:SERVICE_AMT=SERVICE_AMT()
    var elementName:String=String()
    var patient_list:[PATIENT]=[]
    var service_dtl1_list:[SERVICE_DTL1]=[]
    
    func reset() {
        report=REPORT()
        report_dtl=REPORT_DTL()
        report_id=REPORT_ID()
        report_date=REPORT_DATE()
        report_name=REPORT_NAME()
        report_period_start=REPORT_PERIOD_START()
        report_period_end=REPORT_PERIOD_END()
        group=GROUP()
        group_dtl=GROUP_DTL()
        group_id=GROUP_ID()
        group_type=GROUP_TYPE()
        group_name=GROUP_NAME()
        provider=PROVIDER()
        provider_dtl=PROVIDER_DTL()
        provider_number=PROVIDER_NUMBER()
        provider_last_name=PROVIDER_LAST_NAME()
        provider_first_name=PROVIDER_FIRST_NAME()
        provider_middle_name=PROVIDER_MIDDLE_NAME()
        patient=PATIENT()
        patient_dtl=PATIENT_DTL()
        patient_health_number=PATIENT_HEALTH_NUMBER()
        patient_last_name=PATIENT_LAST_NAME()
        patient_first_name=PATIENT_FIRST_NAME()
        patient_birthdate=PATIENT_BIRTHDATE()
        patient_sex=PATIENT_SEX()
        service_dtl1=SERVICE_DTL1()
        service_date=SERVICE_DATE()
        service_code=SERVICE_CODE()
        service_description=SERVICE_DESCRIPTION()
        service_amt=SERVICE_AMT()
        elementName=String()
        patient_list=[]
        service_dtl1_list=[]
    }
}
