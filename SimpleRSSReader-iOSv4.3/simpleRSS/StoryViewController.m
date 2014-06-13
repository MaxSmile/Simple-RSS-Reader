//
//  StoryViewController.m
//  simpleRSS
//
//  Created by maxim.vasilkov@gmail.com on 29/05/14.
//

#import "StoryViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CommonDeclarations.h"



@implementation StoryViewController

@synthesize feedLink=_feedLink;
@synthesize feedTitle=_feedTitle;



- (void) loadView {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.view = [[UIView alloc] initWithFrame:bounds];
    self.view.layer.backgroundColor = [UIColor grayColor].CGColor;
    
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, UINAVBAR_HEIGHT, bounds.size.width, bounds.size.height-UINAVBAR_HEIGHT-BANNER_HEIGHT)];
    [self.view addSubview:webView];
    webView.delegate = self;
    NSURL *myURL = [NSURL URLWithString: [self.feedLink stringByAddingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [webView loadRequest:request];
  
    
    navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, UINAVBAR_HEIGHT)];
    [self.view addSubview:navBar];
    
    UINavigationItem *top = [[UINavigationItem alloc] initWithTitle:@"Story"];
    [navBar pushNavigationItem:top animated:NO];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    [top setLeftBarButtonItem:back];
    
    
    
    
    CGPoint center = self.view.center;
    activityIndicator = [[UIView alloc] initWithFrame:CGRectMake(center.x,
                                                                 center.y,
                                                                 ACTIVITY_INDICATOR_WIDTH,
                                                                 ACTIVITY_INDICATOR_HEIGHT)];
    activityIndicator.layer.backgroundColor = [UIColor blackColor].CGColor;
    activityIndicator.layer.masksToBounds = YES;
    activityIndicator.layer.cornerRadius = 10;
    activityIndicator.center = self.view.center;
    [self.view addSubview:activityIndicator];
    UIActivityIndicatorView *wheel = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    wheel.frame = CGRectMake(0, 0, ACTIVITY_INDICATOR_WIDTH, ACTIVITY_INDICATOR_HEIGHT);
    [activityIndicator addSubview:wheel];
    [wheel startAnimating];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    navBar.topItem.title = self.feedTitle;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    activityIndicator.hidden = YES;
}


#pragma mark -
-(IBAction) back {
    [self dismissModalViewControllerAnimated:YES];
}

@end
