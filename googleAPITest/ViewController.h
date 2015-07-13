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

@interface ViewController : UIViewController <GIDSignInUIDelegate, GPPSignInDelegate>

@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@property (weak, nonatomic) IBOutlet UITextField *searchALocation;


- (IBAction)didTapSignOut:(id)sender;
@end

