//
//  ChannelsViewController.m
//  simpleRSS
//
//  Created by maxim.vasilkov@gmail.com on 29/05/14.
//

#import "ChannelsViewController.h"
#import "CommonDeclarations.h"
#import "NewsViewController.h"
#import "StoryViewController.h"



@implementation ChannelsViewController

@synthesize list=_list;

- (void) loadView {
    [super loadView];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.view = [[UIView alloc] initWithFrame:bounds];
    self.view.layer.backgroundColor = [UIColor grayColor].CGColor;
    self.list = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_CHANNELS];
 
    UITableView *table = [[[UITableView alloc] initWithFrame:CGRectMake(0, UINAVBAR_HEIGHT, bounds.size.width, bounds.size.height-UINAVBAR_HEIGHT-BANNER_HEIGHT) style:UITableViewStylePlain] autorelease];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, UINAVBAR_HEIGHT)];
    [self.view addSubview:navBar];
    
    [navBar pushNavigationItem:[[UINavigationItem alloc] initWithTitle:@"Channels"] animated:NO];

    
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

    NewsViewController *newsVC = [[NewsViewController alloc] init];
    if (newsVC!=nil) {
        newsVC.channelUrl = channelUrl;
        [self presentModalViewController:newsVC animated:YES];
    }
 
}

@end
