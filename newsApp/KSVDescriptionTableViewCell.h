//
//  KSVDescriptionTableViewCell.h
//  newsApp
//
//  Created by Сергей Курганов on 22.07.17.
//  Copyright © 2017 Курганов Сергей. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KSVDescriptionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoByImageButton;
@property (weak, nonatomic) IBOutlet UIButton *infoByNewsButton;

@end
