//
//  TweetTableViewCell.swift
//  NguyenCCTwitter
//
//  Created by Nguyen Chau Chieu on 7/2/17.
//  Copyright © 2017 Nguyen Chau Chieu. All rights reserved.
//

import UIKit

protocol TweetTableViewCellDelegate {
    func updateTweets(tweet: Tweet) -> Void
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
            if let imageUrl = tweet.imageUrl {
                tweetImageView.setImageWith(imageUrl)
            } else {
                tweetImageView.removeFromSuperview()
            }
            
            if (tweet?.isFavorited!)! {
                likeImageView.image = UIImage(named: "like_icon")
            } else {
                likeImageView.image = UIImage(named: "unlike_icon")
            }
            
            if (tweet?.isReTweeted!)! {
                reTweetImageView.image = UIImage(named: "retweet_icon")
            } else {
                reTweetImageView.image  = UIImage(named: "un_retweet_icon")
            }
            reTweetCountLabel.text = "\(String(describing: tweet.reTweetCount!))"
            likeCountLabel.text = "\(String(describing: tweet.favoriteCount!))"
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
                self.delegate.updateTweetTable()
                self.likeImageView.image = UIImage(named: "unlike_icon")
                let likeCount = Int(self.likeCountLabel.text!)
                self.likeCountLabel.text = "\(likeCount! - 1)"
                self.tweet.isFavorited = false
                
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.favorite(tweetId: tweet.id!, success: { (tweet: Tweet) in
                self.delegate.updateTweetTable()
                self.likeImageView.image = UIImage(named: "like_icon")
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
                self.delegate.updateTweetTable()
                self.reTweetImageView.image  = UIImage(named: "un_retweet_icon")
                let reTweetCount = Int(self.reTweetCountLabel.text!)
                self.reTweetCountLabel.text = "\(reTweetCount! - 1)"
                self.tweet.isReTweeted = false
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.retweet(tweetId: tweet.id!, success: { (tweet: Tweet) in
                self.delegate.updateTweetTable()
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
