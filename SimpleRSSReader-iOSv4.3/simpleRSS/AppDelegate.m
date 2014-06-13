//
//  AppDelegate.m
//  simpleRSS
//
//  Created by maxim.vasilkov@gmail.com on 29/05/14.
//

#import "AppDelegate.h"

#import "ChannelsViewController.h"
#import "CommonDeclarations.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSUserDefaults *udef = [NSUserDefaults standardUserDefaults];
    
    int loadedTimes = [udef integerForKey:KEY_LOAD_TIMES];
    if (loadedTimes<1) {
        NSMutableArray *defaultChannels = [NSMutableArray arrayWithObjects:
                                           @"http://vasilkoff.com/feed/",
                                           @"http://iphone.keyvisuals.com/feed/",
                                           @"http://feeds2.feedburner.com/MobileOrchard", nil];
        [udef setObject:defaultChannels forKey:KEY_CHANNELS];
    }
    loadedTimes++;
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.viewController = [[ChannelsViewController alloc] init];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    
    return YES;
}

@end
