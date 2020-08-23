#include "ios_functions.h"
//#import <Foundation/NSUserNotification.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/NSString.h>
#import <UIKit/UIKit.h>
#import <QGuiApplication>
#import <QQuickWindow>

void ios_functions::Display(const QString& title, const QString& text)
{
    /*    NSString*  titleStr = [[NSString alloc] initWithUTF8String:title.toUtf8().data()];
    NSString*  textStr = [[NSString alloc] initWithUTF8String:text.toUtf8().data()];

    NSUserNotification* userNotification = [[[NSUserNotification alloc] init] autorelease];
    userNotification.title = titleStr;
    userNotification.informativeText = textStr;

    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:userNotification];*/
}

int ios_functions::check_cam_permission()
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    if (status == AVAuthorizationStatusAuthorized)
    { // authorized
        return 1;
    }
    else if(status == AVAuthorizationStatusDenied)
    { // denied
        return 0;
    }
    else if(status == AVAuthorizationStatusRestricted)
    { // restricted
        return 0;
    }
    else if(status == AVAuthorizationStatusNotDetermined)
    { // not determined
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {}];
    }

    return 2;
}

void ios_functions::share(QString text)
{
    NSMutableArray *sharingItems = [NSMutableArray new];

    if (!text.isEmpty()) {
        [sharingItems addObject:text.toNSString()];
    }

    // Get the UIViewController
    UIViewController *qtController = [[UIApplication sharedApplication].keyWindow rootViewController];

    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [qtController presentViewController:activityController animated:YES completion:nil];

    /*    NSArray *objectsToShare = @[textToShare];

    NSString *textToShare = @"Look at this awesome website for aspiring iOS Developers!";

    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];

    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];

    activityVC.excludedActivityTypes = excludeActivities;

    [self presentViewController:activityVC animated:YES completion:nil]; */
}
