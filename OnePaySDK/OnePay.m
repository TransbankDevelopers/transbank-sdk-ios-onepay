//
//  OnePay.m
//  DemoEwallet
//
//  Created by Juan Pablo on 4/5/18.
//  Copyright © 2018 Ionix. All rights reserved.
//

#import "OnePay.h"
#import <CommonCrypto/CommonHMAC.h>

static NSString * const kScheme = @"onepay://";
static NSString * const kAppStore = @"https://itunes.apple.com/cl/app/onepay-transbank/id1432114499?mt=8";

// Homologar Implementación de android 
// 
//Homologate Android Implementation
@interface OnePay ()

-(void) openSchemeWithParameters:(NSDictionary *)parameters callback:(OnePayCallback)callback;
-(NSArray *) serializeParameters:(NSDictionary *)parameters;

@end

@implementation OnePay

-(void) initPayment:(NSString *)occ callback:(OnePayCallback)callback {
    if (!occ || [occ lengthOfBytesUsingEncoding:NSASCIIStringEncoding] <= 0) {
        callback(OnePayStateOccInvalid, @"Occ invalida"); // homologar mensajes de andorid
        return;
    }

    [self openSchemeWithParameters:@{@"occ": occ} callback:callback];
}

-(void) installOnePay {
    [UIApplication.sharedApplication openURL:[NSURL URLWithString:kAppStore]];
}

-(BOOL) isOnePayInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kScheme]];
}

-(void) openSchemeWithParameters:(NSDictionary *)parameters callback:(OnePayCallback)callback {
    if ( ! [self isOnePayInstalled]) {
        callback(OnePayStateNotInstalled, @"Aplicación no instalada"); // homologar mensajes de andorid
        return;
    }

    NSURLComponents *components = [NSURLComponents componentsWithString:kScheme];
    components.queryItems = [self serializeParameters:parameters];

    [UIApplication.sharedApplication openURL:components.URL];
}

-(NSArray *) serializeParameters:(NSDictionary *)parameters {
    NSMutableArray *queryItems = [NSMutableArray array];
    for (NSString *key in parameters) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:parameters[key]]];
    }
    
    return [queryItems copy];
}

@end
