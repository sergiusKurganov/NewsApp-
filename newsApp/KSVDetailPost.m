//
//  KSVDetailPost.m
//  newsApp
//
//  Created by Сергей Курганов on 23.07.17.
//  Copyright © 2017 Курганов Сергей. All rights reserved.
//

#import "KSVDetailPost.h"

@implementation KSVDetailPost

- (id) initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super init];
    if (self) {
        
        NSString* textHtml = [responseObject objectForKey:@"text"];
        
        self.text = [self convertHTML:textHtml];
        
        self.idDetailPost = [responseObject objectForKey:@"id"];
        
        NSString* stringUrl = [responseObject objectForKey:@"source"];
        
        if (stringUrl) {
            NSURL *sourceUrl = [NSURL URLWithString:stringUrl];
            self.source = sourceUrl;
        }
        
    }
    return self;
}


-(NSString *)convertHTML:(NSString *)html {
    
    NSScanner *myScanner;
    NSString *text = nil;
    myScanner = [NSScanner scannerWithString:html];
    
    while ([myScanner isAtEnd] == NO) {
        
        [myScanner scanUpToString:@"<" intoString:NULL] ;
        
        [myScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}

@end
