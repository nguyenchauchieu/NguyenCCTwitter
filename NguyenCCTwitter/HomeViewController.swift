//
//  HomeViewController.swift
//  NguyenCCTwitter
//
//  Created by Nguyen Chau Chieu on 7/2/17.
//  Copyright © 2017 Nguyen Chau Chieu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var tweetTableView: UITableView!
    @IBOutlet var profileNavigationButton: UIBarButtonItem!
    
    var tweets = [Tweet]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTableView.delegate = self
        tweetTableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: .valueChanged)
        
        tweetTableView.insertSubview(refreshControl, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchTweets()
    }
    
    func fetchTweets() -> Void {
        TwitterClient.sharedInstance?.getTimelines(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tweetTableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) -> Void {
        fetchTweets()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailController = segue.destination as? TweetDetailViewController {
            let indexPath = tweetTableView.indexPathForSelectedRow!
            detailController.tweet = tweets[indexPath.row]
        }
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tweetTableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetTableViewCell
        cell.delegate = self
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension HomeViewController: TweetTableViewCellDelegate {
    func updateTweets(tweet: Tweet) {
        for index in 0...tweets.count - 1 {
            if tweets[index].id! == tweet.id! {
                tweets[index].isFavorited = tweet.isFavorited!
                tweets[index].isReTweeted = tweet.isReTweeted!
            }
        }
    }
    
    func updateTweetTable() {
        fetchTweets()
    }
}
