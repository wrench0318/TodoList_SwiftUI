//
//  TodoList_SwiftUITests.swift
//  TodoList_SwiftUITests
//
//  Created by 土橋正晴 on 2020/05/16.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import XCTest
@testable import TodoList_SwiftUI

class TodoList_SwiftUITests: XCTestCase {
 
        
        override func setUp() {
            // Put setup code here. This method is called before the invocation of each test method in the class.
        }

        override func tearDown() {
            // Put teardown code here. This method is called after the invocation of each test method in the class.
            ToDoModel.allDelete()
        }
        
        
        func test_AddModel() {
            
            ToDoModel.addRealm(addValue: TableValue(id: "0", title: "UnitTest", todoDate: "123", detail: "詳細"))
            let todoModel = ToDoModel.findRealm(todoId: 0, createTime: nil)
            
            XCTAssert(todoModel?.id == "0", "idが登録されていない")
            XCTAssert(todoModel?.toDoName == "UnitTest", "Todoのタイトルが登録されていない")
            XCTAssert(todoModel?.todoDate == "123", "　Todoの期限が登録されていない")
            XCTAssert(todoModel?.toDo == "詳細", "　Todoの詳細が登録されていない")
            XCTAssert(!(todoModel?.createTime!.isEmpty)!, "Todo作成時間が登録されていない")
        }
        
        
        
        func test_EditModel() {
            ToDoModel.addRealm(addValue: TableValue(id: "0", title: "UnitTest", todoDate: "123", detail: "詳細"))
        
            
            ToDoModel.updateRealm(todoId: 0, updateValue: TableValue(id: "0", title: "EditUnitTest", todoDate: "123456", detail: "詳細編集"))
            
            
            let todoModel = ToDoModel.findRealm(todoId: 0, createTime: nil)
            XCTAssert(todoModel?.id == "0", "idが登録されていない")
            XCTAssert(todoModel?.toDoName == "EditUnitTest", "Todoのタイトルが登録されていない")
            XCTAssert(todoModel?.todoDate == "123456", "　Todoの期限が登録されていない")
            XCTAssert(todoModel?.toDo == "詳細編集", "　Todoの詳細が登録されていない")
            XCTAssert(!(todoModel?.createTime!.isEmpty)!, "Todo作成時間が登録されていない")
        }
        

}
