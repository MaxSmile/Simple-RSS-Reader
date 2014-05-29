//
//  ChannelsViewController.m
//  simpleRSS
//
//  Created by maxim.vasilkov@gmail.com on 29/05/14.
//

#import "ChannelsViewController.h"
#import "CommonDeclarations.h"
#import "NewsViewController.h"

@implementation ChannelsViewController

@synthesize list=_list;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.list = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_CHANNELS];
    }
    return self;
}


#pragma mark UITableSourceDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellChannel";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    [cell.textLabel setText:[self.list objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark UITableDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *channelUrl = [self.list objectAtIndex:indexPath.row];
    NSLog(@"Row index %d was selected, channel %@",indexPath.row,channelUrl);
    NewsViewController *newsVC = nil;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        newsVC = [[NewsViewController alloc] initWithNibName:@"NewsViewController_iPhone" bundle:nil];
    } else {
        newsVC = [[NewsViewController alloc] initWithNibName:@"NewsViewController_iPad" bundle:nil];
    }
    if (newsVC!=nil) {
        newsVC.channelUrl = channelUrl;
        [self presentModalViewController:newsVC animated:YES];
    }

    
}

@end
