//
//  ViewController.m
//  newsApp
//
//  Created by Сергей Курганов on 19.07.17.
//  Copyright © 2017 Курганов Сергей. All rights reserved.
//
#import "KSVDetailNewsTableViewController.h"
#import "KSVNewsTableViewController.h"
#import "KSVNewsTableViewCell.h"
#import "KSVDataManager.h"
#import "KSVNews.h"

#import <UIImageView+AFNetworking.h>

@interface KSVNewsTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray* newsArray;
@property (assign, nonatomic) NSInteger* limit;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger selectedIndexPath;
@end

@implementation KSVNewsTableViewController

static NSInteger totalPage = 2;
static NSInteger totalLimit = 20;
static NSInteger firstRequestlPage = 1;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    
    self.newsArray = [NSMutableArray array];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
    UIColor * color = [UIColor colorWithRed:0/255.0 green:174/255.0 blue:197/255.0 alpha:1];
    
    self.navigationController.navigationBar.backgroundColor = color;
    self.navigationController.navigationBar.barTintColor = color;
    
    [self getNewsFromServer:firstRequestlPage];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    UIColor * color = [UIColor colorWithRed:0/255.0 green:174/255.0 blue:197/255.0 alpha:1];
    
    self.navigationController.navigationBar.backgroundColor = color;
    self.navigationController.navigationBar.barTintColor = color;
}

#pragma MARK - API

- (void) getNewsFromServer:(NSInteger) page {
    
    [[KSVDataManager sharedManager] getNewsWhithPage:page andLimit:totalLimit
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
    
    CGFloat currentPosition = (int)self.newsArray.count;
    
    if ((indexPath.row >= currentPosition - 1) && (self.page < totalPage) ) {
        
        self.page = self.page + 1;
        
        [self getNewsFromServer: self.page];
  
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
      self.selectedIndexPath = indexPath.row;
    
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

#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    KSVDetailNewsTableViewController* vc = [segue destinationViewController];
    KSVNews* selectedNews = [self.newsArray objectAtIndex:self.selectedIndexPath];
    
    vc.news = selectedNews;
    vc.newsVc = self;
    vc.title = @"Новости";
    vc.newsArray = self.newsArray;
}

#pragma mark - Action
- (IBAction)refreshAction:(UIBarButtonItem *) sender {
    
    [self.newsArray removeAllObjects];
    
    [self.tableView reloadData];
    
    self.page = firstRequestlPage;
    self.limit = 0;
    self.page = 1;

    [self getNewsFromServer:firstRequestlPage];
}

@end
