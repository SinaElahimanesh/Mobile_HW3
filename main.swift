//  main.swift
//  todo

import Foundation

enum MenuState {
    case MainMenu
    case GroupsList
    case AddToDo
    case AddGroups
    case ToDoList
    case ToDoSetting
    
    mutating func back() -> Void {
        switch self {
        case .GroupsList,.AddGroups,.AddToDo,.ToDoList:
            self = .MainMenu
        case .ToDoSetting:
            self = .ToDoList
        default:
            self = .MainMenu
        }
    }
    
    func getInput() -> String {
        switch self {
        case .MainMenu,.GroupsList,.AddGroups,.ToDoSetting:
            return readLine()!
        case .AddToDo,.ToDoList:
            return "no input"
        }
    }
}


class ToDo{
    static var ToDos = [ToDo]()
    
    var title : String
    var content : String
    var priority : Int
    var createdAt: Date
    
    init(title: String,content: String,priority :Int){
        self.title = title
        self.content = content
        self.priority = priority
        self.createdAt = Date()
        ToDo.ToDos.append(self)
    }
    
    static func printAllToDo(listOfToDO: [ToDo] = ToDos) -> Void{
        if listOfToDO.isEmpty{
            print("no ToDO")
            return
        }
        for todo in listOfToDO{
            print("todo title: \(todo.title) with priority \(todo.priority) created at \(todo.createdAt)")
        }
    }
    
    static func deleteTodoWithIndex(index: Int)->Void{
        ToDos.remove(at: index)
    }
    
    static func editTodoWithIndex(index: Int)->Void{
        print("1-edit title\n2-edit content\n3-edit priority")
        let input = readLine()!
        if input=="1"{
            editTitleWithIndex(index: index)
            print("Title was successfully changed!")
            return
        } else if input=="2"{
            editContentWithIndex(index: index)
            print("Content was successfully changed!")
            return
        } else if input=="3"{
            editPriorityWithIndex(index: index)
            print("Priority was successfully changed!")
            return
        } else {
            print("invalid input")
            return
        }
    }
    
    static func editTitleWithIndex(index: Int)->Void{
        print("please insert new Title:")
        let input = readLine()!
        ToDos[index].title = input
        return
    }
    
    static func editContentWithIndex(index: Int)->Void{
        print("please insert new Content:")
        let input = readLine()!
        ToDos[index].content = input
        return
    }
    
    static func editPriorityWithIndex(index: Int)->Void{
        print("please insert new Priority:")
        let input = Int(readLine()!)
        ToDos[index].priority = input!
        return
    }
    
    static func getTodoCount() -> Int{
        return ToDos.count
    }
    
    static func getTodoWithname(title: String) -> Int{
        for i in 0...ToDos.count-1{
            if ToDos[i].title == title{
                return i
            }
        }
        return -1
    }
    
    static func sortByPriority(ascending: Bool, field: String) -> Void{
        var sortedList : [ToDo]
        if field=="priority"{
            sortedList = ToDos.sorted(by: { ascending&&($0.priority<$1.priority) })
        }else if field=="title"{
            sortedList = ToDos.sorted(by: { ascending&&($0.title<$1.title) })
        }else{
            sortedList = ToDos.sorted(by: { ascending&&($0.createdAt.compare($1.createdAt).rawValue==1) })
        }
        printAllToDo(listOfToDO: sortedList)
    
    }

}

class Group {
    static var groups = [Group]()
    
    var name : String = ""
    var todoList = [ToDo]()
    
    init(name: String) {
        self.name = name
        Group.groups.append(self)
    }
    
    static func doesGroupExistWithName(name: String) -> Bool{
        for group in groups{
            if group.name == name{
                return true
            }
        }
        return false
    }
    
    static func printGroups() -> Void{
        printAllGroups()
        print("insert group index to see todo list of group:")
        let input = Int(readLine()!)
        ToDo.printAllToDo(listOfToDO: groups[input!-1].todoList)
    }
    
    static func printAllGroups() -> Void{
        var index = 1
        if groups.isEmpty{
            print("no groups")
            return
        }
        for group in groups{
            print(String(index)+"- "+group.name)
            index+=1
        }
    }
    
    static func getGroupCount() -> Int{
        return groups.count
    }
    
