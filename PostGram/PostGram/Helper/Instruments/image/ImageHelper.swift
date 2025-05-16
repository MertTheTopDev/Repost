//
//  ImageHelper.swift
//  PostGram
//
//  Created by Mert Türedü on 7.04.2025.
//

import Foundation

struct ImageHelper {
    
    enum image: String {
        case goProBanner = "goProBanner"
        case howRepost = "howRepost"
    }
    
    enum icon: String {
        case stars = "stars"
        case boldArrow = "boldArrow"
        case circleCancel = "circleCancel"
        
        //Navbar

        case hashtagSelected = "hashtagSelected"
        case hashtagUnselected = "hashtagUnselected"
        case repostSelected = "repostSelected"
        case repostUnselected = "repostUnselected"
        case settingsSelected = "settingsSelected"
        case settingsUnselected = "settingsUnselected"
        case storySelected = "storySelected"
        case storyUnselected = "storyUnselected"
    }
    
}
