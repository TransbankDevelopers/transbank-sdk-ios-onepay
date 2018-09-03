//
//  OnePay.h
//  DemoEwallet
//
//  Created by Juan Pablo on 4/5/18.
//  Copyright © 2018 Ionix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnePay : NSObject

typedef NS_ENUM(NSInteger, OnePayState) {
    OnePayStateOccInvalid,
    OnePayStateNotInstalled
};
typedef NS_ENUM(NSInteger, FinishPaymentState) {
    OK,
    ERROR,
    INVALID_PLUGIN_VERSION,
    INVALID_APP_KEY,
    COMMERCE_NOT_FOUND,
    UNAVAILABLE_COMMERCE,
    SIGN_VALIDATION_ERROR,
    INVALID_TRANSACTION_SIGN,
    INVALID_TRANSACTION,
    INVALID_TRANSACTION_STATUS
};

typedef void(^OnePayCallback)(OnePayState statusCode, NSString *description);

typedef void(^FinishPaymentCallbackFail)(NSString *description);

typedef void(^FinishPaymentCallbackSuccess)(NSDictionary *result);

-(void) initPayment:(NSString *)occ callback:(OnePayCallback)callback;

-(void) installOnePay;

-(BOOL) isOnePayInstalled;

-(void) finishPayment:(NSString *)occ
                     :(NSString *)issuedAt
                     :(NSString *)externalUniqueNumber
                     :(NSString *)apiKey
                     :(NSString *)sharedSecret
              success:(FinishPaymentCallbackSuccess)success
              failure:(FinishPaymentCallbackFail)failure;

@end
