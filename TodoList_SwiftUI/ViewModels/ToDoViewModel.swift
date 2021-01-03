//
//  ToDoViewModel.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/09/21.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation

enum SegmentIndex: Int, CaseIterable {
    case all = 0
    case active = 1
    case expired = 2
}


final class ToDoViewModel: ObservableObject {
    
    var todoModel: [ToDoModel] = []
    
    private var segmentIndex: SegmentIndex = .all
    
    @discardableResult
    func find(index: SegmentIndex = .all) -> [ToDoModel] {
        segmentIndex = index
        
        guard let model = ToDoModel.allFindRealm() else {
            return []
        }
        
        switch index {
        case .active:
            todoModel = model.filter {
                Format().dateFromString(string: $0.todoDate)! > Format().dateFormat()
            }
        case .expired:
            todoModel = model.filter {
                $0.todoDate <= Format().stringFromDate(date: Date())
            }
        default:
            todoModel = model
        }
        
        return todoModel
    }
    
    /// Todoを１件検索
    func findTodo(todoId: String, createTime: String) -> ToDoModel {
        let model = ToDoModel.findRealm(todoId: todoId, createTime: createTime)
        let todo = ToDoModel()
        todo.id = model?.id ?? ""
        todo.toDoName = model?.toDoName ?? ""
        todo.todoDate = model?.todoDate ?? ""
        todo.toDo = model?.toDo ?? ""
        
        return todo
    }
    
    
    /// 次に来るのTodoを検索する
    func findNextTodo() -> ToDoModel? {
        guard let nextTodo = find(index: .active).first,
              !nextTodo.id.isEmpty else {
            return nil
        }
        return nextTodo
    }
    
    
    /// Todoの追加
    func addTodo(add: ToDoModel?, success: ()->()?, failure: @escaping (String?)->()) {
        guard let _add = add else {
            return failure("Todoの追加に失敗しました")
        }
        
        ToDoModel.addRealm(addValue: _add) { result in
            switch result {
            case .success(_):
                success()
            case .failure(let error):
                print(error.localizedDescription)
                failure("Todoの追加に失敗しました")
            }
        }
    }
    
    
    /// Todoの更新
    func updateTodo(update: ToDoModel, success: () -> (), failure: @escaping (String?)->()) {
        ToDoModel.updateRealm(updateTodo: update, result: { result in
            switch result {
            case .success(_):
                success()
            case .failure(let error):
                print(error.localizedDescription)
                failure("Todoの更新に失敗しました")
            }
        })
    }
    
    
    
    
    /// Todoの削除
    func deleteTodo(todoId: String, createTime: String, success: (ToDoModel) -> (), failure: @escaping (String?)->()) {
        ToDoModel.deleteRealm(todoId: todoId, createTime: createTime) { result in
            switch result {
            case .success(let model):
                success(model)
            case .failure(let error):
                print(error.localizedDescription)
                failure("Todoの削除に失敗しました")
            }
            self.objectWillChange.send()
        }
    }
    
    
    func allDeleteTodo() {
        ToDoModel.allDelete()
        find(index: segmentIndex)
        self.objectWillChange.send()
    }
    
    
    
    /// バリデーションチェック
    /// - Parameter callBack: バリデーションの結果とあればエラーメッセージ
    /// - Returns: 入力に問題がなければfalse、問題があればtrueを返す
    func validateCheck(toDoModel: ToDoModel, callBack: (Bool, String) -> ()) {
        if toDoModel.toDoName.isEmpty {
            callBack(true, R.string.alertMessage.validate("タイトル"))
        } else if toDoModel.todoDate <= Format().stringFromDate(date: Format().dateFormat()) {
            callBack(true, R.string.alertMessage.validateDate())
        } else if toDoModel.toDo.isEmpty {
            callBack(true, R.string.alertMessage.validate("詳細"))
        } else {
            callBack(false, "")
        }
    }
    
    /// Realmのモデルを参照しない時はTestデータの配列を使う
//    @Published var todoModel: [ToDoModel] = todomodel

}

