//
//  HomeTableViewCell.swift
//  FlickrClone
//
//  Created by Oğulcan Tamyürek on 19.10.2022.
//

import UIKit
import Kingfisher

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var likeStatus: Bool = false {
        didSet {
            if #available(iOS 13.0, *) {
                if likeStatus {
                    likeButton.imageView?.image = UIImage(systemName: "heart.fill")
                } else {
                    likeButton.imageView?.image = UIImage(systemName: "heart")
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    var favStatus: Bool = false {
        didSet {
            if #available(iOS 13.0, *) {
                if favStatus {
                    favouriteButton.imageView?.image = UIImage(systemName: "star.fill")
                } else {
                    favouriteButton.imageView?.image = UIImage(systemName: "star")
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //https://live.staticflickr.com/{server-id}/{id}_{secret}.jpg
    func configureCell(with photo: Photo, index: Int) {
        let urlString = "https://live.staticflickr.com/\(photo.server!)/\(photo.id!)_\(photo.secret!).jpg"
        let url = URL(string: urlString)
        mainImageView.kf.setImage(with: url)
        userNameLabel.text = photo.owner
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        likeStatus.toggle()
    }
    @IBAction func favButtonTapped(_ sender: Any) {
        favStatus.toggle()
    }
    
}
