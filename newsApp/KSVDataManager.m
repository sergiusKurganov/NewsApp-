//
//  KSVDataManager.m
//  newsApp
//
//  Created by Сергей Курганов on 19.07.17.
//  Copyright © 2017 Курганов Сергей. All rights reserved.
//
#import <AFNetworking.h>

#import "KSVDataManager.h"
#import "KSVDetailPost.h"
#import "KSVNews.h"

@interface KSVDataManager ()
@property (strong, nonatomic) AFHTTPSessionManager* requestOpertionManager;
@end

@implementation KSVDataManager

static NSString* token = @"tPK7s7vdmDxZf7Ar";
static NSString* headerField = @"X-Token";

+ (KSVDataManager*) sharedManager {
    
    static KSVDataManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KSVDataManager alloc]init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURL *url = [NSURL URLWithString:@"http://news.mhth.ru"];
        
        self.requestOpertionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
        [self.requestOpertionManager.requestSerializer setValue:token forHTTPHeaderField:headerField];

        
    }
    return self;
}

- (void) getNewsWhithPage:(NSInteger) page
             andLimit:(NSInteger) limit
            OnSuccess:(void(^)(NSArray* newsArray)) success
            onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    
    NSDictionary* parametrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                             @(page), @"page",
                                                                             @(limit), @"limit", nil];
    
    [self.requestOpertionManager GET:@"/api/v1/news" parameters:parametrs progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
         NSLog(@"JSON - %@", responseObject);
        
        NSArray* dictArray = [responseObject objectForKey:@"data"];
        
        NSMutableArray* arrayNewsObject = [NSMutableArray array];
        
        for (NSDictionary* dict in dictArray) {
            KSVNews* news = [[KSVNews alloc] initWirhServerResponse:dict];
            
            [arrayNewsObject addObject:news];
        }
        
        if (success) {
            success(arrayNewsObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error - %@", [error localizedDescription] );
        
    }];
    
}

- (void) getDetailNewsPostWhithIdPost:(NSString*) idPost
                            OnSuccess:(void(^)(KSVDetailPost* detailNews)) success
                            onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {

    NSString* stringUrl = [NSString stringWithFormat:@"/api/v1/news/%@", idPost];
  
    [self.requestOpertionManager GET:stringUrl
                          parameters:nil
                            progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 NSLog(@"JSON - %@", responseObject);
                                
                                NSDictionary* dict = [responseObject objectForKey:@"data"];
                                
                                KSVDetailPost* detailNews = [[KSVDetailPost alloc] initWithServerResponse:dict];
                                    
                                
                                if (success) {
                                    success(detailNews);
                                }

                                
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                
                                NSLog(@"error - %@", [error localizedDescription] );

                            }];
}

@end
