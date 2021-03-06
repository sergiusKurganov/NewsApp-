//
//  KSVDataManager.h
//  newsApp
//
//  Created by Сергей Курганов on 19.07.17.
//  Copyright © 2017 Курганов Сергей. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KSVDetailPost;
@interface KSVDataManager : NSObject

+ (KSVDataManager*) sharedManager;

- (void) getNewsWhithPage:(NSInteger) page
             andLimit:(NSInteger) limit
             OnSuccess:(void(^)(NSArray* newsArray)) success
             onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getDetailNewsPostWhithIdPost:(NSString*) idPost
                            OnSuccess:(void(^)(KSVDetailPost* detailPost)) success
                            onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

@end
