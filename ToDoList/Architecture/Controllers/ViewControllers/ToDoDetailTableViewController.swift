//
//  ToDoDetailTableViewController.swift
//  ToDoList
//
//  Created by Nune Melikyan on 27.09.22.
//

import UIKit

class ToDoDetailTableViewController: UITableViewController {

  @IBOutlet private var titleTextField: UITextField!
  @IBOutlet private var isCompleteButton: UIButton!
  @IBOutlet private var dueDateLabel: UILabel!
  @IBOutlet private var dueDateDatePicker: UIDatePicker!
  @IBOutlet private var notesTextView: UITextView!
  @IBOutlet private var saveButton: UIBarButtonItem!

  var isDatePickerHidden = true
  let dateLabelIndexPath = IndexPath(row: 0, section: 1)
  let datePickerIndexPath = IndexPath(row: 1, section: 1)
  let notesIndexPath = IndexPath(row: 0, section: 2)

  @IBAction func returnPressed(_ sender: UITextField) {
    sender.resignFirstResponder()
  }

  @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
    isCompleteButton.isSelected.toggle()
  }

  @IBAction func datePickerChanged(_ sender: UIDatePicker) {
    updateDueDateLabel(date: sender.date)
  }

  func updateDueDateLabel(date: Date) {
    dueDateLabel.text = date.formatted(
      .dateTime.month(.defaultDigits)
        .day().year(.twoDigits).hour().minute()
    )
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    dueDateDatePicker.date = Date().addingTimeInterval(24 * 60 * 60)
    updateDueDateLabel(date: dueDateDatePicker.date)
    updateSaveButtonState()
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
  }

  @IBAction func textEditingChanged(_ sender: UITextField) {
    updateSaveButtonState()
  }

  func updateSaveButtonState() {
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
}
