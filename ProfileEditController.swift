//
//  ProfileEditController.swift
//  ProfileEdit
//
//  Created by Brendon Crowe on 2/12/23.
//

import UIKit

protocol ProfileEditControllerDelegate {
    func updateInfo(for user: User)
}

class ProfileEditController: UIViewController {
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var siteTextField: UITextField!
    
    var user: User?
    var delegate: ProfileEditControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func configTextFields() {
        phoneTextField.delegate = self
        emailTextField.delegate = self
        siteTextField.delegate = self
    }
    
    func editInfo() {

    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        editInfo()
        if let user = user {
            delegate?.updateInfo(for: user)
        }
        dismiss(animated: true)
    }
}

extension ProfileEditController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
}
