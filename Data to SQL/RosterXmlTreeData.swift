//
//  RosterXmlTreeData.swift
//  Data to SQL
//
//  Created by Tao Sun on 1/7/28 H.
//  Copyright © 28 Heisei Yikkuro's Workshop. All rights reserved.
//

import Foundation

class ITEM {
    var name:String?=String()
    init() {
        name=nil;
    }
    init(name:String?) {
        self.name=name;
    }
    func otxt()->String!{
        return self.name==nil ? "" : self.name!
    }
}

class METADATA {
    var item_list:[ITEM]=[]
    init() {
        item_list=[]
    }
    init(item_list:[ITEM]) {
        for i in 0..<item_list.count {
            self.item_list.append(ITEM(name: item_list[i].name))
        }
    }
}

class VALUE {
    var value:String?=String()
    init() {
        value=nil;
    }
    init(value:String?) {
        self.value=value;
    }
    func otxt()->String!{
        return self.value==nil ? "" : self.value!
    }
}

class ROW {
    var value_list:[VALUE]=[]
    init() {
        self.value_list=[]
    }
    init(value_list:[VALUE]) {
        for i in 0..<value_list.count {
            self.value_list.append(VALUE(value:value_list[i].value))
        }
    }
}

class DATA {
    var row_list:[ROW]=[]
    init() {
        self.row_list=[]
    }
    init(row_list:[ROW]) {
        for i in 0..<row_list.count {
            self.row_list.append(ROW(value_list: row_list[i].value_list))
        }
    }
}

class DATASET {
    var metadata:METADATA
    var data:DATA
    var filename:String=String()
    init() {
        self.metadata=METADATA()
        self.data=DATA()
    }
    init(metadata:METADATA,data:DATA) {
        self.metadata=METADATA(item_list: metadata.item_list)
        self.data=DATA(row_list: data.row_list)
    }
}

class ROSTER_TEMP {
    var value:VALUE=VALUE()
    var row:ROW=ROW()
    var data:DATA=DATA()
    var item:ITEM=ITEM()
    var metadata:METADATA=METADATA()
    var dataset:DATASET=DATASET()
    var value_list:[VALUE]=[]
    var row_list:[ROW]=[]
    var item_list:[ITEM]=[]
    var elementName:String?=String()
    
    func reset() {
        value=VALUE()
        row=ROW()
        data=DATA()
        item=ITEM()
        metadata=METADATA()
        dataset=DATASET()
        value_list=[]
        row_list=[]
        item_list=[]
        elementName=String()
        
    }
}