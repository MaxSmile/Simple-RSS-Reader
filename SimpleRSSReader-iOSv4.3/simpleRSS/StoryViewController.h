//
//  StoryViewController.h
//  simpleRSS
//
//  Created by maxim.vasilkov@gmail.com on 29/05/14.
//

#import <UIKit/UIKit.h>


@interface StoryViewController : UIViewController<UIWebViewDelegate> {
    NSString *_feedLink;
    NSString *_feedTitle;
    UINavigationBar *navBar;
    UIWebView *webView;
    UIView *activityIndicator;
}
@property (nonatomic,strong) NSString *feedLink;
@property (nonatomic,strong) NSString *feedTitle;

@end
