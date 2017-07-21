//
//  ViewController.m
//  newsApp
//
//  Created by Сергей Курганов on 19.07.17.
//  Copyright © 2017 Курганов Сергей. All rights reserved.
//

#import "KSVNewsTableViewController.h"
#import "KSVNewsTableViewCell.h"
#import "KSVDataManager.h"
#import "KSVNews.h"
#import <UIImageView+AFNetworking.h>

@interface KSVNewsTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray* newsArray;
@property (assign, nonatomic) BOOL refreshBool;
@property (assign, nonatomic) NSInteger* limit;

@end

@implementation KSVNewsTableViewController

static NSInteger totalLimit = 20;
static NSInteger totalPage = 2;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.newsArray = [NSMutableArray array];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
    [self getNewsFromServer];
}

#pragma MARK - API
- (void) getNewsFromServer {
    
    [[KSVDataManager sharedManager] getNewsWhithPage:1 andLimit:10
           OnSuccess:^(NSArray *newsArray) {
            
               [self.newsArray  addObjectsFromArray:newsArray];
               
               NSMutableArray* newPath = [NSMutableArray array];
               
               for (int i = (int)[self.newsArray count] - (int)[newsArray count]; i < [self.newsArray count]; i++) {
                   [newPath addObject:[NSIndexPath indexPathForRow:i inSection:0]];
               }
               
               [self.tableView beginUpdates];
               
               [self.tableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
               
               [self.tableView endUpdates];

           } onFailure:^(NSError *error, NSInteger statusCode) {
               
           }];
    
}
#pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"index %ld", (long)indexPath.row);
   
    CGFloat currentPosition = (totalLimit * 0.5f) - 1;
    
    if ((indexPath.row >= currentPosition) && ((int)self.limit < totalLimit) ) {
        NSLog(@"GET");
        
        self.limit = self.limit + 10;
       
        [self getNewsFromServer];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.newsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"cellNews";
    
    KSVNewsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    KSVNews* news = [self.newsArray objectAtIndex:indexPath.row];
    
    cell.textNewsLabel.text = news.title;
    cell.dateNewsLabel.text = news.createdDatePost;
    
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:news.urlThumbnail];
    
    __weak KSVNewsTableViewCell* weekCell = cell;
    
    [cell.newsImageView setImageWithURLRequest:urlRequest
                              placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      weekCell.newsImageView.image = image;
                                  });
                              } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                  
                                  
                                  
                              }];
    
    return cell;
}

#pragma mark - Action
- (IBAction)refreshAction:(UIBarButtonItem *) sender {
    
    self.limit = 0;
    
    [self.newsArray removeAllObjects];
    
    [self.tableView reloadData];

    [self getNewsFromServer];
}
@end
