//
//  TweetTableViewCell.swift
//  NguyenCCTwitter
//
//  Created by Nguyen Chau Chieu on 7/2/17.
//  Copyright © 2017 Nguyen Chau Chieu. All rights reserved.
//

import UIKit

protocol TweetTableViewCellDelegate {
    func updateTweetTable() -> Void
}

class TweetTableViewCell: UITableViewCell {

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var authorNameLabel: UILabel!
    @IBOutlet var createdAtLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var tweetImageView: UIImageView!
    @IBOutlet var replyImageView: UIImageView!
    @IBOutlet var replyCountLabel: UILabel!
    @IBOutlet var reTweetImageView: UIImageView!
    @IBOutlet var reTweetCountLabel: UILabel!
    @IBOutlet var likeImageView: UIImageView!
    @IBOutlet var likeCountLabel: UILabel!
    
    var delegate: TweetTableViewCellDelegate!
    
    var tweet: Tweet! {
        didSet{
            authorNameLabel.text = tweet.authorName!
            avatarImageView.setImageWith((tweet.authorAvatarUrl!))
            avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
            avatarImageView.clipsToBounds = true
            createdAtLabel.text = tweet.createdAt!
            contentLabel.text = tweet.text!
            replyCountLabel.text = "Reply"
            reTweetCountLabel.text = "\(String(describing: tweet.reTweetCount!))"
            likeCountLabel.text = "\(String(describing: tweet.favoriteCount!))"
            if let imageUrl = tweet.imageUrl {
                tweetImageView.setImageWith(imageUrl)
            } else {
                tweetImageView.removeFromSuperview()
            }
            
            if (tweet?.isFavorited!)! {
                likeImageView.image = UIImage(named: "like_icon")
                likeCountLabel.textColor = UIColor(red: 229/255, green: 42/255, blue: 82/255, alpha: 1)
            } else {
                likeImageView.image = UIImage(named: "unlike_icon")
                likeCountLabel.textColor = UIColor(red: 170/255, green: 184/255, blue: 193/255, alpha: 1)
            }
            
            if (tweet?.isReTweeted!)! {
                reTweetImageView.image = UIImage(named: "retweet_icon")
                reTweetCountLabel.textColor = UIColor(red: 46/255, green: 204/255, blue: 137/255, alpha: 1)
            } else {
                reTweetImageView.image  = UIImage(named: "un_retweet_icon")
                likeCountLabel.textColor = UIColor(red: 170/255, green: 184/255, blue: 193/255, alpha: 1)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGestures()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupGestures() -> Void {
        let favoriteGesture = UITapGestureRecognizer(target: self, action: #selector(didTapFavoriteButton(sender:)))
        likeImageView.addGestureRecognizer(favoriteGesture)
        likeImageView.isUserInteractionEnabled = true
        
        let reTweetGesture = UITapGestureRecognizer(target: self, action: #selector(didTapReTweetButton(sender:)))
        reTweetImageView.addGestureRecognizer(reTweetGesture)
        reTweetImageView.isUserInteractionEnabled = true
    }
    
    func didTapFavoriteButton(sender: Any) -> Void {
        if tweet.isFavorited! {
            TwitterClient.sharedInstance?.unFavorite(tweetId: tweet.id!, success: { (tweet: Tweet) in
//                self.delegate.updateTweetTable()
                self.likeImageView.image = UIImage(named: "unlike_icon")
                self.likeCountLabel.textColor = UIColor(red: 170/255, green: 184/255, blue: 193/255, alpha: 1)
                let likeCount = Int(self.likeCountLabel.text!)
                self.likeCountLabel.text = "\(likeCount! - 1)"
                self.contentLabel.text = "aas"
                self.tweet.isFavorited = false
                
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.favorite(tweetId: tweet.id!, success: { (tweet: Tweet) in
//                self.delegate.updateTweetTable()
                self.likeImageView.image = UIImage(named: "like_icon")
                self.likeCountLabel.textColor = UIColor(red: 229/255, green: 42/255, blue: 82/255, alpha: 1)
                let likeCount = Int(self.likeCountLabel.text!)
                self.likeCountLabel.text = "\(likeCount! + 1)"
                self.tweet.isFavorited = true
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
    }
    
    func didTapReTweetButton(sender: Any) -> Void {
        if tweet.isReTweeted! {
            TwitterClient.sharedInstance?.unRetweet(tweetId: tweet.id!, success: { (tweet: Tweet) in
//                self.delegate.updateTweetTable()
                self.reTweetImageView.image  = UIImage(named: "un_retweet_icon")
                self.likeCountLabel.textColor = UIColor(red: 170/255, green: 184/255, blue: 193/255, alpha: 1)
                let reTweetCount = Int(self.reTweetCountLabel.text!)
                self.reTweetCountLabel.text = "\(reTweetCount! - 1)"
                self.tweet.isReTweeted = false
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.retweet(tweetId: tweet.id!, success: { (tweet: Tweet) in
//                self.delegate.updateTweetTable()
                self.reTweetImageView.image = UIImage(named: "retweet_icon")
                self.reTweetCountLabel.textColor = UIColor(red: 46/255, green: 204/255, blue: 137/255, alpha: 1)
                let reTweetCount = Int(self.reTweetCountLabel.text!)
                self.reTweetCountLabel.text = "\(reTweetCount! + 1)"
                self.tweet.isReTweeted = true
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        }
    }
}
