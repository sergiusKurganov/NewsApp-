//
//  KSVDetailNewsTableViewController.m
//  newsApp
//
//  Created by Сергей Курганов on 22.07.17.
//  Copyright © 2017 Курганов Сергей. All rights reserved.
//

#import "KSVDetailNewsTableViewController.h"
#import "KSVDescriptionTableViewCell.h"
#import "KSVHeaderTableViewCell.h"
#import "KSVNewsTableViewCell.h"
#import "KSVDataManager.h"
#import "KSVNews.h"

#import "UIImageView+AFNetworking.h"
#import "UINavigationBar+UINavigationBar_Translocation.h"

#define NAVBAR_CHANGE_POINT 50

@interface KSVDetailNewsTableViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@end

@implementation KSVDetailNewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
      [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
       
    UIBarButtonItem *graphButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ImageTypesize"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(graphButton)];
    self.navigationItem.rightBarButtonItem = graphButton;
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -80.f) forBarMetrics:UIBarMetricsDefault];
    
    [self.newsImageView setImageWithURL:self.news.urlImage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 120.f;
    } else if (indexPath.row == 1) {
        return 240.f;
    } else {
        return 150.f;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row != 0 || indexPath.row != 1){
        
        KSVNews* news = [self.newsArray objectAtIndex:indexPath.row - 2];
        
        KSVDetailNewsTableViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"KSVNewsTableViewController"];
        
        vc.news = news;
        vc.title = @"Новости";
        vc.newsArray = self.newsArray;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.newsArray count] + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellHeaderIdentifier = @"cellHeader";
    static NSString* cellDescriptionIdentifier = @"cellDescription";
    static NSString* cellNewsIdentifier = @"cellNews";

    if (indexPath.row == 0) {
       
        KSVHeaderTableViewCell* headerCell = [tableView dequeueReusableCellWithIdentifier:cellHeaderIdentifier forIndexPath:indexPath];
        
        headerCell.titleNewsLabel.text = self.news.title;
        headerCell.datePostLabel.text = self.news.createdDatePost;
        
        return headerCell;
        
    } else if (indexPath.row == 1) {
        
        KSVDescriptionTableViewCell* descriptionCell = [tableView dequeueReusableCellWithIdentifier:cellDescriptionIdentifier forIndexPath:indexPath];
        
        descriptionCell.descriptionLabel.text = self.news.descriptionPost;
        
        return descriptionCell;
        
    } else {
        
        KSVNewsTableViewCell* newsCell = [tableView dequeueReusableCellWithIdentifier:cellNewsIdentifier forIndexPath:indexPath];
        
        KSVNews* news = [self.newsArray objectAtIndex:indexPath.row - 2];
        
        newsCell.textNewsLabel.text = news.title;
        newsCell.dateNewsLabel.text = news.createdDatePost;
        [newsCell.newsImageView setImageWithURL:news.urlThumbnail];
        
        return newsCell;
        
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
 
    UIColor * color = [UIColor colorWithRed:0/255.0 green:174/255.0 blue:197/255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}


#pragma mark -Action
- (void) graphButton {
    NSLog(@"graphButton");
}

@end
