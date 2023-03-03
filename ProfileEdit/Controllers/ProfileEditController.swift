//
//  ProfileEditController.swift
//  ProfileEdit
//
//  Created by Brendon Crowe on 3/1/23.
//

import UIKit

class ProfileEditController: UIViewController {
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var profileImageBackground: UIView!
    
    var userInfo: PhoneUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureImageButton()
    }
    

    @IBAction func dissmissView(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    @IBAction func saveUserInfoButtonTapped(_ sender: UIBarButtonItem) {
    }
    
    private func configureImageButton() {
        profileImageBackground.layer.cornerRadius = 24
    }

    

}
