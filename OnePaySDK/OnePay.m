//
//  OnePay.m
//  DemoEwallet
//
//  Created by Juan Pablo on 4/5/18.
//  Copyright © 2018 Ionix. All rights reserved.
//

#import "OnePay.h"
#import <CommonCrypto/CommonHMAC.h>
#import "Constants.h"


static NSString * const kScheme = @"onepay://";
static NSString * const kAppStore = @"https://itunes.apple.com/cl/app/onepay/id1218407961?mt=8";
//static NSString * const kAppKey = @"04533c31-fe7e-43ed-bbc4-1c8ab1538afp";
static NSString * const kAppKey = @"04533c31-fe7e-43ed-bbc4-1c8ab1538omg";

// Homologar Implementación de android
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

-(NSData *) hmacForKeyAndData:(NSString *)key data:(NSString *)data {
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    return [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
}

-(void)finishPayment:(NSString *)occ :(NSString *)issuedAt :(NSString *)externalUniqueNumber :(NSString *)apiKey :(NSString *)sharedSecret success:(FinishPaymentCallbackSuccess)success failure:(FinishPaymentCallbackFail)failure{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *stringHash = [NSString stringWithFormat:@"%lu%@%lu%@%lu%@",
                                (unsigned long) [occ length], occ,
                                (unsigned long) [externalUniqueNumber length], externalUniqueNumber,
                                (unsigned long) [issuedAt length], issuedAt];

        NSString *signature = [[self hmacForKeyAndData:sharedSecret data:stringHash] base64EncodedStringWithOptions:0];
    
        NSDictionary *parameters = @{@"occ":occ,
                                    @"issuedAt":issuedAt,
                                    @"externalUniqueNumber": externalUniqueNumber,
                                    @"signature":signature,
                                    @"appKey":kAppKey,
                                    @"apiKey":apiKey};
        
        NSLog(@"%@%@",@"parameters: ", parameters);
    
        NSError *error;
    
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,GET_TRANSACTION_NUMBER_PATH]];
        
        NSLog(@"%@%@",@"URL: ", [NSString stringWithFormat:@"%@%@",BASE_URL,GET_TRANSACTION_NUMBER_PATH]);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:jsonData];
    
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
            id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error) {
                    NSLog(@"Reply JSON: %@", responseObject);
                    if ([responseObject[@"responseCode"] isEqual:@"OK"]) {

                        success(responseObject[@"result"]);

                    }else{
                        failure(responseObject[@"description"]);
                    }

                    if ([responseObject isKindOfClass:[NSArray class]]) {
                        NSLog(@"Response == %@",responseObject);
                        failure(responseObject[@"description"]);
                    }
                } else {
                    NSLog(@"Error: %@, %@, %@", error, response, responseObject);
                    failure(responseObject[@"description"]);
                }
            });
        }]resume];
        
    });
}
@end
