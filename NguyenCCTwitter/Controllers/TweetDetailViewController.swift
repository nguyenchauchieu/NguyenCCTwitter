//
//  TweetDetailViewController.swift
//  NguyenCCTwitter
//
//  Created by Nguyen Chau Chieu on 7/4/17.
//  Copyright © 2017 Nguyen Chau Chieu. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var replyImageView: UIImageView!
    @IBOutlet var reTweetImageView: UIImageView!
    @IBOutlet var reTweetCountLabel: UILabel!
    @IBOutlet var favoriteImageView: UIImageView!
    @IBOutlet var favoriteCountLabel: UILabel!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestures()

        authorLabel.text = tweet.authorName!
        avatarImageView.setImageWith((tweet.authorAvatarUrl!))
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.clipsToBounds = true
//        createdAtLabel.text = tweet.createdAt!
        contentLabel.text = tweet.text!
        screenNameLabel.text = "@\(tweet.screenName!)"

//        if let imageUrl = tweet.imageUrl {
//            tweetImageView.setImageWith(imageUrl)
//        } else {
//            tweetImageView.removeFromSuperview()
//        }
        
        if (tweet?.isFavorited!)! {
            favoriteImageView.image = UIImage(named: "like_icon")
        } else {
            favoriteImageView.image = UIImage(named: "unlike_icon")
        }
        
        if (tweet?.isReTweeted!)! {
            reTweetImageView.image = UIImage(named: "retweet_icon")
        } else {
            reTweetImageView.image  = UIImage(named: "un_retweet_icon")
        }
        reTweetCountLabel.text = "\(String(describing: tweet.reTweetCount!))"
        favoriteCountLabel.text = "\(String(describing: tweet.favoriteCount!))"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupGestures() -> Void {
        let favoriteGesture = UITapGestureRecognizer(target: self, action: #selector(didTapFavoriteButton(sender:)))
        favoriteImageView.addGestureRecognizer(favoriteGesture)
        favoriteImageView.isUserInteractionEnabled = true
        
        let reTweetGesture = UITapGestureRecognizer(target: self, action: #selector(didTapReTweetButton(sender:)))
        reTweetImageView.addGestureRecognizer(reTweetGesture)
        reTweetImageView.isUserInteractionEnabled = true
    }
    
    func didTapFavoriteButton(sender: Any) -> Void {
        if tweet.isFavorited! {
            TwitterClient.sharedInstance?.unFavorite(tweetId: tweet.id!, success: { (tweet: Tweet) in
                self.favoriteImageView.image = UIImage(named: "unlike_icon")
                let likeCount = Int(self.favoriteCountLabel.text!)
                self.favoriteCountLabel.text = "\(likeCount! - 1)"
                self.tweet.isFavorited = false
                
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.favorite(tweetId: tweet.id!, success: { (tweet: Tweet) in
                self.favoriteImageView.image = UIImage(named: "like_icon")
                let likeCount = Int(self.favoriteCountLabel.text!)
                self.favoriteCountLabel.text = "\(likeCount! + 1)"
                self.tweet.isFavorited = true
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
    }
    
    func didTapReTweetButton(sender: Any) -> Void {
        if tweet.isReTweeted! {
            TwitterClient.sharedInstance?.unRetweet(tweetId: tweet.id!, success: { (tweet: Tweet) in
                self.reTweetImageView.image  = UIImage(named: "un_retweet_icon")
                let reTweetCount = Int(self.reTweetCountLabel.text!)
                self.reTweetCountLabel.text = "\(reTweetCount! - 1)"
                self.tweet.isReTweeted = false
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.retweet(tweetId: tweet.id!, success: { (tweet: Tweet) in
                self.reTweetImageView.image = UIImage(named: "retweet_icon")
                let reTweetCount = Int(self.reTweetCountLabel.text!)
                self.reTweetCountLabel.text = "\(reTweetCount! + 1)"
                self.tweet.isReTweeted = true
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
    }

}
