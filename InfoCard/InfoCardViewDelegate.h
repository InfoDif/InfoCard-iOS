//
//  InfoCardViewDelegate.h
//  infocard
//
//  Created by Gokhan Tekkaya on 19.11.2013.
//  Copyright (c) 2013 InfoDif. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InfoCardCreditCardInfo;
@class InfoCardView;

@protocol InfoCardViewDelegate <NSObject>

@required

/// This method will be called when the InfoCardView completes its work.
/// It is up to you to hide or remove the InfoCardView.
/// @param cardView The active InfoCardView.
/// @param cardInfo The results of the scan.
/// @note cardInfo will be nil if exiting due to a problem (e.g., no available camera).
- (void)cardView:(InfoCardView *)cardView scannedCard:(InfoCardCreditCardInfo *)cardInfo;

/// This method will be called when manual entry is selected by the user
- (void)manualEntrySelected:(InfoCardView *)cardView;

@end
