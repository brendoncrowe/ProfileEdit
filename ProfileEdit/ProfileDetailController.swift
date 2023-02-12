//
//  ViewController.swift
//  ProfileEdit
//
//  Created by Brendon Crowe on 2/10/23.
//

import UIKit
import PhotosUI

class ProfileDetailController: UIViewController {
    
    @IBOutlet weak var profilePicBackground: UIView!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var userInfoBackgroundView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var editProfilePicButton: UIButton!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProfilePic()
        configureUserInfo()
    }
    
    func configureProfilePic() {
        profilePicBackground.layer.cornerRadius = profilePicBackground.layer.frame.width / 2
        profilePicImageView.layer.cornerRadius = profilePicImageView.layer.frame.width / 2
        userInfoBackgroundView.addTopRoundedCornerToView(targetView: userInfoBackgroundView, desiredCurve: 4.0)
        editProfilePicButton.layer.cornerRadius = editProfilePicButton.layer.frame.width / 2
    }
    
    func configureUserInfo() {
        let name = "Brendon Crowe"
        let position = "Programmer".uppercased()
        nameLabel.text = name
        positionLabel.text = position
        
    }
    
    func changeProfileImage() {
        var phpPickerConfig = PHPickerConfiguration()
        phpPickerConfig.filter = .images
        phpPickerConfig.selectionLimit = 1
        let controller = PHPickerViewController(configuration: phpPickerConfig)
        controller.delegate = self
        present(controller, animated: true)
    }
    
    
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        changeProfileImage()
    }
    
    
    @IBAction func dimissView(_ segue: UIStoryboardSegue) {
        dismiss(animated: true)
    }
    
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        // Create your child view controller
        lazy var detailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileEditController")
        if let sheet = detailController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(detailController, animated: true)
    }    
    
}

extension UIView {
    
    func addTopRoundedCornerToView(targetView: UIView?, desiredCurve: CGFloat?) {
        let offset:CGFloat =  targetView!.frame.width/desiredCurve!
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

extension ProfileDetailController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if !results.isEmpty {
            let result = results.first!
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let image = image as? UIImage else {
                        return
                    }
                    DispatchQueue.main.async {
                        self?.profilePicImageView.image = image
                    }
                }
            }
        }
        dismiss(animated: true)
    }
}
