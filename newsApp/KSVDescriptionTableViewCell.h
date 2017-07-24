//
//  KSVDescriptionTableViewCell.h
//  newsApp
//
//  Created by Сергей Курганов on 22.07.17.
//  Copyright © 2017 Курганов Сергей. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KSVDescriptionTableViewCellDelegate;

@interface KSVDescriptionTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) id<KSVDescriptionTableViewCellDelegate> delegate;

@end

@protocol KSVDescriptionTableViewCellDelegate <NSObject>

@required

- (IBAction)sourcePostAction:(UIButton *)sender;
- (IBAction)photoPostAction:(UIButton *)sender;

@end
