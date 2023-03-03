//
//  UsersViewController.swift
//  ProfileEdit
//
//  Created by Brendon Crowe on 3/1/23.
//

import UIKit

class RandomUsersViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var users = [User]() {
        didSet {
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        loadData()
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func loadData() {
        RandomUserAPIClient.getUsers { result in
            switch result {
            case .failure(let appError):
                print("Could not load users: \(appError.description)")
            case.success(let users):
                DispatchQueue.main.async {
                    self.users = users
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController, let detailVC = navController.viewControllers.first as? RandomUserDetailController, let cell = sender as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: cell) else {
            fatalError("could not load RandomProfileDetailController")
        }
        detailVC.user = users[indexPath.row]
    }
}

extension RandomUsersViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as? UserCell else {
            fatalError("could not dequeue a UserCell")
        }
        let user = users[indexPath.row]
        cell.configureCell(for: user)
        return cell
    }
    
    
    
}

extension RandomUsersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interItemSpacing: CGFloat = 10
        let maxWidth: CGFloat = (view.window?.windowScene?.screen.bounds.width)!
        let numberOfItems: CGFloat = 3
        let totalSpacing: CGFloat = numberOfItems * interItemSpacing
        let itemWidth: CGFloat = (maxWidth - totalSpacing) / numberOfItems
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
