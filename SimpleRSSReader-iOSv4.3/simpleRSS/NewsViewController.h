//
//  NewsViewController.h
//  simpleRSS
//
//  Created by maxim.vasilkov@gmail.com on 29/05/14.
//

#import <UIKit/UIKit.h>


@interface NewsViewController : UIViewController <NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *_feeds;
    NSXMLParser *_parser;
    NSString *_channelUrl;
    NSString *_currentElement;
    UITableView *tableView;
    UIView *activityIndicator;
}
@property (nonatomic,strong) NSMutableArray *feeds;
@property (nonatomic,strong) NSXMLParser *parser;
@property (nonatomic,strong) NSString *channelUrl;
@property (nonatomic,strong) NSString *element;


@end
