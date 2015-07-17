//
//  ViewController.m
//  googleAPITest
//
//  Created by Jiamao Zheng on 7/10/15.
//  Copyright (c) 2015 Emerge Media. All rights reserved.
//https://developers.google.com/places/ios/current-place

//https://developers.google.com/places/webservice/autocomplete

//http://stackoverflow.com/questions/10661707/displaying-suggested-locations-in-uitableview

//https://developers.google.com/maps/documentation/places/autocomplete

//http://stackoverflow.com/questions/28793940/how-to-add-google-places-autocomplete-to-xcode-with-swift-tutorial

//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>

static NSString * const kClientId = @"641220392338-pp1l0ku2iosvafg5ei8lcpug7ikvuac4.apps.googleusercontent.com";

@interface ViewController ()
@property (strong, nonatomic) UIActivityIndicatorView *myActivtyIndicator;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) GMSPlacesClient *placesClient;

@end


@implementation ViewController

@synthesize signInButton;

@synthesize liveClient;
@synthesize infoLabel;
NSString* APP_CLIENT_ID=@"000000004C159B30";

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
    
//    self.placesClient = [[GMSPlacesClient alloc]init];
//    [self.placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *likelihoodList, NSError *error) {
//        if (error != nil) {
//            NSLog(@"Current Place error %@", [error localizedDescription]);
//            return;
//        }
//        for (GMSPlaceLikelihood *likelihood in likelihoodList.likelihoods) {
//            GMSPlace* place = likelihood.place;
//            NSLog(@"Current Place name %@ at likelihood %g", place.name, likelihood.likelihood);
//            NSLog(@"Current Place address %@", place.formattedAddress);
//            NSLog(@"Current Place attributions %@", place.attributions);
//            NSLog(@"Current PlaceID %@", place.placeID);
//        }
//    }];
    
    
    
    //google+ login
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    
    // Uncomment one of these two statements for the scope you chose in the previous step
//    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
     signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
    
    [signIn trySilentAuthentication];
    
    
    
//    //windows sign in
//    self.liveClient = [[LiveConnectClient alloc] initWithClientId:APP_CLIENT_ID
//                                                         delegate:self
//                                                        userState:@"initialize"];
}

//- (void)authCompleted:(LiveConnectSessionStatus) status
//              session:(LiveConnectSession *) session
//            userState:(id) userState
//{
//    if ([userState isEqual:@"initialize"])
//    {
//        [self.infoLabel setText:@"Initialized."];
//        [self.liveClient login:self
//                        scopes:[NSArray arrayWithObjects:@"wl.signin", nil]
//                      delegate:self
//                     userState:@"signin"];
//    }
//    if ([userState isEqual:@"signin"])
//    {
//        if (session != nil)
//        {
//            [self.infoLabel setText:@"Signed in."];
//            [self performSegueWithIdentifier:@"jiamaozheng" sender:self];
//        }
//    }
//}
//
//- (void)authFailed:(NSError *) error
//         userState:(id)userState
//{

//    [self.infoLabel setText:[NSString stringWithFormat:@"Error: %@", [error localizedDescription]]];
//}


//google place api
- (void)placeAutocomplete {
    
//    GMSVisibleRegion visibleRegion = self.mapView.projection.visibleRegion;
//    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:visibleRegion.farLeft
//                                                                       coordinate:visibleRegion.nearRight];
//    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
//    filter.type = kGMSPlacesCityTypeFilter;
//    
//    [_placesClient autocompleteQuery:@"Sydney Oper"
//                              bounds:bounds
//                              filter:filter
//                            callback:^(NSArray *results, NSError *error) {
//                                if (error != nil) {
//                                    NSLog(@"Autocomplete error %@", [error localizedDescription]);
//                                    return;
//                                }
//                                
//                                for (GMSAutocompletePrediction* result in results) {
//                                    NSLog(@"Result '%@' with placeID %@", result.attributedFullText.string, result.placeID);
//                                }
//                            }];
    
    

}




//google plus sign in
-(void)refreshInterfaceBasedOnSignIn {
    if ([[GPPSignIn sharedInstance] authentication]) {
        // The user is signed in.
        self.signInButton.hidden = YES;
        // Perform other actions here, such as showing a sign-out button
    } else {
        self.signInButton.hidden = NO;
        // Perform other actions here
    }
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error) {
        // Do some error handling here.
    } else {
        [self refreshInterfaceBasedOnSignIn];
    }
}

- (void)signOut {
    [[GPPSignIn sharedInstance] signOut];
}

- (void)disconnect {
    [[GPPSignIn sharedInstance] disconnect];
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received error %@", error);
    } else {
        // The user is signed out and disconnected.
        // Clean up user data as specified by the Google+ terms.
    }
}



////google sign in
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//// Stop the UIActivityIndicatorView animation that was started when the user
//// pressed the Sign In button
//- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
//    [self.myActivtyIndicator stopAnimating];
//}
//
//// Present a view that prompts the user to sign in with Google
//- (void)signIn:(GIDSignIn *)signIn
//presentViewController:(UIViewController *)viewController {
//    [self presentViewController:viewController animated:YES completion:nil];
//}
//
//// Dismiss the "Sign in with Google" view
//- (void)signIn:(GIDSignIn *)signIn
//dismissViewController:(UIViewController *)viewController {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (IBAction)didTapSignOut:(id)sender {
//    [[GIDSignIn sharedInstance] signOut];
//}

- (IBAction)windowSignIn:(id)sender {
    
    
    //windows sign in
    self.liveClient = [[LiveConnectClient alloc] initWithClientId:APP_CLIENT_ID
                                                         delegate:self
                                                        userState:@"initialize"];
    
    
    if (self.liveClient.session == nil)
    {
        [self.liveClient login:self
                        scopes:[NSArray arrayWithObjects:@"wl.signin", nil ]
                      delegate:self
                     userState:@"signin"];
    }
    else
    {
        [self.liveClient logoutWithDelegate:self
                                  userState:@"signout"];
    }
    
}



- (void) authCompleted:(LiveConnectSessionStatus)status
               session:(LiveConnectSession *)session
             userState:(id)userState
{
    [self updateButtons];
    if (session != nil) {
        self.infoLabel.text = @"You are signed in.";
        [self performSegueWithIdentifier:@"jiamaozheng" sender:self];
    }
}

- (void) authFailed:(NSError *)error userState:(id)userState
{
    // Failed.
}

- (void) updateButtons {
    LiveConnectSession *session = self.liveClient.session;
    
    if (session == nil)
    {
        [self.signInButton setTitle:@"Sign in" forState:UIControlStateNormal];
    }
    else
    {
        [self.signInButton setTitle:@"Sign out" forState:UIControlStateNormal];
    }
}







@end
