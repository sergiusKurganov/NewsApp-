//
//  KSVNewsTableViewCell.h
//  newsApp
//
//  Created by Сергей Курганов on 19.07.17.
//  Copyright © 2017 Курганов Сергей. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSVNewsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *textNewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateNewsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;

@end
