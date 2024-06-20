//
//  ViewController.swift
//  Project2
//
//  Created by Batchu Lakshmi Alekhya on 12/06/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    var strings = ["\'Food\'", "\'Restaurants\'", "\'Groceries\'", "\'Beverages\'", "\'Bread\'", "\'Pizza\'", "\'Biryani\'", "\'Burger\'", "\'Bajji\'", "\'Noodles\'", "\'Soup\'", "\'Sandwich\'", "\'Biscuits\'", "\'Chocolates\'"]
    var index = 1
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.tintColor = UIColor.black
        
        // Create the search icon image view
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .gray
        searchIcon.contentMode = .scaleAspectFit
        
        // Add padding to the image view
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        searchIcon.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
        paddingView.addSubview(searchIcon)
        
        // Set the image view as the left view of the text field
        searchField.leftView = paddingView
        searchField.leftViewMode = .always
        searchField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        searchField.becomeFirstResponder()
        
        animateListOfLabels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchField.layer.shadowColor = UIColor.black.cgColor
        searchField.layer.shadowOffset = CGSize(width: 0, height: 2)
        searchField.layer.shadowOpacity = 0.5
        searchField.layer.shadowRadius = 4.0
        searchField.layer.masksToBounds = false
    }
    
    @objc func textFieldDidChange() {
        if let text = searchField.text, !text.isEmpty {
            searchView.isHidden = true
            stopTimer()
        } else {
            searchView.isHidden = false
            resumeTimer()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func resumeTimer() {
        currentLabel.text = strings[index-1]
        timer = Timer.scheduledTimer(
            timeInterval: 2,
            target: self,
            selector: #selector(updateLabels),
            userInfo: nil,
            repeats: true
        )
    }
    
    func animateListOfLabels() {
        currentLabel.text = strings[index-1]
        nextLabel.alpha = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateLabels), userInfo: nil, repeats: true)
    }
    
    @objc func updateLabels() {
        if index < strings.count {
            nextLabel.text = strings[index]
            nextLabel.alpha = 0
            nextLabel.transform = CGAffineTransform(translationX: 0, y: searchView.frame.height / 2)
            
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.currentLabel.alpha = 0
                self.currentLabel.transform = CGAffineTransform(translationX: 0, y: -self.searchView.frame.height / 2)
                self.nextLabel.alpha = 1
                self.nextLabel.transform = .identity
            }, completion: { _ in
                // Swap the labels
                self.currentLabel.text = self.nextLabel.text
                self.currentLabel.alpha = 1
                self.currentLabel.transform = .identity
                
                // Reset next label
                self.nextLabel.alpha = 0
                self.nextLabel.transform = CGAffineTransform(translationX: 0, y: self.searchView.frame.height / 2)
            })
            
            index += 1
        } else {
            // Invalidate the timer once all strings are displayed
            timer?.invalidate()
        }
    }
}
