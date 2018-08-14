#define rgb(r, g, b) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0]
#import <UIKit/UIKit.h>
#include <OBSUtilities/OBSUtilities.h>
#include "BSProvider.h"


@interface NSUserDefaults (Tweak)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

//static NSString *nsDomainString = @"/var/mobile/Library/Preferences/com.midnightchips.bettersettings10";
static NSString *nsNotificationString = @"com.midnightchips.bettersettings10/preferences.changed";
static NSString *nsColor = @"/var/mobile/Library/Preferences/com.midnightchips.bettersettings10.color";
static NSString *tableImage = @"/User/Library/Preferences/BetterSettings/tableImage.png";
static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
        //NSString *sFront = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"statusFront" inDomain:nsDomainString];

        //	statusFront = sFront;
}

//Set Preset on first load

@interface UIApplication (existing)
- (void)suspend;
- (void)terminateWithSuccess;
@end
@interface UIApplication (close)
- (void)close;
@end
@implementation UIApplication (close)

- (void)close {
        // Check if the current device supports background execution.
        BOOL multitaskingSupported = NO;
        // iOS < 4.0 compatibility check.
        if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])
                multitaskingSupported = [UIDevice currentDevice].multitaskingSupported;
        // Good practice, we're using a private method.
        if ([self respondsToSelector:@selector(suspend)])
        {
                if (multitaskingSupported)
                {
                        [self beginBackgroundTaskWithExpirationHandler:^{}];
                        // Change the delay to your liking. I think 0.4 seconds feels just right (the "close" animation lasts 0.3 seconds).
                        [self performSelector:@selector(exit) withObject:nil afterDelay:0.4];
                }
                [self suspend];
        }
        else
                [self exit];
}
- (void)exit {
        // Again, good practice.
        if ([self respondsToSelector:@selector(terminateWithSuccess)])
                [self terminateWithSuccess];
        else
                exit(EXIT_SUCCESS);
}

@end

%hook PSUIPrefsListController
@interface PSUIPrefsListController : UIViewController
@end

@interface SBApplication : NSObject
@end

@interface SBApplicationController : NSObject
+ (id)sharedInstance;
- (id)applicationWithBundleIdentifier:(id)arg1;
@end

