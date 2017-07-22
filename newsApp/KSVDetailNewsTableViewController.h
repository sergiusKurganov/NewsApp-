//
//  KSVDetailNewsTableViewController.h
//  newsApp
//
//  Created by Сергей Курганов on 22.07.17.
//  Copyright © 2017 Курганов Сергей. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSVNews;
@class KSVNewsTableViewController;

@interface KSVDetailNewsTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (strong, nonatomic) KSVNewsTableViewController* newsVc;
@property (strong, nonatomic) KSVNews* news;
@property (strong, nonatomic) NSMutableArray* newsArray;

@end
