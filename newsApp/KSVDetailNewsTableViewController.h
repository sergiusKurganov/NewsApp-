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
    
    KSVTypeSizeStandart,
    KSVTypeSizeFirst,
    KSVTypeSizeSecond
    
}KSVTypeSize;

@interface KSVDetailNewsTableViewController : UITableViewController

- (IBAction)actionInfo:(UIButton *)sender;
- (IBAction)actionInfoByPhoto:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *actionInfo;
@property (weak, nonatomic) IBOutlet UIButton *actionInfoByPhoto;

@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (strong, nonatomic) KSVNews* news;
@property (assign, nonatomic) NSInteger selectedIndex;

@end
