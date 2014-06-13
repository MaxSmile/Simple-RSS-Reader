//
//  AppDelegate.h
//  simpleRSS
//
//  Created by maxim.vasilkov@gmail.com on 29/05/14.
//

#import <UIKit/UIKit.h>

@class ChannelsViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ChannelsViewController *viewController;

@end
