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
}
@property (nonatomic,strong) NSString *feedLink;
@property (nonatomic,strong) NSString *feedTitle;
@property (nonatomic,strong) IBOutlet UIWebView *webView;
@property (nonatomic,strong) IBOutlet UINavigationBar *navBar;
@property (nonatomic,strong) IBOutlet UIView *activityIndicator;

@end
