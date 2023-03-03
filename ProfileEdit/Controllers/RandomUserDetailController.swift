//
//  RandomProfileDetailController.swift
//  ProfileEdit
//
//  Created by Brendon Crowe on 3/2/23.
//

import UIKit

class RandomUserDetailController: UIViewController {
    
    
    @IBOutlet weak var imageBackground: UIView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userJobLabel: UILabel!
    @IBOutlet weak var userPhoneNumberLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userWebsiteLabel: UILabel!
    
    @IBOutlet weak var userInfoBackgroundView: UIView!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProfilePic()
        loadUser()
    }
    
    @IBAction func dissMissRandomUser(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    func configureProfilePic() {
        imageBackground.layer.cornerRadius = imageBackground.layer.frame.width / 2
        userProfileImage.layer.cornerRadius = userProfileImage.layer.frame.width / 2
        imageBackground.addTopRoundedCornerToView(targetView: userInfoBackgroundView, desiredCurve: 4.0)

    }
    

    
    func loadUser() {
        if let user = user {
            userNameLabel.text = user.name.first.capitalized + " " + user.name.last.capitalized
            userEmailLabel.text = user.email
            userJobLabel.text = "Looking for job"
            userPhoneNumberLabel.text = user.phone
            userWebsiteLabel.text = "www.pleasehireme.com"
            ImageFromAPIHelper.getImage(from: user.picture.large) { [weak self] result in
                switch result {
                case .failure:
                    DispatchQueue.main.async {
                        self?.userProfileImage.image = UIImage(systemName: "exclamationmark.triangle")
                    }
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.userProfileImage.image = image
                    }
                }
            }
        }
    }
}

