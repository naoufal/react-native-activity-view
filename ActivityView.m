#import "ActivityView.h"
#import "RCTLog.h"

@implementation ActivityView

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(show:(NSDictionary *)args)
{
    NSMutableArray *shareObject = [NSMutableArray array];
    NSString *text = args[@"text"];
    NSURL *url = args[@"url"];
    NSString *imageUrl = args[@"imageUrl"];
    NSData * image;
    
    // Try to fetch image
    if (imageUrl) {
        @try {
            image = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageUrl]];
        } @catch (NSException *exception) {
            RCTLogWarn(@"Could not fetch image.");
        }
    }
    
    
    // Return if no args were passed
    if (!text && !url && !image) {
        RCTLogError(@"[ActivityView] You must specify a text, url and/or image.");
        return;
    }
    
    if (text) {
        [shareObject addObject:text];
    }
    
    if (url) {
        [shareObject addObject:url];
    }
    
    if (image) {
        [shareObject addObject: [UIImage imageWithData: image]];
    }
    
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:shareObject applicationActivities:nil];
    
    // Display the Activity View
    UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [ctrl presentViewController:activityView animated:YES completion:nil];
}

@end
