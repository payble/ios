//
//  AppDelegate.h
//  kentApp
//
//  Created by pericent on 12/18/14.
//  Copyright (c) 2014 pericent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *navObj;
}

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,retain)NSString *urlString;
@end

