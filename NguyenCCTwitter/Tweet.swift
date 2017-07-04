//
//  Tweet.swift
//  NguyenCCTwitter
//
//  Created by Nguyen Chau Chieu on 7/2/17.
//  Copyright © 2017 Nguyen Chau Chieu. All rights reserved.
//

import Foundation
import NSDate_TimeAgo

struct Tweet {
    
    var id: NSNumber?
    var isReTweeted: Bool?
    var reTweetCount: Int?
    var isFavorited: Bool?
    var favoriteCount: Int?
    var text: String?
    var imageUrl: URL?
    var createdAt: String?
    var authorName: String?
    var authorAvatarUrl: URL?
    var screenName: String?
    
    
    init(tweetDictionary: NSDictionary) {
        self.id = tweetDictionary["id"] as? NSNumber
        self.isReTweeted = tweetDictionary["retweeted"] as? Bool
        self.reTweetCount = tweetDictionary["retweet_count"] as? Int
        self.isFavorited = tweetDictionary["favorited"] as? Bool
        self.favoriteCount = tweetDictionary["favorite_count"] as? Int
        self.text = tweetDictionary["text"] as? String
        self.screenName = tweetDictionary.value(forKeyPath: "user.screen_name") as? String
        
        if let media = tweetDictionary.value(forKeyPath: "entities.media") as? [NSDictionary] {
                if let imagePath = media[0]["media_url_https"] as? String {
                    self.imageUrl = URL(string: imagePath)
                }
        }
        let createdTimeString = tweetDictionary["created_at"] as? String
        var createdTime: NSDate?
        if let createTimeString = createdTimeString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            createdTime = formatter.date(from: createTimeString)!
                as NSDate
        }
        
        self.authorName = tweetDictionary.value(forKeyPath: "user.name") as? String
        self.authorAvatarUrl = URL(string: (tweetDictionary.value(forKeyPath: "user.profile_image_url_https") as? String)!)
        self.createdAt = createdTime?.timeAgo()
    }
    
    static func tweetsWithArray(tweetDictionaies: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for tweet in tweetDictionaies {
            tweets.append(Tweet(tweetDictionary: tweet))
        }
        
        return tweets
    }

}
