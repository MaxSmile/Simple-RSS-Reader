//
//  ChannelsViewController.h
//  simpleRSS
//
//  Created by maxim.vasilkov@gmail.com on 29/05/14.
//

#import <UIKit/UIKit.h>


@interface ChannelsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSMutableArray *_list;
    UITableView *table;
}
@property (nonatomic,strong) NSMutableArray *list;

@end
