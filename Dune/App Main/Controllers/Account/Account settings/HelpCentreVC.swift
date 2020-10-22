//
//  HelpCenterVC.swift
//  Dune
//
//  Created by Waylan Sands on 6/7/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class HelpCentreVC: UIViewController {
    
    var FAQsView: FAQView!
    
    var questionOne = "What type of channel to create"
    var answerOne = """
Think about something you can provide that's unique and provides entertaining or informative insight on your topic of choice. This could be your unique point of view, your vast knowledge or just information as it comes to hand.

Choose something you can talk about day to day and let people know in your summary or intro how often they will receive updates.
"""
    
    var questionTwo = "How to gain more subscribers"
    var answerTwo = """
Uploading an attractive profile image is one of the best ways to draw attention to your channel. Make sure you record an intro that explains how people will benefit from subscribing.

Releasing entertaining, informative content on a regular basis is essential to not only gaining subscribers but retaining them.

Like to know what they think of your episodes or ideas for future content? Ask them to comment.

Pro tip - Channels with more subscribers and high Cred rank higher than other channels which means they show up more in search results. One of the best ways to grow you subscribers is by sharing your channel through your own network.

"""
    
    var questionThree = "How to save an episode"
    var answerThree = #"""
At this time you are only able to save episodes you have recorded before publishing them.

After recording an episode select the "Next" button. If you would like to save the episode to publish at a later date you are able to press "Save" in the top-right section of the nav-bar.

If you would like to save any published episode to your account please mention within the feedback section and we will make this a priority going forward.
"""#
    
    var questionFour = "What is Cred"
    var answerFour = """
Currently Cred is a rating system to help potential subscribers understand the popularity of a channel. Channels with higher Cred are more visible than other channels - they appear more often in searches.

A channel with a lot of subscribers isn’t necessarily a great channel. A channel with high Cred is active, posting regularly and with content that has a high engagement.

You may build Cred in a few ways: Completing tasks within the app such as adding an intro, posting your first episode, receiving likes on your episodes, people upvoting your comments.

Cred may take on more roles in the future such as doubling as an in-app currency.
"""
    
    var questionFive = "How to publish an episode"
    var answerFive = #"""
You may either upload an audio file through the app or make a recording within the studio. Episodes have a minimum length of 10 seconds and a max of 120. Uploaded files that extend the limit will need to be trimmed.

After you have made your recording a "Next" button will appear in the top-right section of the  Nav-bar. Selecting that will take you to the details screen where you include a caption and optional tags. If all is complete you will have the option select the publish button or save the episode to publish at a later date.
"""#
    
    var questionSix = "How to add rich links to an episode"
    var answerSix = """
Rich links are hyperlinks that are displayed with an image and title.

To include a rich link with an episode, add a link within the link option field when publishing your episode.

After you have added the link turn on the toggle. If you publish your episode with the toggle off the link will not be displayed.
"""
    
    var questionSeven = "How to edit an episode"
    var answerSeven = "You may edit your own episodes by selecting the settings-icon on the top right of each episode. At this time  you are only able to edit the caption, tags and optional link."
    
    var questionEight = "How to report an episode"
    var answerEight = """
If you believe an episode has violated Dune's policies, you may find the report button within the episode settings which are displayed when selecting the icon at the top right of each episode.

Once you report an episode a Dune team member will investigate further.
"""
    
    var questionNine = "How to report a channel"
    var answerNine = """
If you believe a program has violated Dune's policies, you may find the report button within the program settings which are displayed when selecting the icon at the top right of each account.
    
    Once you report a channel a Dune team member will investigate further.
"""
    
    var questionTen = "How to view your subscribers"
    var answerTen = "If you select your subscribers count button within your channel you will be able to  see a list of all your current subscribers."
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        nav.backgroundColor = CustomStyle.blackNavBar
        nav.titleLabel.text = "Help Centre"
        return nav
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFAQ()
        configureView()
    }
    
    func configureFAQ(){
        let items = [FAQItem(question: questionOne, answer: answerOne),
                     FAQItem(question: questionTwo, answer: answerTwo),
                     FAQItem(question: questionThree, answer: answerThree),
                     FAQItem(question: questionFour, answer: answerFour),
                     FAQItem(question: questionFive, answer: answerFive),
                     FAQItem(question: questionSix, answer: answerSix),
                     FAQItem(question: questionSeven, answer: answerSeven),
                     FAQItem(question: questionEight, answer: answerEight),
                     FAQItem(question: questionNine, answer: answerNine),
                     FAQItem(question: questionTen, answer: answerTen)
        ]
        FAQsView = FAQView(frame: view.frame, items: items)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dunePlayBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         dunePlayBar.isHidden = false
    }
    
    func configureView() {
        view.addSubview(FAQsView)
        FAQsView.translatesAutoresizingMaskIntoConstraints = false
        FAQsView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        FAQsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        FAQsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        FAQsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -duneTabBar.frame.height).isActive = true
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
}
