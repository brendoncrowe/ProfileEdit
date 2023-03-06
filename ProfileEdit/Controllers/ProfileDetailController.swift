//
//  ViewController.swift
//  ProfileEdit
//
//  Created by Brendon Crowe on 2/10/23.
//

import UIKit
import PhotosUI

class ProfileDetailController: UIViewController, ProfileEditControllerDelegate {
    
    @IBOutlet weak var profilePicBackground: UIView!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var userInfoBackgroundView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var editInfoButton: UIButton!
    
    var user: PhoneUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProfilePic()
        loadUser()
        editInfoButton.addTarget(self, action: #selector(presentEditController), for: .touchUpInside)
    }
    
    
    private func configureProfilePic() {
        profilePicBackground.layer.cornerRadius = profilePicBackground.layer.frame.width / 2
        profilePicImageView.layer.cornerRadius = profilePicImageView.layer.frame.width / 2
        userInfoBackgroundView.addTopRoundedCornerToView(targetView: userInfoBackgroundView, desiredCurve: 4.0)
    }
    
    func ProfileEditController(_ controller: ProfileEditController, didSaveUserInfo user: PhoneUser) {
        self.user = user
        loadUser()
    }
    
    private func loadUser() {
        guard let user = user else { return }
        nameLabel.text = user.name
        positionLabel.text = user.job
        phoneNumberLabel.text = user.phoneNumber
        emailLabel.text = user.email
        websiteLabel.text = user.website
        print("info laoded")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.source as? ProfileEditController else {
            fatalError("could not get ProfileEditController")
        }
        detailVC.delegate = self
    }
    
    @objc private func presentEditController() {
        guard let randomUserDetailController = storyboard?.instantiateViewController(withIdentifier: "ProfileEditController")
                as? ProfileEditController else {
            fatalError("could not load ProfileEditController")
        }
        if let sheet = randomUserDetailController.sheetPresentationController {
            sheet.detents = [ .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }
        present(randomUserDetailController, animated: true)
    }
}

extension UIView {
    
    func addTopRoundedCornerToView(targetView: UIView?, desiredCurve: CGFloat?) {
        let offset: CGFloat =  targetView!.frame.width/desiredCurve!
        let bounds: CGRect = targetView!.bounds
        
        let rectBounds: CGRect = CGRectMake(bounds.origin.x, bounds.origin.y + bounds.size.height / 2, bounds.size.width, bounds.size.height / 2)
        
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        let ovalBounds: CGRect = CGRectMake(bounds.origin.x - offset / 2, bounds.origin.y, bounds.size.width + offset, bounds.size.height)
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        
        // Create the shape layer and set its path
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        
        // Set the newly created shape layer as the mask for the view's layer
        targetView!.layer.mask = maskLayer
    }
}
