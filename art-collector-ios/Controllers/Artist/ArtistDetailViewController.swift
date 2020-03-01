//
//  ArtistDetailViewController.swift
//  art-collector-ios
//
//  Created by Luke Fitzgerald on 2/28/20.
//  Copyright © 2020 Luke Fitzgerald. All rights reserved.
//

import UIKit

class ArtistDetailViewController: UIViewController {
    
    
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var artistInfo: UILabel!
    @IBOutlet weak var biography: UILabel!

    var artist: Artist?
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstName.text = artist?.firstName
        lastName.text = artist?.lastName
        artistInfo.text = artist?.additionalInfo
        biography.text = artist?.biography
        
//        loadImage(url: artist?.artistImage?.url!)
    }
    
//    private func loadImage(url: String) {
//        UIImageView.load(url: "")
//    }
}

//extension UIImageView {
//    func load(url: URL) {
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}
