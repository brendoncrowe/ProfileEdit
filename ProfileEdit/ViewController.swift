//
//  ViewController.swift
//  ProfileEdit
//
//  Created by Brendon Crowe on 2/10/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var profilePicBackground: UIView!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var userInfoBackgroundView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var editProfilePicButton: UIButton!
    
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
