//
//  NewsViewController.m
//  simpleRSS
//
//  Created by maxim.vasilkov@gmail.com on 29/05/14.
//

#import "NewsViewController.h"
#import "StoryViewController.h"

@interface NewsViewController () {
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
}

@end

@implementation NewsViewController

@synthesize feeds=_feeds,parser=_parser,channelUrl=_channelUrl,element=_currentElement;

- (void) viewDidLoad {
    [super viewDidLoad];
    self.parser = nil;
    self.feeds = [NSMutableArray array];
    self.activityIndicator.layer.backgroundColor = [UIColor blackColor].CGColor;
    self.activityIndicator.layer.masksToBounds = YES;
    self.activityIndicator.layer.cornerRadius = 10;
    self.activityIndicator.center = self.view.center;

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
    [self.tableView reloadData];
    self.activityIndicator.hidden = YES;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellFeed";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
    NSLog(@"Row index %d was selected, feed %@",indexPath.row,feedLink);
    
    StoryViewController *storyVC = nil;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        storyVC = [[StoryViewController alloc] initWithNibName:@"StoryViewController_iPhone" bundle:nil];
    } else {
        storyVC = [[StoryViewController alloc] initWithNibName:@"StoryViewController_iPad" bundle:nil];
    }
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
