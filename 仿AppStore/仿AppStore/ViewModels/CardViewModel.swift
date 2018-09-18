//
//  CardViewModel.swift
//  仿AppStore
//
//  Created by 谢汝 on 2018/9/15.
//  Copyright © 2018年 谢汝. All rights reserved.
//


import Foundation
import UIKit

enum CardViewMode {
    case full
    case card
}


enum CardViewType {
    case appOfTheDay(bgImage: UIImage, bgType: BackgroundType?, app:AppViewModel)
    case appCollection(apps: [AppViewModel], title: String, subtitle: String)
    case appArical(bgImage: UIImage, bgType: BackgroundType?, title:String, subtitle:String, description: String, app: AppViewModel)
    
    var backgroundImage: UIImage? {
        switch self {
        case .appOfTheDay(let bgImage, _ , _), .appArical(let bgImage, _, _, _, _, _):
            return bgImage;
        default:
            return nil
        }
    }
    
}



class CardViewModel {
    var viewMode: CardViewMode = .card
    let viewType: CardViewType
    var title: String? = nil
    var subtitle: String? = nil
    var description: String? = nil
    var app: AppViewModel? = nil
    var appCollection: [AppViewModel]? = nil
    var backgroundImage: UIImage? = nil
    var backgroundType: BackgroundType = .light
    
    
    init(viewType: CardViewType) {
        self.viewType = viewType
        
        switch viewType {
        case .appArical(let bgImage, let bgType, let title, let subtitle, let description, let app):
            self.backgroundImage = bgImage
            self.title = title
            self.subtitle = subtitle
            self.description = description
            self.app = app
            self.backgroundType = bgType ?? .light
        case .appOfTheDay(let bgImage, let bgType, let app):
            self.backgroundImage = bgImage
            self.app = app
            self.backgroundType = bgType ?? .light
        case .appCollection(let apps, let title, let subtitle):
            self.appCollection = apps
            self.title = title
            self.subtitle = subtitle

        }
        
        
        
        
    }
    
    
    
}






