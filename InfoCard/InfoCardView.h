//
//  InfoCardView.h
//  infocard
//
//  Created by Gokhan Tekkaya on 19.11.2013.
//  Copyright (c) 2013 InfoDif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoCardViewDelegate.h"

typedef NS_ENUM(NSInteger, InfoCardScanType)
{
    InfoCardScanTypeFrontSide = 0,
    InfoCardScanTypeBackSide = 1
};

@interface InfoCardScanOptions : NSObject

//Default nil, show be filled with SDK token given to you
//sdk will not work without a valid token
@property(nonatomic, copy, readwrite) NSString *infocardSDKToken;

@property(nonatomic, copy, readwrite) NSString *guideMessage;

//Default YES
@property(nonatomic, assign, readwrite) BOOL manualEntryEanbled;

//Default "Manual Entry"
@property(nonatomic, copy, readwrite) NSString *manualEntryMessage;

//Default nil (No warning message is showed above guide message)
@property(nonatomic, copy, readwrite) NSString *warningMessage;

//Default InfoCardScanTypeFrontSide
@property(nonatomic, assign, readwrite) InfoCardScanType scanType;

//Default YES
@property(nonatomic, assign, readwrite) BOOL showGuideMessageWhenFocused;

//Default nil (Logo image max dimensions 150*75)
@property(nonatomic, copy, readwrite) UIImage *customLogo;

//Default YES
@property(nonatomic, assign, readwrite) BOOL showCurrentScanResult;

//Default YES
@property(nonatomic, assign, readwrite) BOOL showCounter;
//Default 15
@property(nonatomic, assign, readwrite) NSTimeInterval timeOutInSecs;

//Default YES
@property(nonatomic, assign, readwrite) BOOL blurCardArea;

//Deafult NO
@property (nonatomic, assign) BOOL returnFullSizeCardImage;

//Default YES
@property(nonatomic, assign, readwrite) BOOL drawCardTemplate;

@end

@interface InfoCardView : UIView

#pragma mark - Methods
/// Determine whether this device supports camera-based card scanning, considering
/// factors such as hardware support and OS version.
/// @return YES iff the user's device supports camera-based card scanning.
+ (BOOL)canReadCardWithCamera;

- (id)initWithFrame:(CGRect)frame options:(InfoCardScanOptions *)options;

#pragma mark - Properties you MUST set

/// Typically, your view controller will set itself as this delegate.
@property(nonatomic, strong, readwrite) id<InfoCardViewDelegate> delegate;

@end
