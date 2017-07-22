//
//  KSVHeaderTableViewCell.h
//  newsApp
//
//  Created by Сергей Курганов on 22.07.17.
//  Copyright © 2017 Курганов Сергей. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KSVHeaderTableViewCell : UITableViewCell  

@property (weak, nonatomic) IBOutlet UILabel *titleNewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *datePostLabel;

@end
