# InfoCard-iOS
InfoCard is a cross platform mobile SDK for credit card scanning. InfoCard can be used in M2C applications that needs credit card scanning.

InfoCard uses the mobile phones camera to scan the credit card with its built-in OCR. An internet connection may be needed to verify your application token.

This is an Xcode project of a sample application for demonstrating InfoCard SDK in IOS devices. InfoCard SDK requires IOS 6.0 at least. 

In order to extract the scanned card information you need to supply a valid SDK token in ViewController.mm. 

Just place your SDK token in places where you see the following

```
[scanOptions setInfocardSDKToken:@"Please use your SDK token here"];
```

Please visit www.infodif.com/infocard and contact us for a trial SDK token 
