//
//  ToDoCell.swift
//  ToDoList
//
//  Created by Nune Melikyan on 28.09.22.
//

import UIKit

protocol ToDoCellDelegate: AnyObject {
    func checkmarkTapped(_ sender: ToDoCell)
}

final class ToDoCell: UITableViewCell {
    
  weak var delegate: ToDoCellDelegate?

  @IBOutlet weak var isCompleteButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        delegate?.checkmarkTapped(self)
    }
}
