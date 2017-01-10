#import "ActivityView.h"
#import <React/RCTLog.h>
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>
#import <React/RCTImageLoader.h>

@implementation ActivityView

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

// Map user passed array of strings to UIActivities
- (NSArray*)excludedActivitiesForKeys:(NSArray*)passedKeys {
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

RCT_EXPORT_METHOD(show:(NSDictionary *)args)
{
    NSString *imageUrl = args[@"imageUrl"];
    NSString *image = args[@"image"];
    NSString *imageBase64 = args[@"imageBase64"];

    __block UIImage *shareImage;

    if (image) {
      shareImage = [UIImage imageNamed:image];
    }

    if (imageBase64) {
      @try {
          NSData *decodedImage = [[NSData alloc] initWithBase64EncodedString:imageBase64
                                                                     options:NSDataBase64DecodingIgnoreUnknownCharacters];
          shareImage = [UIImage imageWithData:decodedImage];
      } @catch (NSException *exception) {
          RCTLogWarn(@"[ActivityView] Could not decode image");
      }
    }

    if (!imageUrl) {
      return [self showWithOptions:args image:shareImage];
    }

    RCTImageLoader *loader = (RCTImageLoader*)[self.bridge moduleForClass:[RCTImageLoader class]];

    __weak ActivityView *weakSelf = self;

    [loader loadImageWithTag:imageUrl callback:^(NSError *error, id imageOrData) {
        if (!error) {
          if ([imageOrData isKindOfClass:[NSData class]]) {
              shareImage = [UIImage imageWithData:imageOrData];
          } else {
              shareImage = imageOrData;
          }
        } else {
          RCTLogWarn(@"[ActivityView] Could not fetch image.");
        }

        dispatch_async([weakSelf methodQueue], ^{
            [weakSelf showWithOptions:args image:shareImage];
        });
    }];
}

- (void) showWithOptions:(NSDictionary *)args image:(UIImage *)image
{
    NSMutableArray *shareObject = [NSMutableArray array];
    NSString *text = args[@"text"];
    NSURL *url = args[@"url"];
    NSObject *file = args[@"file"];
    NSArray *activitiesToExclude = args[@"exclude"];

    // Return if no args were passed
    if (!text && !url && !image && !file) {
        RCTLogError(@"[ActivityView] You must specify a text, url, image, imageBase64 and/or imageUrl.");
        return;
    }

    if (text) {
        [shareObject addObject:text];
    }

    if (url) {
        [shareObject addObject:url];
    }

    if (image) {
        [shareObject addObject:image];
    }

    if (file) {
        [shareObject addObject:file];
    }


    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:shareObject applicationActivities:nil];

    activityView.excludedActivityTypes = activitiesToExclude
        ? [self excludedActivitiesForKeys:activitiesToExclude]
        : nil;

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
        NSNumber *anchorViewTag = [RCTConvert NSNumber:args[@"anchor"]];
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

@end
