//
//  KSVNews.h
//  newsApp
//
//  Created by Сергей Курганов on 20.07.17.
//  Copyright © 2017 Курганов Сергей. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSVNews : NSObject

@property (strong, nonatomic) NSString* createdDatePost;
@property (strong, nonatomic) NSString* descriptionPost;
@property (strong, nonatomic) NSURL* urlImage;
@property (strong, nonatomic) NSURL* urlThumbnail;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* idNews;

- (id) initWirhServerResponse:(NSDictionary* ) responseObject;
@end
