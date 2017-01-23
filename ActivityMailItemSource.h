
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ActivityMailItemSource : NSObject<UIActivityItemSource>
+(instancetype)itemSourceWithText:(NSString*)text;

-(instancetype)initWithText:(NSString*)text;

@end
