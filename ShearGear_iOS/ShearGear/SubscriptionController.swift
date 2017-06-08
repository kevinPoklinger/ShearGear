//
//  SubscriptionController.swift
//  ShearGear
//
//  Created by Kevin on 5/25/17.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class SubscriptionController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var subscriptionListView: UITableView!
    
    var subscriptions = ["Variety Surprise $45", "Variety Deluxe $69"]
    var details = ["This pack includes a mix of EXCLUSIVE shears and thinning shears in the most popular grooming sizes. Unlike the competition we design and make our own shears so you can be sure that you do not receive cheap generic shears.", "This pack includes a mix of EXCLUSIVE shears and thinning shears in the most popular grooming sizes. Unlike the competition we design and make our own shears so you can be sure that you do not receive cheap generic shears.", "This pack includes a mix of EXCLUSIVE shears and thinning shears in the most popular grooming sizes. Unlike the competition we design and make our own shears so you can be sure that you do not receive cheap generic shears."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscriptionListView.estimatedRowHeight = 200
        subscriptionListView.rowHeight = UITableViewAutomaticDimension
        subscriptionListView.delaysContentTouches = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subscriptionCell", for: indexPath) as! SubscriptionCell
        cell.subscription.text = subscriptions[indexPath.row]
        cell.detail.text = details[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = [subscriptions[indexPath.row], details[indexPath.row]]
        self.performSegue(withIdentifier: "productDetail", sender: info)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destController:ProductDetailController = segue.destination as! ProductDetailController
        destController.subscriptionText = (sender as! [String])[0]
        destController.descriptionText = (sender as! [String])[1]
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
