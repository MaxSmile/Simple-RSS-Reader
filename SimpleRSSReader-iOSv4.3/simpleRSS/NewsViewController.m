//
//  NewsViewController.m
//  simpleRSS
//
//  Created by maxim.vasilkov@gmail.com on 29/05/14.
//

#import "NewsViewController.h"
#import "StoryViewController.h"
#import "CommonDeclarations.h"

@interface NewsViewController () {
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
}

@end

@implementation NewsViewController

@synthesize feeds=_feeds,parser=_parser,channelUrl=_channelUrl,element=_currentElement;


- (void) loadView {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.view = [[UIView alloc] initWithFrame:bounds];
    self.view.layer.backgroundColor = [UIColor grayColor].CGColor;
    
    
    
    UITableView *table = [[[UITableView alloc] initWithFrame:CGRectMake(0, UINAVBAR_HEIGHT, bounds.size.width, bounds.size.height-UINAVBAR_HEIGHT-BANNER_HEIGHT) style:UITableViewStylePlain] autorelease];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, UINAVBAR_HEIGHT)];
    [self.view addSubview:navBar];

    UINavigationItem *top = [[UINavigationItem alloc] initWithTitle:@"Feeds"];
    [navBar pushNavigationItem:top animated:NO];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    [top setLeftBarButtonItem:back];
    
    
    self.parser = nil;
    self.feeds = [NSMutableArray array];
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


-(void)viewDidAppear:(BOOL)animated {
    if (_parser==nil) {
        NSURL *url = [NSURL URLWithString:self.channelUrl];
        self.parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        [_parser setDelegate:self];
        [_parser setShouldResolveExternalEntities:NO];
        [_parser parse];
    }
    
}


#pragma mark Parser stuff

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [tableView reloadData];
    activityIndicator.hidden = YES;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    self.element = elementName;
    
    if ([elementName isEqualToString:@"item"]) {
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
    }
    
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    [title release];
    [link release];
    [item release];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {

    if ([self.element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([self.element isEqualToString:@"link"]) {
        [link appendString:string];
    }
    
}
- (
   void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        
        [self.feeds addObject:item];
        [title release];
        [link release];
        [item release];
    }
    
}

#pragma mark UITableSourceDelegate

// TODO : Add custom cell to have "* Items in RSS list should contain full title and full description"

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellFeed";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    [cell.textLabel setText:[[_feeds objectAtIndex:indexPath.row] objectForKey: @"title"]];
    return cell;
}

#pragma mark UITableDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *feedLink = [[_feeds objectAtIndex:indexPath.row] objectForKey: @"link"];
    feedLink = [feedLink stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    feedLink = [feedLink stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *feedTitle = [[_feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
    //NSLog(@"Row index %d was selected, feed %@",indexPath.row,feedLink);
    
    StoryViewController *storyVC = [[StoryViewController alloc] init];

    if (storyVC!=nil) {
        storyVC.feedLink = feedLink;
        storyVC.feedTitle = feedTitle;
        [self presentModalViewController:storyVC animated:YES];
    }
}

#pragma mark -
-(IBAction) back {
    [self dismissModalViewControllerAnimated:YES];
}

@end
