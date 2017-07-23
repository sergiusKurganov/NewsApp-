//
//  KSVDataManager.m
//  newsApp
//
//  Created by Сергей Курганов on 19.07.17.
//  Copyright © 2017 Курганов Сергей. All rights reserved.
//
#import <AFNetworking.h>

#import "KSVDataManager.h"
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
        
        NSURL *url = [NSURL URLWithString:@"http://news.mhth.ru/api/v1/"];
        
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
    
    [self.requestOpertionManager GET:@"news" parameters:parametrs progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
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

//- (void) getDetailNewsPostWhithIdPost:(NSString*) idPost
//                            OnSuccess:(void(^)(NSArray* detailPostArray)) success
//                            onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
//    
//    NSInteger idPosti = [idPost integerValue];
//    
//    NSDictionary* parametrs = [NSDictionary dictionaryWithObjectsAndKeys:@(idPosti), @"id", nil];
//    
//    [self.requestOpertionManager GET:@"/news/:id"
//                          parameters:parametrs
//                            progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                                 NSLog(@"JSON - %@", responseObject);
//                                
//                                NSArray* dictArray = [responseObject objectForKey:@"data"];
//                                
//                                NSMutableArray* arrayNewsObject = [NSMutableArray array];
//                                
//                                for (NSDictionary* dict in dictArray) {
//                                    KSVDetailNews* detailNews = [[KSVDetailNews alloc] initWirhServerResponse:dict];
//                                    
//                                    [arrayNewsObject addObject:detailNews];
//                                }
//                                
//                                if (success) {
//                                    success(arrayNewsObject);
//                                }
//
//                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                                
//                                NSLog(@"error - %@", [error localizedDescription] );
//
//                            }];} // error (500)

    
@end
