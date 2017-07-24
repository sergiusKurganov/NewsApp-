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
#import "KSVDetailPost.h"
#import "KSVDataManager.h"
#import "KSVNews.h"

#import "UIImageView+AFNetworking.h"
#import "UINavigationBar+UINavigationBar_Translocation.h"

#define NAVBAR_CHANGE_POINT 50

@interface KSVDetailNewsTableViewController () <UITableViewDataSource, UITableViewDelegate, KSVDescriptionTableViewCellDelegate>
@property (strong, nonatomic) KSVDetailPost* detailPost;
@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) NSMutableArray* newsArray;
@property (assign, nonatomic) NSInteger countTypeSize;


@end

@implementation KSVDetailNewsTableViewController

static NSInteger totalPage = 2;
static NSInteger totalLimit = 20;
static NSInteger firstRequestlPage = 1;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.page = firstRequestlPage;
    self.countTypeSize = KSVTypeSizeStandart;
    
    self.newsArray = [NSMutableArray array];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
       
    UIBarButtonItem *graphButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ImageTypesize"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(graphButton)];
    self.navigationItem.rightBarButtonItem = graphButton;
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -80.f) forBarMetrics:UIBarMetricsDefault];
    
    [self.newsImageView setImageWithURL:self.news.urlImage];
    
    [self getDetailNewsFromServer:self.news.idNews];
    [self getNewsFromServer:firstRequestlPage];
    
   
}

#pragma MARK - API

- (void) getDetailNewsFromServer:(NSString*) detailNews {
    
    [[KSVDataManager sharedManager] getDetailNewsPostWhithIdPost:detailNews
                                                       OnSuccess:^(KSVDetailPost* detailPost) {
                                                           
                                                           self.detailPost = detailPost;
                                                           [self.tableView reloadData];
                                                    
                                                       } onFailure:^(NSError *error, NSInteger statusCode) {
                                                           
                                                       }];
    
}

