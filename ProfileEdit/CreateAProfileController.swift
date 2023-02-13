//
//  CreateAProfileController.swift
//  ProfileEdit
//
//  Created by Brendon Crowe on 2/13/23.
//

import UIKit

class CreateAProfileController: UIViewController {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configBackground()
        configTextFieldDelegate()
    }
    
    func configBackground() {
        backgroundView.alpha = 0.8
        backgroundView.layer.cornerRadius = 25
    }
    
    func configTextFieldDelegate() {
        nameTextField.delegate = self
        jobTextField.delegate = self
        phoneTextField.delegate = self
        emailTextField.delegate = self
        websiteTextField.delegate = self
    }
    
    func createUser() {
        let name = nameTextField.text ?? ""
        let job = jobTextField.text ?? ""
        let phoneNumber = phoneTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let website = websiteTextField.text ?? "not available"
        
        let newUser = User(name: name, job: job, phoneNumber: phoneNumber, email: email, website: website)
        user = newUser
        
    }
    
    
    @IBAction func createButtonTapped(_ sender: UIButton) {
        createUser()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? ProfileDetailController else {
            fatalError("could not segue to ProfileDetailController")
        }
        detailVC.user = user
    }
    
    
    
}

extension CreateAProfileController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
}
