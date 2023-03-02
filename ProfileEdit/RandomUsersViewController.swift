//
//  UsersViewController.swift
//  ProfileEdit
//
//  Created by Brendon Crowe on 3/1/23.
//

import UIKit

class RandomUsersViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

extension RandomUsersViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath)
        return cell
    }
    
    
    
}

extension RandomUsersViewController: UICollectionViewDelegateFlowLayout {
    
    
    
}
