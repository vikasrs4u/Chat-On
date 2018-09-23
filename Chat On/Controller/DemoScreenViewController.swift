//
//  DemoScreenViewController.swift
//  Chat On
//
//  Created by Vikas R S on 9/22/18.
//  Copyright © 2018 Vikas Radhakrishna Shetty. All rights reserved.
//

import UIKit
import paper_onboarding


class DemoScreenViewController: UIViewController {
    
    
    @IBOutlet weak var doneButtonOutlet: UIButton!
    
    @IBOutlet weak var onBoardViewOutlet: OnboardingViewClass!
    var userDefaults = UserDefaults.standard
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        onBoardViewOutlet.dataSource = self
        onBoardViewOutlet.delegate = self
        doneButtonOutlet.titleLabel?.font = UIFont(name: ".SFUIText-Medium", size: 15)!
        doneButtonOutlet.isHidden = true
        
        
        
        
    }
    
    @IBAction func doneButtonClickAction(_ sender: UIButton)
    {
        userDefaults.setValue(true, forKey:"isOnBoardingCompleted")
        
        //synchronize() will commit the data else data wont be saved
        userDefaults.synchronize()
    }
    
    
}

extension DemoScreenViewController:PaperOnboardingDataSource,PaperOnboardingDelegate
{
    func onboardingItemsCount() -> Int
    {
        return 3
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo
    {
        
        if (index == 0)
        {
            doneButtonOutlet.isHidden = true
            return OnboardingItemInfo(informationImage:UIImage(named:"Image1")!,
                                      title: "Allow Notifications!!!",
                                      description: "This will allow you to get notifications when your friends message in the group.",
                                      pageIcon: UIImage(named:"OnboardBackground")!,
                                      color: UIColor.white,
                                      titleColor: UIColor.black,
                                      descriptionColor: UIColor.black,
                                      titleFont: UIFont(name: ".SFUIText-Medium", size: 25)!,
                                      descriptionFont:UIFont(name: ".SFUIText", size: 15)!)
            
        }
        else if (index == 1)
        {
            doneButtonOutlet.isHidden = true
            return OnboardingItemInfo(informationImage:UIImage(named:"Image2")!,
                                      title: "Easy Sign Up",
                                      description: "You can upload your profile photo as well.",
                                      pageIcon: UIImage(named:"OnboardBackground")!,
                                      color: UIColor.white,
                                      titleColor: UIColor.black,
                                      descriptionColor: UIColor.black,
                                      titleFont: UIFont(name: ".SFUIText-Medium", size: 25)!,
                                      descriptionFont:UIFont(name: ".SFUIText", size: 15)!)
            
        }
        else
        {
            doneButtonOutlet.isHidden = false
            return OnboardingItemInfo(informationImage:UIImage(named:"Image3")!,
                                      title: "Chat On!!!",
                                      description: "",
                                      pageIcon: UIImage(named:"OnboardBackground")!,
                                      color: UIColor.white,
                                      titleColor: UIColor.black,
                                      descriptionColor: UIColor.black,
                                      titleFont: UIFont(name: ".SFUIText-Medium", size: 20)!,
                                      descriptionFont:UIFont(name: ".SFUIText", size: 15)!)
            
        }
        
        
    }
    
    
    func onboardingWillTransitonToIndex(_ index: Int)
    {
        if (index == 0)
        {
            doneButtonOutlet.isHidden = true
            
        }
        else if (index == 1)
        {
            doneButtonOutlet.isHidden = true
            
        }
        else
        {
            doneButtonOutlet.isHidden = false
            
        }
    }
    
    
    func onboardingConfigurationItem(_: OnboardingContentViewItem, index _: Int) {
        
    }
    
    
}
