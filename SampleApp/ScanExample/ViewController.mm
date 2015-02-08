//
//  ViewController.m
//  ScanExample
//
//  Copyright (c) 2013 Infodif. All rights reserved.
//

#import "ViewController.h"

#import "InfoCardViewDelegate.h"
#import "InfoCardView.h"
#import "InfoCardCreditCardInfo.h"

#include <iostream>
#include <sys/types.h>
#include <sys/sysctl.h>

@interface UIDeviceHardware : NSObject

+ (NSString *) platform;

@end

@implementation UIDeviceHardware

+ (NSString *) platform{
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = (char*)malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	NSString *platform = [NSString stringWithUTF8String:machine];
	free(machine);
	return platform;
}

@end
@interface ViewController () <InfoCardViewDelegate>
{
	InfoCardView *currentInfoCardView;
}

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISwitch *scanTypeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *scanTypeLabel;

@end

@implementation ViewController

#pragma mark - View Lifecycle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoLabel.text = @"";
    self.infoLabel.hidden=YES;
    self.imageView.hidden=YES;

    [self.scanTypeSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    //[self.imageView addSubview:self.infoLabel];
	currentInfoCardView = NULL;
}

#pragma mark - User Actions

- (void)switchValueChanged:(UISwitch *)theSwitch {
    if( theSwitch.on )
    {
        self.scanTypeLabel.text = @"Front Side";
    }
    else
    {
        self.scanTypeLabel.text = @"Back Side";
    }
}

- (void)scanCardClicked:(id)sender {
	InfoCardView *infoCardView = nil;
	CGRect tmpRect = self.view.bounds;
	//tmpRect.origin.y = tmpRect.origin.y + 44;
	//tmpRect.size.height = tmpRect.size.height - 44;
	
	InfoCardScanOptions *scanOptions = [[InfoCardScanOptions alloc]init];
	
    if( self.scanTypeSwitch.isOn == YES )
    {
		UIImage *logoImage = [UIImage imageNamed:@"logo_custom.png"];

        //infoCardView = [[InfoCardView alloc] initWithFrame:self.view.bounds
		[scanOptions setInfocardSDKToken:@"Please use your SDK token here"];
		
		[scanOptions setScanType:InfoCardScanTypeFrontSide];
		[scanOptions setGuideMessage:@"Hold your card inside the frame"];
		[scanOptions setManualEntryEanbled:YES];
		[scanOptions setManualEntryMessage:@"Manual Entry"];
		[scanOptions setShowCounter:YES];
		[scanOptions setTimeOutInSecs: 15.0];
		[scanOptions setShowCurrentScanResult:NO];
		[scanOptions setWarningMessage:@"No image being taken during this process"];
		[scanOptions setShowGuideMessageWhenFocused:NO];
		
		//NOTE Blurring of card area degrades performance on device IPhone4 and older
		//We suggest to turn off BlurCardArea option on these devices
		//You can use the code snippet given in this sample for that purpose.
		if ([[UIDeviceHardware platform] hasPrefix:@"iPhone3,"] ) {
			[scanOptions setBlurCardArea:NO];
		}
		else
		{
			[scanOptions setBlurCardArea:YES];
		}
		[scanOptions setCustomLogo:logoImage];
		[scanOptions setReturnFullSizeCardImage:YES];
		[scanOptions setDrawCardTemplate:YES];
		infoCardView = [[InfoCardView alloc] initWithFrame:tmpRect options:scanOptions ];
    }
    else
    {
		[scanOptions setInfocardSDKToken:@"Please use your SDK token here"];

		[scanOptions setScanType:InfoCardScanTypeBackSide];
		[scanOptions setGuideMessage:@"Hold your card inside the frame"];
		[scanOptions setManualEntryEanbled:NO];
		[scanOptions setManualEntryMessage:@"Manual Entry"];
		[scanOptions setShowCounter:NO];
		[scanOptions setTimeOutInSecs: 10.0];
		[scanOptions setShowCurrentScanResult:NO];
		[scanOptions setWarningMessage:nil];
		[scanOptions setShowGuideMessageWhenFocused:YES];
		[scanOptions setBlurCardArea:NO];
		[scanOptions setCustomLogo:nil];
		[scanOptions setReturnFullSizeCardImage:NO];
		[scanOptions setDrawCardTemplate:NO];
		infoCardView = [[InfoCardView alloc] initWithFrame:tmpRect options:scanOptions ];
    }
	currentInfoCardView = infoCardView;
    infoCardView.delegate = self;
    [self.view addSubview:infoCardView];
    infoCardView = nil;
}

#pragma mark - Delegate

/// This method will be called when the InfoCardView completes its work.
/// It is up to you to hide or remove the InfoCardView.
/// @param cardView The active InfoCardView.
/// @param cardInfo The results of the scan.
/// @note cardInfo will be nil if exiting due to a problem (e.g., no available camera).
- (void)cardView:(InfoCardView *)cardView scannedCard:(InfoCardCreditCardInfo *)cardInfo
{
    [self dismissViewControllerAnimated:YES completion:nil];
	
    if( cardInfo.cardNumber != nil )
    {
		if( cardInfo.cardNumber.length == 16 )
		{
        	self.infoLabel.text = [NSString stringWithFormat:@"%@-%@-%@-%@",
	        [cardInfo.cardNumber substringWithRange:NSMakeRange(0, 4)],
    	    [cardInfo.cardNumber substringWithRange:NSMakeRange(4, 4)],
        	[cardInfo.cardNumber substringWithRange:NSMakeRange(8, 4)],
        	[cardInfo.cardNumber substringWithRange:NSMakeRange(12, 4)]];
		}
		else if( cardInfo.cardNumber.length == 15 )
		{
        	self.infoLabel.text = [NSString stringWithFormat:@"%@-%@-%@",
								   [cardInfo.cardNumber substringWithRange:NSMakeRange(0, 4)],
								   [cardInfo.cardNumber substringWithRange:NSMakeRange(4, 6)],
								   [cardInfo.cardNumber substringWithRange:NSMakeRange(10, 5)]];
		}
        
        if( cardInfo.expiryMonth != nil && cardInfo.expiryYear != nil )
        {
            self.infoLabel.text = [NSString stringWithFormat:@"%@ %@/%@",
                                     self.infoLabel.text, cardInfo.expiryMonth, cardInfo.expiryYear];
 
        }
	}
    else if( cardInfo.cvv != nil )
    {
        self.infoLabel.text = cardInfo.cvv;
    }
    else
    {
        self.infoLabel.text = @"";
    }
    [self.imageView setImage:cardInfo.blurredCardImage];
    self.imageView.hidden=NO;
    self.infoLabel.hidden=NO;

    [self.view bringSubviewToFront:self.infoLabel];
	
    cardInfo.blurredCardImage = nil;
    cardInfo.cardNumber = nil;
    cardInfo.cvv = nil;
	
    [self.view willRemoveSubview:cardView];
    [cardView removeFromSuperview];
    cardView = nil;
    cardInfo = nil;
}

/// This method will be called when manual entry is selected by the user
- (void)manualEntrySelected:(InfoCardView *)cardView
{
	NSLog(@"Manual entry selected.");

	self.infoLabel.text = @"";
	self.imageView.hidden=NO;
	self.infoLabel.hidden=NO;

	[self.view bringSubviewToFront:self.infoLabel];

	[self.view willRemoveSubview:cardView];
	[cardView removeFromSuperview];
	cardView = nil;
}

@end
