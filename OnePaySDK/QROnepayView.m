//
//  QROnepayView.m
//
//  Created by Rodrigo Ayala on 1/23/19.
//

#import "QROnepayView.h"

@implementation QROnepayView
NSData *_data;

- (instancetype)init {
    if ((self = [super init])) {
        _data = nil;
    }
    return self;
}

- (instancetype)initWithOtt:(NSString *)ott {
    if ((self = [super init])) {
        _data = [self generateQRDataFrom:ott];
    }
    self.image = [self getQRImage];
    return self;
}

- (NSData*) generateQRDataFrom:(NSString*)ott {
    return [[@"onepay=ott:" stringByAppendingString:ott] dataUsingEncoding:NSISOLatin1StringEncoding];
}

- (void) setOtt:(NSString *)ott {
    _data = [self generateQRDataFrom:ott];
    self.image = [self getQRImage];
}

- (UIImage *)getQRImage {
    UIImage *r = nil;
    @try {
        CIImage *src = [self getCIImage];
        if (!src || src == nil) { return nil; }
        
        CGRect imageSize = CGRectIntegral(src.extent);
        CGSize outputSize = CGSizeMake(200.0f, 200.0f);
        CIImage *imageByTransform = [src imageByApplyingTransform:CGAffineTransformMakeScale(outputSize.width/CGRectGetWidth(imageSize), outputSize.height/CGRectGetHeight(imageSize))];
        
        r = [UIImage imageWithCIImage:imageByTransform];
    } @catch (NSException *exception) {
        NSLog(@"Error: %@", exception.reason);
    }
    return r;
}

- (CIImage *)getCIImage {
    CIImage *r = nil;
    @try {
        if (!_data || _data == nil || _data.length <= 0) { return nil; }
        
        CIFilter *qrCodeFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        if (qrCodeFilter == nil) { return nil; }
        [qrCodeFilter setDefaults];
        [qrCodeFilter setValue:_data forKey:@"inputMessage"];
        [qrCodeFilter setValue:@"L" forKey:@"inputCorrectionLevel"];
        
        CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
        if (colorFilter == nil) { return nil; }
        [colorFilter setDefaults];
        [colorFilter setValue:qrCodeFilter.outputImage forKey:@"inputImage"];
        [colorFilter setValue:[CIColor colorWithRed:0.0f green:0.0f blue:0.0f] forKey:@"inputColor0"];
        [colorFilter setValue:[CIColor colorWithRed:1.0f green:1.0f blue:1.0f] forKey:@"inputColor1"];
        
        r = colorFilter.outputImage;
        
    } @catch (NSException *exception) {
        NSLog(@"Error: %@", exception.reason);
    }
    return r;
}

@end
