//
//  GetTransactionNumberRequest.m
//  DemoEwallet
//
//  Created by Juan Pablo on 4/6/18.
//  Copyright © 2018 Ionix. All rights reserved.
//

#import "GetTransactionNumberRequest.h"

@implementation GetTransactionNumberRequest

-(NSString *) toStringHasheable {
    NSString *issuedAt = [NSNumber numberWithLong:_issuedAt].stringValue;

    return [NSString stringWithFormat:@"%lu%@%lu%@%lu%@",
            (unsigned long) _occ.length, _occ,
            (unsigned long) issuedAt.length, issuedAt,
            (unsigned long) _externalUniqueNumber.length, _externalUniqueNumber];
}
@end
