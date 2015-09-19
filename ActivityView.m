#import "ActivityView.h"
#import "RCTLog.h"

@implementation ActivityView

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(show:(NSDictionary *)args)
{
    NSMutableArray *shareObject = [NSMutableArray array];
    NSString *text = args[@"text"];
    NSURL *url = args[@"url"];
    NSString *imageUrl = args[@"imageUrl"];
    NSString *image = args[@"image"];
    NSDictionary *sourceFrame = args[@"sourceFrame"];
    NSData * imageData;
    
    // Try to fetch image
    if (imageUrl) {
        @try {
            imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageUrl]];
        } @catch (NSException *exception) {
            RCTLogWarn(@"Could not fetch image.");
        }
    }
    
    
    // Return if no args were passed
    if (!text && !url && !image && !imageData) {
        RCTLogError(@"[ActivityView] You must specify a text, url, image and/or imageUrl.");
        return;
    }
    
    if (text) {
        [shareObject addObject:text];
    }
    
    if (url) {
        [shareObject addObject:url];
    }
    
    if (image) {
        [shareObject addObject: [UIImage imageNamed: image]];
    } else if (imageData) {
        [shareObject addObject: [UIImage imageWithData: imageData]];
    }
    
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:shareObject applicationActivities:nil];
    
    // Display the Activity View
    UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    if ([activityView respondsToSelector:@selector(popoverPresentationController)]) {
        activityView.popoverPresentationController.sourceView = ctrl.view;
        if (sourceFrame != nil) {
            activityView.popoverPresentationController.sourceRect = CGRectMake([sourceFrame[@"x"] floatValue],
                                                                               [sourceFrame[@"y"] floatValue],
                                                                               [sourceFrame[@"width"] floatValue],
                                                                               [sourceFrame[@"height"] floatValue]);
        }
    }
    [ctrl presentViewController:activityView animated:YES completion:nil];
}

@end