- (void) getNewsFromServer:(NSInteger) page {
    
    [[KSVDataManager sharedManager] getNewsWhithPage:page andLimit:totalLimit
                                           OnSuccess:^(NSArray *newsArray) {
                                               
               NSMutableArray* arrayTest = [NSMutableArray array];
               
               for (KSVNews* news in newsArray) {
                   
                   if (news.idNews != self.detailPost.idDetailPost) {
                       [arrayTest addObject:news];
                   }
               }
            
                   
              [self.newsArray  addObjectsFromArray:arrayTest];
                                               
            
              NSMutableArray* newPath = [NSMutableArray array];
               
               for (int i = (int)[self.newsArray count] - (int)[arrayTest count] ; i < [self.newsArray count]; i++) {
                   [newPath addObject:[NSIndexPath indexPathForRow:i + 2 inSection:0]];
               }
               
               [self.tableView beginUpdates];
               
               [self.tableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
               
               [self.tableView endUpdates];
               
                                        
                                           
                                       } onFailure:^(NSError *error, NSInteger statusCode) {
                                           
                                       }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        return 1300.f;
    } else {
        return 150.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 100.f;
    } else if (indexPath.row == 1) {
        return UITableViewAutomaticDimension;
    } else {
        return 150.f;
    }
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat currentPosition = (int)self.newsArray.count + 1;
  
    if ((indexPath.row  >= currentPosition ) && (self.page < totalPage) && (indexPath.row > 2)) {
        
        self.page = self.page + 1;
        
        [self getNewsFromServer: self.page];
        
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row > 1){
        
        KSVNews* news = [self.newsArray objectAtIndex:indexPath.row - 2];
        
        KSVDetailNewsTableViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"KSVNewsTableViewController"];
        
        vc.news = news;
        vc.title = @"Новости";
        
        
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
        
        switch (self.countTypeSize) {
            case KSVTypeSizeStandart:
                headerCell.titleNewsLabel.font = [UIFont systemFontOfSize: 17.5f];
                headerCell.datePostLabel.font = [UIFont systemFontOfSize: 12.5f];
              
            case KSVTypeSizeFirst:
                headerCell.titleNewsLabel.font = [UIFont systemFontOfSize: 18.5f];
                headerCell.datePostLabel.font = [UIFont systemFontOfSize: 13.5f];
                
                break;
            case KSVTypeSizeSecond:
                headerCell.titleNewsLabel.font = [UIFont systemFontOfSize: 16.5f];
                headerCell.datePostLabel.font = [UIFont systemFontOfSize: 11.5f];
                
                break;
            default:
                break;
        }
        
        headerCell.titleNewsLabel.text = self.news.title;
        headerCell.datePostLabel.text = self.news.createdDatePost;
        
        return headerCell;
        
    } else if (indexPath.row == 1) {
        
        KSVDescriptionTableViewCell* descriptionCell = [tableView dequeueReusableCellWithIdentifier:cellDescriptionIdentifier forIndexPath:indexPath];
        
        descriptionCell.delegate = self;
        
        switch (self.countTypeSize) {
            case KSVTypeSizeStandart:
                descriptionCell.descriptionLabel.font = [UIFont systemFontOfSize: 14.f];
                break;
            case KSVTypeSizeFirst:
                descriptionCell.descriptionLabel.font = [UIFont systemFontOfSize: 15.f];
                break;
            case KSVTypeSizeSecond:
                descriptionCell.descriptionLabel.font = [UIFont systemFontOfSize: 13.f];
                break;
            default:
                break;
        }

        descriptionCell.descriptionLabel.text = self.detailPost.text;
        
        return descriptionCell;
        
    } else {
        
        KSVNewsTableViewCell* newsCell = [tableView dequeueReusableCellWithIdentifier:cellNewsIdentifier forIndexPath:indexPath];
        
        KSVNews* news = [self.newsArray objectAtIndex:indexPath.row - 2];
        
        switch (self.countTypeSize) {
            case KSVTypeSizeStandart:
                newsCell.textNewsLabel.font = [UIFont systemFontOfSize: 14.f];
                newsCell.dateNewsLabel.font = [UIFont systemFontOfSize: 12.f];
                break;
            case KSVTypeSizeFirst:
                newsCell.textNewsLabel.font = [UIFont systemFontOfSize: 15.f];
                newsCell.dateNewsLabel.font = [UIFont systemFontOfSize: 13.f];
                break;
            case KSVTypeSizeSecond:
                newsCell.textNewsLabel.font = [UIFont systemFontOfSize: 13.f];
                newsCell.dateNewsLabel.font = [UIFont systemFontOfSize: 11.f];
                
                self.countTypeSize = 0;
                
                break;
            default:
                break;
        }

        
        newsCell.textNewsLabel.text = news.title;
        newsCell.dateNewsLabel.text = news.createdDatePost;
        
        NSURLRequest* urlRequest = [NSURLRequest requestWithURL:news.urlThumbnail];
        
        __weak KSVNewsTableViewCell* weekCell = newsCell;
        
        [newsCell.newsImageView setImageWithURLRequest:urlRequest
                                  placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          weekCell.newsImageView.image = image;
                                      });
                                  } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                      
                                  }];
        
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
    
    self.countTypeSize = self.countTypeSize + 1;
    [self.tableView reloadData];
}

//- (IBAction)actionInfo:(UIButton *)sender {
//    
//    NSURL *url = self.detailPost.source;
//    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
//}
//
//- (IBAction)actionInfoByPhoto:(UIButton *)sender {
//    
//    NSURL *url = self.news.urlThumbnail;
//    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
//}
//

- (void)photoPostAction:(UIButton *)sender {
    
    NSURL *url = self.news.urlThumbnail;
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    
}

- (void)sourcePostAction:(UIButton *)sender {
    NSURL *url = self.news.urlImage;
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}
@end
