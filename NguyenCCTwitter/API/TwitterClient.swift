//
//  TwitterClient.swift
//  NguyenCCTwitter
//
//  Created by Nguyen Chau Chieu on 7/2/17.
//  Copyright © 2017 Nguyen Chau Chieu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let baseUrl = URL(string: "https://api.twitter.com/")
let consumerKey = "8gaCG5mXE46EJiEsXQoqUtM5o"
let consumerSecret = "IXtYephLwG4H886jUeQW3wdzYj3iWapL8BSBzwyL77cTSG8zqw"

class TwitterClient: BDBOAuth1SessionManager {
    
    static var sharedInstance = TwitterClient(baseURL: baseUrl, consumerKey: consumerKey, consumerSecret: consumerSecret)
    
    var loginSuccess: (() -> Void)?
    var loginFailure: ((Error) -> Void)?
    
    func login(success: @escaping () -> Void, failure: @escaping (Error) -> Void ) -> Void {
        loginSuccess = success
        loginFailure = failure
        fetchRequestToken(withPath: "oauth/request_token", method: "POST", callbackURL: URL(string: "nguyencctwitter://"), scope: nil, success: { (response: BDBOAuth1Credential?) in
            if let response = response {
                
                let authUrl = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(response.token!)")
                print(response.token)
                print(authUrl!)
                UIApplication.shared.open(authUrl!, options: [:], completionHandler: nil)
            }
        }, failure: { (error: Error?) in
            if let error = error {
                print(error)
            }
        })
    }
    
    func handleUrl(url: URL) -> Void {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (response: BDBOAuth1Credential?) in
            if response != nil {
                self.loginSuccess?()
            }
        }, failure: { (error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                self.loginFailure?(error)
            }
        })
        
    }
    
    func getTimelines(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> () ) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            var tweets = [Tweet]()
            
            if let response = response {
                let responseDictionaries = response as! [NSDictionary]
                tweets = Tweet.tweetsWithArray(tweetDictionaies: responseDictionaries)
            }
            success(tweets)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func tweeting(tweetContent: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) -> Void {
        var params = [String : Any]()
        params["status"] = tweetContent
        post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            if let response = response {
                let tweet = Tweet(tweetDictionary: response as! NSDictionary)
                success(tweet)
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func favorite(tweetId: NSNumber, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) -> Void {
        var params = [String : Any]()
        params["id"] = tweetId
        post("1.1/favorites/create.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            if let response = response {
                let tweet = Tweet(tweetDictionary: response as! NSDictionary)
                success(tweet)
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func unFavorite(tweetId: NSNumber, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) -> Void {
        var params = [String : Any]()
        params["id"] = tweetId
        post("1.1/favorites/destroy.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            if let response = response {
                let tweet = Tweet(tweetDictionary: response as! NSDictionary)
                success(tweet)
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func retweet(tweetId: NSNumber, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) -> Void {
        post("1.1/statuses/retweet/\(tweetId).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            if let response = response {
                let tweet = Tweet(tweetDictionary: response as! NSDictionary)
                success(tweet)
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func unRetweet(tweetId: NSNumber, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) -> Void {
        post("1.1/statuses/unretweet/\(tweetId).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            if let response = response {
                let tweet = Tweet(tweetDictionary: response as! NSDictionary)
                success(tweet)
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
}
