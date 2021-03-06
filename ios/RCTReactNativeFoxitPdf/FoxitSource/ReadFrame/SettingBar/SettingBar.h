/**
 * Copyright (C) 2003-2017, Foxit Software Inc..
 * All Rights Reserved.
 *
 * http://www.foxitsoftware.com
 *
 * The following code is copyrighted and is the proprietary of Foxit Software Inc.. It is not allowed to
 * distribute any parts of Foxit Mobile PDF SDK to third party or public without permission unless an agreement
 * is signed between Foxit Software Inc. and customers to explicitly grant customers permissions.
 * Review legal.txt for additional license and legal information.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIExtensionsSharedHeader.h"

// item types in setting bar
typedef enum SettingItemType
{
    SINGLE,
    CONTINUOUS,
    DOUBLEPAGE,
    THUMBNAIL,
    ONLYTEXT,
    READ,
    CUTWHITEEDGE,
    LOCKSCREEN,
    LOCKZOOM,
    LOCKDRAGDIRECTION,
    BRIGHTNESS,
    NIGHTMODEL,
    SYSTEMBRIGHTNESS,
} SettingItemType;

typedef void (^single)(BOOL selected);
typedef void (^continuous)(BOOL selected);
typedef void (^doublepage)(BOOL selected);
typedef void (^thumbnail)(BOOL selected);
typedef void (^onlytext)(BOOL selected);
typedef void (^lockscreen)(BOOL selected);
typedef void (^nightmodel)(BOOL selected);

@class UIApplication;
@protocol IRotationEventListener;
@class FSPDFViewCtrl;
@class SettingBarController;

@protocol IAppLifecycleListener <NSObject>
@optional
- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)applicationDidBecomeActive:(UIApplication *)application;
@end

@interface SettingBar : NSObject<IAppLifecycleListener>

@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,copy)single single;
@property (nonatomic,copy)continuous continuous;
@property (nonatomic,copy)doublepage doublepage;
@property (nonatomic,copy)thumbnail thumbnail;
@property (nonatomic,copy)onlytext onlytext;
@property (nonatomic,copy)lockscreen lockscreen;
@property (nonatomic,copy)nightmodel nightmodel;
@property (nonatomic,weak) FSPDFViewCtrl* pdfViewCtrl;

@property (nonatomic, strong) UIButton *singleView_iphone;
@property (nonatomic, strong) UIButton *continueView_iphone;
@property (nonatomic, strong) UIButton *thumbnailView_iphone;
@property (nonatomic, strong) UIButton *singleView_ipad;
@property (nonatomic, strong) UIButton *continueView_ipad;
@property (nonatomic, strong) UIButton *thumbnailView_ipad;
@property (nonatomic, strong) UIButton *doubleView_ipad;

@property (nonatomic, strong) UIButton *reflowBtn;
@property (nonatomic, strong) UIButton *screenLockBtn_ipad;
@property (nonatomic, strong) UIButton *screenLockBtn;

- (instancetype)initWithPDFViewCtrl:(FSPDFViewCtrl*)pdfViewCtrl moreSettingBarController:(SettingBarController*)moreSettingBarController options:(NSDictionary*)options;
- (void)setItemState:(BOOL)state value:(float)value itemType:(SettingItemType)itemType;
@end
