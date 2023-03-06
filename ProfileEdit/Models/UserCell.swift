//
//  UserCell.swift
//  ProfileEdit
//
//  Created by Brendon Crowe on 3/1/23.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var imageBackground: UIView!

    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        imageBackground.layer.cornerRadius = imageBackground.frame.size.width / 2
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.layer.borderWidth = 1
        userImageView.alpha = 0.9
    }
    
    func configureCell(for user: User) {
        let firstName = user.name.first
        let lastName = user.name.last
        let lastNameCharacter = lastName.first
        userNameLabel.text = "\(firstName.capitalized) \(lastNameCharacter!)."

        ImageFromAPIHelper.getImage(from: user.picture.large) { [weak self] result in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.userImageView.image = UIImage(systemName: "exclamationmark.triangle")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.userImageView.image = image
                }
            }
        }
    }
}
