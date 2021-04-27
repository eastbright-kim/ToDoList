//
//  Todo.swift
//  ToDoList
//
//  Created by 김동환 on 2021/04/27.
//

import Foundation

struct Todo: Codable, Equatable {
    
    let id: Int
    var isToday: Bool
    var isDone: Bool
    var detail: String
    
    
    mutating func update(isToday: Bool, isDone: Bool, detail: String){
        self.detail = detail
        self.isToday = isToday
        self.isDone = isDone
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
}

class TodoManager {
//
    static let shared = TodoManager()
    static var lastNumber = 0
    var todos = [Todo]()
    
    func create(detail: String, isToday: Bool, isDone: Bool) -> Todo {
        
        let nextNum = TodoManager.lastNumber + 1
        TodoManager.lastNumber = nextNum
        
        return Todo(id: nextNum, isToday: isToday, isDone: isDone, detail: detail)
    }
    
    func updateTodo(_ todo: Todo){
        
        guard let index = todos.firstIndex(of: todo) else { return }
        
        self.todos[index].update(isToday: todo.isToday, isDone: todo.isDone, detail: todo.detail)
    }
    
    func addTodo(_ todo: Todo){
        todos.append(todo)
    }
    
    func removeTodo(_ todo: Todo){
        self.todos = self.todos.filter{$0.id != todo.id}
    }
    
    func saveTodo(){
        
    }
    
    func retrieveTodo(){
        
    }
    
}

class TodoViewModel {
    
    //뷰모델은 뷰를 반영함. section을 2개 가지고 있음
    enum Section: Int, CaseIterable {
        case Today, Upcomming

        var sectionTitle: String {
            switch self {
            case .Today:
                return "Today"
            default:
                return "Upcomming"
            }
        }
    }
    // private이고, 매니저가 가저오는 정보들을 computed property로 가지고 있음
    private let manager = TodoManager.shared

    var todos: [Todo] {
        return manager.todos
    }

    var todayTodos: [Todo] {
        return todos.filter{$0.isToday == true}
    }

    var upcommingTodos: [Todo] {
        return todos.filter{$0.isToday == false}
    }

    var numberOfsections: Int {
        return Section.allCases.count
    }

    func addTodo(_ toDo: Todo){
        manager.addTodo(toDo)
    }

    func deleteTodo(_ toDo: Todo){
        manager.removeTodo(toDo)
    }

    func updateTodo(_ toDo: Todo){
        manager.addTodo(toDo)
    }

    func retrieveTodo(){
        manager.retrieveTodo()
    }
}
