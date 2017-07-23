//
//  KSVDetailPost.h
//  newsApp
//
//  Created by Сергей Курганов on 23.07.17.
//  Copyright © 2017 Курганов Сергей. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSVDetailPost : NSObject

@property (strong, nonatomic) NSString* idDetailPost;
@property (strong, nonatomic) NSURL* source;
@property (strong, nonatomic) NSString* text;

- (id) initWithServerResponse:(NSDictionary*) responseObject;

@end