    static func addToGroup(index: Int)->Void{
        printAllGroups()
        print("please insert group index:")
        let input = Int(readLine()!)
        groups[input!-1].todoList.append(ToDo.ToDos[index])
        print("ToDo was successfully added to Group!")
    }
}



struct Menu{
    var menu=MenuState.MainMenu
    var todoIndex = 0
    
    mutating func run() -> Void {
        let input = menu.getInput()
        if input == "back"{
            menu.back()
        }else{
        switch menu {
        case .MainMenu:
            
            runMainMenu(input: input)
        case .GroupsList:
            runGroups(input: input)
        case .AddGroups:
            runAddGroup(name: input)
        case .AddToDo:
            runAddToDo()
        case .ToDoList:
            runToDo()
        case .ToDoSetting:
            runToDoSetting(input: input)
            }
        }
        print("\n---------------")
    }
    
    func printMenu() -> Void {
        switch menu {
        case .MainMenu:
            print("Main Menu\n1- add group\n2- view groups\n3- add TODO\n4- view TODO")
        case .GroupsList:
            print("list of all groups\n")
            Group.printGroups()
        case .AddGroups:
            print("Add Group Menu\nplease enter the name of the group:")
        case .AddToDo:
            print("Add ToDo Menu\n")
        case .ToDoList:
            print("list of all todos\nenter view todoname to go to todo menu\nenter sort(+|-) priotrity|data|name to sort todos")
            ToDo.printAllToDo()
        case .ToDoSetting:
            print("1-edit\n2-add to group\n3-delete")
        }
    }
    
    private mutating func runMainMenu(input: String) -> Void {
        let choice = Int(input) ?? -1
        if choice == 1{
            menu = .AddGroups
        }else if choice == 2{
            menu = .GroupsList
        }else if choice == 3{
            menu = .AddToDo
        }else if choice == 4{
            menu = .ToDoList
        }else{
            print("invalid input\n")
        }
    }
    
    private mutating func runAddGroup(name: String) -> Void {
        if Group.doesGroupExistWithName(name:name){
            print("Group with this name already exists please choose another name!")
        }else{
            _ = Group(name: name)
            print("group \"\(name)\" was added successfully! returning to main menu")
            menu = .MainMenu
        }
    }
    
    private mutating func runAddToDo() -> Void {
        print("enter exit anywhere to termiate!\n")
        if let title = reader(hint: "enter ToDo title:") {
            if let content = reader(hint: "enter ToDo content:"){
                if let priority = Int(reader(hint: "enter ToDo priority:")!){
                    _ = ToDo.init(title: title, content: content, priority: priority)
                    print("ToDo added successfully!\n")
                    menu.back()
                }
                }
            }
        }
    
    private func runGroups(input: String) -> Void {
           let choice = Int(input) ?? -1
           if 0<choice && choice<Group.getGroupCount(){
               print(2)
           }else{
               print("Invalid Input")
           }
       }
    
    private mutating func runToDo() -> Void {
        let input = readLine()!
        if input=="back"{
            menu.back()
            return
        }
        let command = input.split(separator: " ")
        if input.starts(with: "view"){
            todoIndex = ToDo.getTodoWithname(title: input[5...])
            if todoIndex == -1{
                print("no todo exist with this name\n")
            }
            menu = .ToDoSetting
        }else if command[0].starts(with: "sort"){
            ToDo.sortByPriority(ascending: command[0].contains("+"), field: String(command[1]))
              runToDo()
        }
    }
    private mutating func runToDoSetting(input: String) -> Void {
        let choice = Int(input) ?? -1
        if choice == 1{ //edit
            ToDo.editTodoWithIndex(index: todoIndex)
            menu.back()
            return
        }else if choice == 2{ //add to group
            Group.addToGroup(index: todoIndex)
            return
        }else if choice == 3{ //delete
            ToDo.deleteTodoWithIndex(index: todoIndex)
            menu.back()
        }else{
            print("invalid input\n")
        }
    }
    
    private mutating func reader(hint: String) -> String?{
        print(hint)
        let input = readLine()
        if input == "exit"{
            print("proccess terminated!\n")
            menu.back()
            return nil
        }
        return input
    }
}

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
         return String(self[start...])
    }
}




print("please choose the option you would like to use! type back anywhere to return to previous menu\n")

var menu = Menu()
while true{
    menu.printMenu()
    menu.run()
}
