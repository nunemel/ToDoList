//
//  ToDoDetailTableViewController.swift
//  ToDoList
//
//  Created by Nune Melikyan on 27.09.22.
//

import UIKit

final class ToDoDetailTableViewController: UITableViewController {

  @IBOutlet private var titleTextField: UITextField!
  @IBOutlet private var isCompleteButton: UIButton!
  @IBOutlet private var dueDateLabel: UILabel!
  @IBOutlet private var dueDateDatePicker: UIDatePicker!
  @IBOutlet private var notesTextView: UITextView!
  @IBOutlet private var saveButton: UIBarButtonItem!

  private var isDatePickerHidden = true
  private let dateLabelIndexPath = IndexPath(row: 0, section: 1)
  private let datePickerIndexPath = IndexPath(row: 1, section: 1)
  private let notesIndexPath = IndexPath(row: 0, section: 2)

  var toDo: ToDo?

  @IBAction func returnPressed(_ sender: UITextField) {
    sender.resignFirstResponder()
  }

  @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
    isCompleteButton.isSelected.toggle()
  }

  @IBAction func datePickerChanged(_ sender: UIDatePicker) {
    updateDueDateLabel(date: sender.date)
  }

  private func updateDueDateLabel(date: Date) {
    dueDateLabel.text = date.formatted(
      .dateTime.month(.defaultDigits)
        .day().year(.twoDigits).hour().minute()
    )
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let currentDueDate: Date
    if let toDo = toDo {
      navigationItem.title = "To-Do"
      titleTextField.text = toDo.title
      isCompleteButton.isSelected = toDo.isComplete
      currentDueDate = toDo.dueDate
      notesTextView.text = toDo.notes
    }
    else {
      currentDueDate = Date().addingTimeInterval(24 * 60 * 60)
    }
    dueDateDatePicker.date = currentDueDate
    updateDueDateLabel(date: currentDueDate)
    updateSaveButtonState()
  }

  @IBAction func textEditingChanged(_ sender: UITextField) {
    updateSaveButtonState()
  }

  private func updateSaveButtonState() {
    let shouldEnableSaveButton = titleTextField.text?.isEmpty == false
    saveButton.isEnabled = shouldEnableSaveButton
  }

  override func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    switch indexPath {
    case datePickerIndexPath where isDatePickerHidden == true:
      return 0
    case notesIndexPath:
      return 200
    default:
      return UITableView.automaticDimension
    }
  }

  override func tableView(
    _ tableView: UITableView,
    estimatedHeightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    switch indexPath {
    case datePickerIndexPath:
      return 216
    case notesIndexPath:
      return 200
    default:
      return UITableView.automaticDimension
    }
  }

  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    tableView.deselectRow(at: indexPath, animated: true)
    if indexPath == dateLabelIndexPath {
      isDatePickerHidden.toggle()
      updateDueDateLabel(date: dueDateDatePicker.date)
      tableView.beginUpdates()
      tableView.endUpdates()
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    guard segue.identifier == "saveUnwind" else { return }

    let title = titleTextField.text!
    let isComplete = isCompleteButton.isSelected
    let dueDate = dueDateDatePicker.date
    let notes = notesTextView.text

    if toDo != nil {
      toDo?.title = title
      toDo?.isComplete = isComplete
      toDo?.dueDate = dueDate
      toDo?.notes = notes
    }
    else {
      toDo = ToDo(
        title: title,
        isComplete: isComplete,
        dueDate: dueDate,
        notes: notes
      )
    }
  }
}
