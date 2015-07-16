//
//  ViewController.h
//  googleAPITest
//
//  Created by Jiamao Zheng on 7/10/15.
//  Copyright (c) 2015 Emerge Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import <GooglePlus/GooglePlus.h>
#import "LiveSDK/LiveConnectClient.h"

@class GPPSignInButton;

@interface ViewController : UIViewController <GIDSignInUIDelegate, GPPSignInDelegate, LiveAuthDelegate, LiveOperationDelegate, LiveDownloadOperationDelegate, LiveUploadOperationDelegate>


@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;


//@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@property (weak, nonatomic) IBOutlet UITextField *searchALocation;

@property (strong, nonatomic) LiveConnectClient *liveClient;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *windowsinginlabel;

//- (IBAction)didTapSignOut:(id)sender;
- (IBAction)windowSignIn:(id)sender;

@end

