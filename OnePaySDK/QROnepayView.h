#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QROnepayView : UIImageView

- (instancetype)init;
- (instancetype)initWithOtt:(NSString * _Nonnull)ott;
- (void)setOtt:(NSString * _Nonnull)ott;
@end

NS_ASSUME_NONNULL_END