-(void)viewDidAppear:(BOOL)animated {

        %orig;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:@"/var/mobile/Library/Preferences/BetterSettings/preset"]) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Hi!"
                                            message:@"It appears this is your first time using this tweak. Which Preset would you like?"
                                            preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction* bubble = [UIAlertAction actionWithTitle:@"Dark Bubbles" style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                                 [fileManager createDirectoryAtPath:@"/var/mobile/Library/Preferences/BetterSettings/" withIntermediateDirectories:NO attributes:nil error:nil];
                                                 [fileManager createFileAtPath:@"/var/mobile/Library/Preferences/BetterSettings/preset" contents:nil attributes:nil];
                                                 NSDictionary* dict = @{@"statusColor":@"FFFFFF", @"tableColor":@"000000", @"enableImage":@NO, @"tintNav":@NO, @"navTint":@"000000", @"cornerRadius":@12, @"bubbleColor":@"26252A", @"textTint":@"FFFFFF", @"borderWidth":@3,@"borderColor":@"000000",@"bubbleSelectionColor":@"000000", @"buttonTint":@"FFFFFF", @"hideIcons":@NO, @"CleanSettings":@NO};
                                                 [dict writeToFile:@"/var/mobile/Library/Preferences/com.midnightchips.bettersettings.plist" atomically:YES];
                                                 [[UIApplication sharedApplication] close];
                                                 [[UIApplication sharedApplication] terminateWithSuccess];
                                         }];
                UIAlertAction* whiteBubble = [UIAlertAction actionWithTitle:@"Light Bubbles" style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction * action) {
                                                      [fileManager createDirectoryAtPath:@"/var/mobile/Library/Preferences/BetterSettings/" withIntermediateDirectories:NO attributes:nil error:nil];
                                                      [fileManager createFileAtPath:@"/var/mobile/Library/Preferences/BetterSettings/preset" contents:nil attributes:nil];
                                                      NSDictionary* dict = @{@"statusColor":@"000000", @"tableColor":@"FFFFFF", @"enableImage":@NO, @"tintNav":@NO, @"navTint":@"000000", @"cornerRadius":@12, @"bubbleColor":@"F6F6F6", @"textTint":@"000000", @"borderWidth":@3,@"borderColor":@"FFFFFF",@"bubbleSelectionColor":@"E9E9E9", @"buttonTint":@"000000", @"hideIcons":@NO, @"CleanSettings":@NO};
                                                      [dict writeToFile:@"/var/mobile/Library/Preferences/com.midnightchips.bettersettings.plist" atomically:YES];
                                                      [[UIApplication sharedApplication] close];
                                                      [[UIApplication sharedApplication] terminateWithSuccess];
                                              }];
                UIAlertAction* darkClean = [UIAlertAction actionWithTitle:@"Dark Clean" style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                    [fileManager createDirectoryAtPath:@"/var/mobile/Library/Preferences/BetterSettings/" withIntermediateDirectories:NO attributes:nil error:nil];
                                                    [fileManager createFileAtPath:@"/var/mobile/Library/Preferences/BetterSettings/preset" contents:nil attributes:nil];
                                                    NSDictionary* dict = @{@"statusColor":@"FFFFFF", @"tableColor":@"000000", @"enableImage":@NO, @"tintNav":@NO, @"navTint":@"000000", @"cornerRadius":@0, @"bubbleColor":@"161616", @"textTint":@"FFFFFF", @"borderWidth":@0,@"borderColor":@"000000",@"bubbleSelectionColor":@"25000000", @"buttonTint":@"FFFFFF", @"hideIcons":@NO, @"CleanSettings":@YES};
                                                    [dict writeToFile:@"/var/mobile/Library/Preferences/com.midnightchips.bettersettings.plist" atomically:YES];
                                                    [[UIApplication sharedApplication] close];
                                                    [[UIApplication sharedApplication] terminateWithSuccess];
                                            }];

                UIAlertAction* image = [UIAlertAction actionWithTitle:@"Transparent with Background Image" style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                                [fileManager createDirectoryAtPath:@"/var/mobile/Library/Preferences/BetterSettings/" withIntermediateDirectories:NO attributes:nil error:nil];
                                                [fileManager createFileAtPath:@"/var/mobile/Library/Preferences/BetterSettings/preset" contents:nil attributes:nil];
                                                NSDictionary* dict = @{@"statusColor":@"FFFFFFFF", @"tableColor":@"00000000", @"enableImage":@YES, @"tintNav":@YES, @"navTint":@"42000000", @"cornerRadius":@0, @"bubbleColor":@"0026252A", @"textTint":@"FFFFFF", @"borderWidth":@0,@"borderColor":@"00000000",@"bubbleSelectionColor":@"34000000", @"buttonTint":@"FFFFFF", @"hideIcons":@NO, @"CleanSettings":@NO};
                                                [dict writeToFile:@"/var/mobile/Library/Preferences/com.midnightchips.bettersettings.plist" atomically:YES];
                                                if (![fileManager fileExistsAtPath:@"/var/mobile/Library/Preferences/BetterSettings/tableImage.png"]) {
                                                        [[NSFileManager defaultManager] copyItemAtPath:@"/Library/PreferenceBundles/BetterSettings.bundle/tableImage.png" toPath:@"/var/mobile/Library/Preferences/BetterSettings/tableImage.png" error:nil];
                                                        [[UIApplication sharedApplication] close];
                                                        [[UIApplication sharedApplication] terminateWithSuccess];
                                                }

                                        }];


                [alert addAction:bubble];
                [alert addAction:whiteBubble];
                [alert addAction:darkClean];
                [alert addAction:image];
                [self presentViewController:alert animated:YES completion:nil];

        }

}
%end

%hook UIStatusBar

