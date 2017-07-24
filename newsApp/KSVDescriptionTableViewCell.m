//
//  KSVDescriptionTableViewCell.m
//  newsApp
//
//  Created by Сергей Курганов on 22.07.17.
//  Copyright © 2017 Курганов Сергей. All rights reserved.
//

#import "KSVDescriptionTableViewCell.h"

@implementation KSVDescriptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)sourcePostAction:(UIButton *)sender {
    
    [self.delegate sourcePostAction:sender];
}

- (IBAction)photoPostAction:(UIButton *)sender {
    
    [self.delegate sourcePostAction:sender];

}
@end
