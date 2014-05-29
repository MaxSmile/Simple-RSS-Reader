//
//  StoryViewController.m
//  simpleRSS
//
//  Created by maxim.vasilkov@gmail.com on 29/05/14.
//

#import "StoryViewController.h"
#import <QuartzCore/QuartzCore.h>




@implementation StoryViewController

@synthesize navBar,activityIndicator;
@synthesize feedLink=_feedLink;
@synthesize feedTitle=_feedTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.topItem.title = self.feedTitle;
    NSURL *myURL = [NSURL URLWithString: [self.feedLink stringByAddingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [self.webView loadRequest:request];
    self.activityIndicator.layer.backgroundColor = [UIColor blackColor].CGColor;
    self.activityIndicator.layer.masksToBounds = YES;
    self.activityIndicator.layer.cornerRadius = 10;
    self.activityIndicator.center = self.webView.center;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.activityIndicator.hidden = YES;
}


#pragma mark -
-(IBAction) back {
    [self dismissModalViewControllerAnimated:YES];
}

@end
