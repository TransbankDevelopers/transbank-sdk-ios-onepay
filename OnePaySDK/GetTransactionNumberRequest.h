//
//  GetTransactionNumberRequest.h
//  DemoEwallet
//
//  Created by Juan Pablo on 4/6/18.
//  Copyright © 2018 Ionix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetTransactionNumberRequest : NSObject

@property (nonatomic, copy) NSString *occ;
@property (nonatomic, assign) NSInteger issuedAt;
@property (nonatomic, copy) NSString *externalUniqueNumber;
@property (nonatomic, copy) NSString *signature;

-(NSString *) toStringHasheable;

@end
