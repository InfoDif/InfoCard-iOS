//
//  InfoCardCreditCardInfo.h
//  infocard
//
//  Created by Gokhan Tekkaya on 19.11.2013.
//  Copyright (c) 2013 InfoDif. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

typedef NS_ENUM(NSInteger, InfoCardCreditCardType)
{
    CreditCardTypeUnknown = 0,
	CreditCardTypeAmex = 3,
    CreditCardTypeVisa = 4,
    CreditCardTypeMastercard = 5
};

@interface InfoCardCreditCardInfo : NSObject<NSCopying>
            
//if credit card number is partially scanned, characters that can not be scanned will be set to *
@property(nonatomic, copy, readwrite) NSString *cardNumber;

// expiryMonth & expiryYear may be 0, if expiry information is not requested
//2 characters representing expiry month 01-12
//if expiry month is partially scanned, characters that can not be scanned will be set to *
@property(nonatomic, copy, readwrite) NSString *expiryMonth;
//if expiry year is partially scanned, characters that can not be scanned will be set to *
@property(nonatomic, copy, readwrite) NSString *expiryYear; // the full four digit year

@property(nonatomic, copy, readwrite) NSString *cvv;
@property(nonatomic, assign, readwrite) InfoCardCreditCardType cardType;
@property(nonatomic, copy, readwrite) UIImage *blurredCardImage;
@end