@interface UIStatusBar : UIView
@property (nonatomic, retain) UIColor *foregroundColor;
@end
-(void)layoutSubviews {
        %orig;
        self.foregroundColor = [prefs colorForKey:@"statusColor"];
        if([prefs boolForKey:@"enableImage"]) {
                if(![prefs boolForKey:@"tintNav"]) {
                        self.backgroundColor = [UIColor clearColor];
                }else{
                        self.backgroundColor = [prefs colorForKey:@"navTint"];
                }

        }else{
                self.backgroundColor = [prefs colorForKey:@"tableColor"];
        }


}
%end

%hook UINavigationBar

@interface UINavigationBar (Settings)
-(void)setLargeTitleTextAttributes:(NSDictionary *)arg1;
@end
//Has to be layoutSubviews, as without it Cephei prefs brake this.
-(void)layoutSubviews {
        %orig;
        //Sets bar style, removes white Bar
        [self setBarStyle:UIBarStyleBlack];

        //Sets title Text to white

        self.titleTextAttributes = @{NSForegroundColorAttributeName: [prefs colorForKey:@"textTint"]};

        //Tints the Buttons TODO text color
        self.tintColor = [prefs colorForKey:@"buttonTint"];

        //Hide background Image of NavBar, Makes black/ background image stand out
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];


        //Set BackgroundColor of NavBar, clear for backgroundImage
        if([prefs boolForKey:@"enableImage"]){
           if([prefs boolForKey:@"tintNav"]){
            [self setBackgroundColor:[prefs colorForKey:@"navTint"]];
           }else{
            [self setBackgroundColor:[UIColor clearColor]];
           }
           }else{
        [self setBackgroundColor:[prefs colorForKey:@"tableColor"]];
      }


        //Shadow ¯\_(ツ)_/¯ not sure what this does, but uhh... the code doesnt work without it.
        //self.shadowImage = [UIImage new];

        //Sets the NavBar transparent, scrolling etc.
        //Keep this on, otherwise it breaks the background of searching
        self.translucent = YES;
}
%end


%hook UITextField
-(void)didMoveToWindow{
        %orig;
        self.backgroundColor = [UIColor clearColor];
        /*if([prefs boolForKey:@"adaptiveColor"]){
           UIImage *textImage = [UIImage imageWithData:tableImage];
           UIColor *avgColor = imageAverageColor(textImage);
           self.textColor = avgColor;
           }else{*/
        self.textColor = [prefs colorForKey:@"textTint"];//[prefs colorForKey:@"textTint"];


}
%end

%hook UISearchBar
-(void)layoutSubviews{
        %orig;
        MSHookIvar<UIView*>(self, "_background").hidden = YES;
}
%end

%hook UILabel
-(void)layoutSubviews{
        %orig;

        self.textColor = [prefs colorForKey:@"textTint"];
        self.backgroundColor = [UIColor clearColor];
}
%end

%hook UITableViewCell
-(void)didMoveToWindow {
        %orig;
        //Corners of the Tables

        //ENDED ON CORNER RADIUS
        //TODO FINISH THIS :P
        [self.layer setCornerRadius:[prefs floatForKey:@"cornerRadius"]];

        [self setBackgroundColor: [prefs colorForKey:@"bubbleColor"]];
        //Border Color and Width
        [self.layer setBorderColor:[prefs colorForKey:@"borderColor"].CGColor];
        [self.layer setBorderWidth:[prefs floatForKey:@"borderWidth"]];

        //Set Text Color
        /*if([prefs boolForKey:@"adaptiveColor"]){
           UIImage *textImage = [UIImage imageWithData:tableImage];
           UIColor *avgColor = imageAverageColor(textImage);
           self.textLabel.textColor = avgColor;
           self.detailTextLabel.textColor = avgColor;
           }else{
           self.textLabel.textColor = [prefs colorForKey:@"textTint"];//[prefs colorForKey:@"textTint"];
           self.detailTextLabel.textColor = [prefs colorForKey:@"textTint"];//[prefs colorForKey:@"textTint"];
           }*/
        self.textLabel.textColor = [prefs colorForKey:@"textTint"];
        self.detailTextLabel.textColor = [prefs colorForKey:@"textTint"];
        self.clipsToBounds = YES;
        MSHookIvar<UIColor*>(self, "_selectionTintColor") = [prefs colorForKey:@"bubbleSelectionColor"];



        //Background Color of Corners

        //self.selectionTintColor = [UIColor blackColor];
}
%end

