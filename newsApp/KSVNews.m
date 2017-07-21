//
//  KSVNews.m
//  newsApp
//
//  Created by Сергей Курганов on 20.07.17.
//  Copyright © 2017 Курганов Сергей. All rights reserved.
//

#import "KSVNews.h"

@implementation KSVNews


- (id) initWirhServerResponse:(NSDictionary *) responseObject
{
    self = [super init];
    if (self) {
    
        NSString* dateString = [responseObject objectForKey:@"created_at"];
        self.createdDatePost = [self makeDateFormatWithOldFormat:dateString];
        
        self.title = [responseObject objectForKey:@"title"];
        self.descriptionPost = [responseObject objectForKey:@"description"];
      
        NSString* stringImageUrl = [responseObject objectForKey:@"image"];
        
        if (stringImageUrl) {
            NSURL *urlImage = [NSURL URLWithString:stringImageUrl];
            self.urlImage = urlImage;

        }
        
        NSString* stringThumbnailUrl = [responseObject objectForKey:@"thumbnail"];
        
        if (stringThumbnailUrl) {
            NSURL *urlImage = [NSURL URLWithString:stringThumbnailUrl];
            self.urlThumbnail = urlImage;

        }   
    }
    return self;
}

- (NSString*) makeDateFormatWithOldFormat:(NSString*) oldFormat {
    
    NSString*  dateString = [oldFormat substringToIndex:19];
    NSCharacterSet* set = [NSCharacterSet characterSetWithCharactersInString:@"T"];
    dateString = [[dateString componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@" "];
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate*  datePost = [[NSDate alloc] init];
    datePost = [dateFormater dateFromString:dateString];
    
    [dateFormater setDateFormat:@"dd MMM yyyy HH:mm"];
    dateString = [dateFormater stringFromDate:datePost];

    
    return dateString;
}

@end
