//
//  ToDoDetailTableViewController.swift
//  ToDoList
//
//  Created by Nune Melikyan on 27.09.22.
//

import MessageUI
import UIKit

final class ToDoDetailTableViewController: UITableViewController {

  @IBOutlet var titleTextField: UITextField!
  @IBOutlet var isCompleteButton: UIButton!
  @IBOutlet var dueDateLabel: UILabel!
  @IBOutlet var dueDateDatePicker: UIDatePicker!
  @IBOutlet var notesTextView: UITextView!
  @IBOutlet var saveButton: UIBarButtonItem!
  @IBOutlet private var shareButton: UIButton!

  private var isDatePickerHidden = true
  private let dateLabelIndexPath = IndexPath(row: 0, section: 1)
  private let datePickerIndexPath = IndexPath(row: 1, section: 1)
  private let notesIndexPath = IndexPath(row: 0, section: 2)

  var toDo: ToDo?

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

extension ToDoDetailTableViewController:
  MFMailComposeViewControllerDelegate
{

  // MARK: - Email actions
  @IBAction func sendEmail(_ sender: UIButton) {
    guard let title = toDo?.title,
      let isComplete = toDo?.isComplete,
      let dueDate = toDo?.dueDate
    else { return }

    let toDoDescription =
      "Title: \(title), isComplete: \(isComplete), duDate: \(dueDate)"
    // Modify following variables with your text / recipient
    let recipientEmail = "test@email.com"
    let subject = "Share To Do task: \(title)"

    let body =
      toDoDescription

    // Show default mail composer
    if MFMailComposeViewController.canSendMail() {
      let mail = MFMailComposeViewController()
      mail.mailComposeDelegate = self
      mail.setToRecipients([recipientEmail])
      mail.setSubject(subject)
      mail.setMessageBody(body, isHTML: false)

      present(mail, animated: true)

      // Show third party email composer if default Mail app is not present
    }
    else if let emailUrl = createEmailUrl(
      to: recipientEmail,
      subject: subject,
      body: body
    ) {
      UIApplication.shared.open(emailUrl)
    }
  }

  private func createEmailUrl(
    to: String,
    subject: String,
    body: String
  ) -> URL? {
    let subjectEncoded = subject.addingPercentEncoding(
      withAllowedCharacters: .urlQueryAllowed
    )!
    let bodyEncoded = body.addingPercentEncoding(
      withAllowedCharacters: .urlQueryAllowed
    )!

    let gmailUrl = URL(
      string:
        "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)"
    )
    let outlookUrl = URL(
      string:
        "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)"
    )
    let yahooMail = URL(
      string:
        "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)"
    )
    let sparkUrl = URL(
      string:
        "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)"
    )
    let defaultUrl = URL(
      string:
        "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)"
    )

    if let gmailUrl = gmailUrl,
      UIApplication.shared.canOpenURL(gmailUrl)
    {
      return gmailUrl
    }
    else if let outlookUrl = outlookUrl,
      UIApplication.shared.canOpenURL(outlookUrl)
    {
      return outlookUrl
    }
    else if let yahooMail = yahooMail,
      UIApplication.shared.canOpenURL(yahooMail)
    {
      return yahooMail
    }
    else if let sparkUrl = sparkUrl,
      UIApplication.shared.canOpenURL(sparkUrl)
    {
      return sparkUrl
    }

    return defaultUrl
  }

  func mailComposeController(
    _ controller: MFMailComposeViewController,
    didFinishWith result: MFMailComposeResult,
    error: Error?
  ) {
    controller.dismiss(animated: true)
  }

}
