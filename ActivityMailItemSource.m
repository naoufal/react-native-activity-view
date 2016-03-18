#import "ActivityMailItemSource.h"

@interface ActivityMailItemSource()
@property (nonatomic) NSString* text;
@end

@implementation ActivityMailItemSource

+(instancetype)itemSourceWithText:(NSString*)text{
    return [[ActivityMailItemSource alloc] initWithText:text];
}


-(instancetype)initWithText:(NSString*)text{
    self = [super init];
    if(self){
        self.text = text;
    }
    return self;
}

#pragma mark - UIActivityItemSource protocol
- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController{
    return @"";
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType{
    return self.text;
}

- (NSString *)activityViewController:(UIActivityViewController *)activityViewController subjectForActivityType:(NSString *)activityType{
    if([UIActivityTypeMail isEqualToString:activityType])
        return self.text;
    return nil;
}

@end