%hook UITableView
//Resize Image Interface and Implementation
@interface UIImage (ResizeImage)
- (UIImage *)imageScaledToSize:(CGSize)newSize;
@end
//Implementation
@implementation UIImage (ResizeImage)

- (UIImage *)imageScaledToSize:(CGSize)newSize {
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
}

@end

-(void)didMoveToWindow {
        %orig;
        //No Separators in the Tables
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        //Set the background Color to a Color or to an Image
        //self.backgroundColor = [UIColor blackColor];
        //Set the Background to an Image, Importing UIImage+ScaledImage.h for this
        if([prefs boolForKey:@"enableImage"]){              //TODO CHANGE THE IMAGE TO PICKING AN IMAGE
           UIImage *bgImage = [[UIImage imageWithContentsOfFile:tableImage] imageScaledToSize:[[UIApplication sharedApplication] keyWindow].bounds.size];
           self.backgroundView = [[UIImageView alloc] initWithImage: bgImage];
           }else{
           self.backgroundColor = [prefs colorForKey:@"tableColor"];
           }
        MSHookIvar<UIView*>(self, "_tableHeaderBackgroundView").backgroundColor = [UIColor clearColor];

}
-(void)layoutSubviews {
        %orig;
        MSHookIvar<UIView*>(self, "_tableHeaderBackgroundView").backgroundColor = [UIColor clearColor];
}
%end

@interface UIInterfaceActionGroupView : UIView
@end

@interface _UIAlertControllerInterfaceActionGroupView : UIInterfaceActionGroupView
@end

@interface _UIAlertControlleriOSActionSheetCancelBackgroundView : UIView
@end

%hook UIAlertControllerVisualStyleAlert

- (UIColor *)titleLabelColor {
        return UIColor.blackColor;
}

- (UIColor *)messageLabelColor {
        return UIColor.blackColor;
}

%end

// color of title and body of action sheets
%hook UIAlertControllerVisualStyleActionSheet

- (UIColor *)titleLabelColor {
        return UIColor.blackColor;
}

- (UIColor *)messageLabelColor {
        return UIColor.blackColor;
}


%end

//Sets Background
%hook _UIAlertControllerInterfaceActionGroupView

- (void)layoutSubviews {
        %orig;

        UIView *filterView = self.subviews.firstObject.subviews.lastObject.subviews.lastObject;
        filterView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];

        UIView *labelHolder = self.subviews.lastObject.subviews.firstObject.subviews.firstObject;
        for (UILabel *label in labelHolder.subviews) {
                if ([label respondsToSelector:@selector(setTextColor:)]) {
                        label.textColor = UIColor.whiteColor;
                }
        }
}

%end

%hook PUCollectionView
@interface PUCollectionView : UIView
@end
-(void)didMoveToWindow {
        %orig;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([prefs boolForKey:@"enableImage"]){
          if (![fileManager fileExistsAtPath:@"/var/mobile/Library/Preferences/BetterSettings/tableImage.png"]){
            self.backgroundColor = [prefs colorForKey:@"tableColor"];
          }
           UIImage *bgImage = [[UIImage imageWithContentsOfFile:tableImage] imageScaledToSize:[[UIApplication sharedApplication] keyWindow].bounds.size];
           self.backgroundColor = [UIColor colorWithPatternImage:bgImage];
           }else{
             self.backgroundColor = [UIColor blackColor];
        }
}
%end
//Fix the White gaps
%hook _UITableViewHeaderFooterViewBackground

