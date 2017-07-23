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

typedef enum {
    
    KSVTypeSizeStandart = 1,
    KSVTypeSizeFirst = 2,
    KSVTypeSizeSecond = 3
    
}KSVTypeSize;

@interface KSVDetailNewsTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (strong, nonatomic) KSVNews* news;
@property (assign, nonatomic) NSInteger selectedIndex;

- (IBAction)actionInfo:(UIButton *)sender;
- (IBAction)actionInfoByPhoto:(UIButton *)sender;

@end
