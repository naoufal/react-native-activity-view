#import "ActivityView.h"
#import "RCTLog.h"
#import "RCTBridge.h"
#import "RCTUIManager.h"
#import "RCTUtils.h"

@implementation ActivityView

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

// Map user passed array of strings to UIActivities
- (NSArray*)excludedActivitiesForKeys:(NSArray*)passedKeys {
    if (!passedKeys) {
        return nil;
    }

    NSDictionary *activities = @{
       @"postToFacebook": UIActivityTypePostToFacebook,
       @"postToTwitter": UIActivityTypePostToTwitter,
       @"postToWeibo": UIActivityTypePostToWeibo,
       @"message": UIActivityTypeMessage,
       @"mail": UIActivityTypeMail,
       @"print": UIActivityTypePrint,
       @"copyToPasteboard": UIActivityTypeCopyToPasteboard,
       @"assignToContact": UIActivityTypeAssignToContact,
       @"saveToCameraRoll": UIActivityTypeSaveToCameraRoll,
       @"addToReadingList": UIActivityTypeAddToReadingList,
       @"postToFlickr": UIActivityTypePostToFlickr,
       @"postToVimeo": UIActivityTypePostToVimeo,
       @"postToTencentWeibo": UIActivityTypePostToTencentWeibo,
       @"airDrop": UIActivityTypeAirDrop
    };
    
    NSMutableArray *excludedActivities = [NSMutableArray new];
    
    [passedKeys enumerateObjectsUsingBlock:^(NSString *activityName, NSUInteger idx, BOOL *stop) {
        NSString *activity = [activities objectForKey:activityName];
        if (!activity) {
            RCTLogWarn(@"[ActivityView] Unknown activity to exclude: %@. Expected one of: %@", activityName, [activities allKeys]);
            return;
        }
        [excludedActivities addObject:activity];
    }];
    
    return excludedActivities;
}

- (UIActivityViewController *)activityViewFromDictionary:(NSDictionary *)args {
    NSMutableArray *shareObject = [NSMutableArray array];
    NSString *text = args[@"text"];
    NSURL *url = args[@"url"];
    NSString *imageUrl = args[@"imageUrl"];
    NSString *image = args[@"image"];
    NSData * imageData;
    
    // Try to fetch image
    if (imageUrl) {
        @try {
            imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imageUrl]];
        } @catch (NSException *exception) {
            RCTLogWarn(@"[ActivityView] Could not fetch image.");
        }
    }
    
    // Return if no args were passed
    if (!text && !url && !image && !imageData) {
        RCTLogError(@"[ActivityView] You must specify a text, url, image and/or imageUrl.");
        return nil;
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

    activityView.excludedActivityTypes = [self excludedActivitiesForKeys:args[@"exclude"]];
    
    return activityView;
}

- (void) displayActivityViewController:(UIActivityViewController *)activityView withAnchor:(NSNumber *)anchorViewTag {
    // Display the Activity View
    UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    /*
     * The `anchor` option takes a view to set as the anchor for the share
     * popup to point to, on iPads running iOS 8. If it is not passed, it
     * defaults to centering the share popup on screen without any arrows.
     * refer: (https://github.com/facebook/react-native/commit/f35fbc2a145f0097142d08920e141ea0cce2c31c)
     */
    if ([activityView respondsToSelector:@selector(popoverPresentationController)]) {
        activityView.popoverPresentationController.sourceView = ctrl.view;
        if (anchorViewTag) {
            UIView *anchorView = [self.bridge.uiManager viewForReactTag:anchorViewTag];
            activityView.popoverPresentationController.sourceRect = [anchorView convertRect:anchorView.bounds toView:ctrl.view];
        } else {
            CGRect sourceRect = CGRectMake(ctrl.view.center.x, ctrl.view.center.y, 1, 1);
            activityView.popoverPresentationController.sourceRect = sourceRect;
            activityView.popoverPresentationController.permittedArrowDirections = 0;
        }
    }
    [ctrl presentViewController:activityView animated:YES completion:nil];
}

RCT_EXPORT_METHOD(show:(NSDictionary *)args)
{
    UIActivityViewController* activityView = [self activityViewFromDictionary:args];
    
    if (activityView) {
        [self displayActivityViewController:activityView withAnchor:[RCTConvert NSNumber:args[@"anchor"]]];
    } else {
        return;
    }
}

RCT_EXPORT_METHOD(showWithCallback:(NSDictionary *)args callback:(RCTResponseSenderBlock)callback)
{
    UIActivityViewController* activityView = [self activityViewFromDictionary:args];
    
    if (activityView) {
        [activityView setCompletionWithItemsHandler:
            ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
                callback(@[RCTNullIfNil(activityType),
                           @(completed),
                           RCTNullIfNil(returnedItems),
                           RCTNullIfNil(activityError.localizedDescription)]);
            }
        ];
        [self displayActivityViewController:activityView withAnchor:[RCTConvert NSNumber:args[@"anchor"]]];
    } else {
        return;
    }
}

@end