@interface _UITableViewHeaderFooterViewBackground : UIView
@end

-(void)didMoveToWindow {
        %orig;
        self.backgroundColor = [UIColor clearColor];
}
%end

//Siri
%hook SiriFooterView
-(void)layoutSubviews{
        %orig;
        MSHookIvar<UITextView*>(self, "_textView").textColor = [prefs colorForKey:@"textTint"];
}
%end

/*%hook UIDatePicker
-(void)didMoveToWindow{
        %orig;
        self.backgroundColor = [UIColor blackColor];

}
%end*/
/*%hook UIPickerTableView
   -(void)didMoveToWindow{
   %orig;
   [self setCornerRadius:0];

   [self setBackgroundColor: rgb(38, 37, 42)];
   //Border Color and Width
   [self setBorderColor:[UIColor blackColor].CGColor];
   [self setBorderWidth:0];
   }
   %end*/

%hook PSBulletedPINView
@interface PSBulletedPINView : UIView
@end
-(void)didMoveToWindow {
        %orig;
        if(![prefs boolForKey:@"enableImage"]) {
              self.backgroundColor = [prefs colorForKey:@"tableColor"];
        }else{
                   //self.backgroundColor =
          UIImage *bgImage = [[UIImage imageWithContentsOfFile:tableImage] imageScaledToSize:[[UIApplication sharedApplication] keyWindow].bounds.size];
          self.backgroundColor = [UIColor colorWithPatternImage:bgImage];//[[UIImageView alloc] initWithImage: bgImage];
        }
}
%end

%hook PSPasscodeField
@interface PSPasscodeField : UIView
@property (nonatomic, strong) UIColor *foregroundColor;
@end
-(void)didMoveToWindow {
      %orig;
      self.foregroundColor = [prefs colorForKey:@"textTint"];
}
%end

%hook DevicePINPane
@interface DevicePINPane : UIView
@end
-(void)didMoveToWindow {
        %orig;
        if(![prefs boolForKey:@"enableImage"]) {
                self.backgroundColor = [prefs colorForKey:@"tableColor"];
        }else{
                self.backgroundColor = [UIColor blackColor];
        }

}
%end

BOOL enabled = YES;
BOOL shouldIgnoreRules = YES;
CGFloat inset = 16.0; //the indent
CGFloat customCornerRadius = 10;
%hook UITableView

/* iOS 6 - 11.1.2 */
- (UIEdgeInsets)_sectionContentInset {
        if([prefs boolForKey:@"CleanSettings"]) {
                UIEdgeInsets orig = %orig;
                if (!shouldIgnoreRules && (orig.left > 0 || orig.right > 0))
                        return orig;
                return UIEdgeInsetsMake(orig.top, inset, orig.bottom, inset);
        }
        else {return %orig;}
}
- (void)_setSectionContentInset:(UIEdgeInsets)insets {
        if([prefs boolForKey:@"CleanSettings"]) {
                if (enabled && shouldIgnoreRules)
                        %orig(UIEdgeInsetsMake(insets.top, inset, insets.bottom, inset));
                else
                        %orig;
        }
        else {%orig;}
}
/* Remove separator lines
 * (iOS 6 - 11.1.2)
 */
-(void)setDelegate:(id)arg1 {
        if([prefs boolForKey:@"CleanSettings"]) {
                self.separatorStyle = UITableViewCellSeparatorStyleNone;
                %orig;
        }
        else {%orig;}
}

%end

%hook PSTableCell
- (void)setIcon: (id)arg1 {
        //Yes This way makes no sense. Leave me alone
        if(![prefs boolForKey:@"hideIcons"]) {
                //return Nothing
                return %orig;
        }else{
                //Other wise be Normal
                nil;
        }
}
%end

%ctor{
        notificationCallback(NULL, NULL, NULL, NULL, NULL);
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                        NULL,
                                        notificationCallback,
                                        (CFStringRef)nsNotificationString,
                                        NULL,
                                        CFNotificationSuspensionBehaviorCoalesce);
}
