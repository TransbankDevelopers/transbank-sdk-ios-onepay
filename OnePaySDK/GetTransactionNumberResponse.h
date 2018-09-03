//
//  GetTransactionNumberResponse.h
//  DemoEwallet
//
//  Created by Juan Pablo on 4/6/18.
//  Copyright © 2018 Ionix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetTransactionNumberResponse : NSObject

@property (nonatomic, copy) NSString *occ;
@property (nonatomic, copy) NSString *authorizationCode;
@property (nonatomic, assign) NSInteger issuedAt;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, copy) NSString *transactionDesc;
@property (nonatomic, assign) NSInteger installmentsAmount;
@property (nonatomic, assign) NSInteger installmentsNumber;
@property (nonatomic, copy) NSString *buyOrder;


@end
