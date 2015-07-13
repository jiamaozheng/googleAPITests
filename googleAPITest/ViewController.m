//
//  ViewController.m
//  googleAPITest
//
//  Created by Jiamao Zheng on 7/10/15.
//  Copyright (c) 2015 Emerge Media. All rights reserved.
//https://developers.google.com/places/ios/current-place
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

static NSString * const kClientId = @"641220392338-pp1l0ku2iosvafg5ei8lcpug7ikvuac4.apps.googleusercontent.com";

@interface ViewController ()
@property (strong, nonatomic) UIActivityIndicatorView *myActivtyIndicator;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) GMSPlacesClient *placesClient;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO(developer) Configure the sign-in button look/feel
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    // Uncomment to automatically sign in the user.
//    [[GIDSignIn sharedInstance] signInSilently];
    // Do any additional setup after loading the view, typically from a nib.
    
//    Request authorization from CLLocationManager for the corresponding location method,
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    
    self.placesClient = [[GMSPlacesClient alloc]init];
    [self.placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *likelihoodList, NSError *error) {
        if (error != nil) {
            NSLog(@"Current Place error %@", [error localizedDescription]);
            return;
        }
        for (GMSPlaceLikelihood *likelihood in likelihoodList.likelihoods) {
            GMSPlace* place = likelihood.place;
            NSLog(@"Current Place name %@ at likelihood %g", place.name, likelihood.likelihood);
            NSLog(@"Current Place address %@", place.formattedAddress);
            NSLog(@"Current Place attributions %@", place.attributions);
            NSLog(@"Current PlaceID %@", place.placeID);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    [self.myActivtyIndicator stopAnimating];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapSignOut:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
}

@end
