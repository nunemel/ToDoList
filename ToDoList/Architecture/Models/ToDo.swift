//
//  ToDo.swift
//  ToDoList
//
//  Created by Nune Melikyan on 26.09.22.
//

import UIKit

struct ToDo: Equatable, Codable {
  var id: UUID
  var title: String
  var isComplete: Bool
  var dueDate: Date
  var notes: String?

  // MARK: - Initalization
  init(
    title: String,
    isComplete: Bool,
    dueDate: Date,
    notes: String?
  ) {
    self.id = UUID()
    self.title = title
    self.isComplete = isComplete
    self.dueDate = dueDate
    self.notes = notes
  }

  static func == (lhs: ToDo, rhs: ToDo) -> Bool {
    return lhs.id == rhs.id
  }

  static let documentsDirectory = FileManager.default.urls(
    for: .documentDirectory,
    in: .userDomainMask
  ).first!
  static let archiveUrl = documentsDirectory.appendingPathComponent(
    "toDos"
  ).appendingPathExtension("plist")

  // MARK: - Persistence
  static func loadToDos() -> [ToDo]? {
    guard let encodedToDos = try? Data(contentsOf: archiveUrl)
    else {
      return nil
    }
    let propertyListDecoder = PropertyListDecoder()
    return try? propertyListDecoder.decode(
      Array<ToDo>.self,
      from: encodedToDos
    )
  }

  static func loadSampleToDos() -> [ToDo] {
    let toDo1 = ToDo(
      title: "To-Do One",
      isComplete: false,
      dueDate: Date(),
      notes: "Notes 1"
    )
    let toDo2 = ToDo(
      title: "To-Do Two",
      isComplete: false,
      dueDate: Date(),
      notes: "Notes 2"
    )
    let toDo3 = ToDo(
      title: "To-Do Three",
      isComplete: false,
      dueDate: Date(),
      notes: "Notes 3"
    )
    return [toDo1, toDo2, toDo3]
  }

  static func saveToDos(_ toDos: [ToDo]) {
    let propertyListEncoder = PropertyListEncoder()
    let codedToDos = try? propertyListEncoder.encode(toDos)
    try? codedToDos?.write(to: archiveUrl)
  }
}
