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
static NSString* const APP_CLIENT_ID=@"000000004C159B30";


#pragma mark - Output handling
- (void) handleException:(id)exception
                 context:(NSString *)context
{
    NSLog(@"Exception received. Context: %@", context);
    NSLog(@"Exception detail: %@", exception);
    
    [self appendOutput:[NSString stringWithFormat:@"Exception received. Context: %@", context]];
    [self appendOutput:[NSString stringWithFormat:@"Exception detail: %@", exception]];
}

- (void) handleError:(NSError *)error
             context:(NSString *)context
{
    NSLog(@"Error received. Context: %@", context);
    NSLog(@"Error detail: %@", error);
    
    [self appendOutput:[NSString stringWithFormat:@"Error received. Context: %@", context]];
    [self appendOutput:[NSString stringWithFormat:@"Error detail: %@", error]];
}

- (void) appendOutput:(NSString *)text
{
    if (text)
    {
        self.output.text = [self.output.text stringByAppendingFormat:@"\r\n%@",text];
    }
}

- (void) clearOutput
{
    self.output.text = @"";
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureLiveClientWithScopes:@"wl.signin wl.basic wl.skydrive"];
    [self clearOutput];
}

- (void)viewDidUnload
{
//    [self setScopesTextField:nil];
    [self setSignInButton:nil];
//    [self setPathTextField:nil];
    [self setOutput:nil];
   
    [super viewDidUnload];
}

#pragma mark - Auth methods

- (void) configureLiveClientWithScopes:(NSString *)scopeText
{
//    if ([APP_CLIENT_ID isEqualToString:@"000000004C159B30"]) {
//        [NSException raise:NSInvalidArgumentException format:@"The CLIENT_ID value must be specified."];
//    }
    
    self.liveClient = [[LiveConnectClient alloc] initWithClientId:APP_CLIENT_ID
                                                            scopes:[scopeText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                                          delegate:self
                                                         userState:@"init"];
}

- (void) loginWithScopes:(NSString *)scopeText
{
    @try
    {
        NSArray *scopes = [scopeText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self.liveClient login:self
                   scopes:scopes
                 delegate:self
                userState:@"login"];
    }
    @catch(id ex)
    {
        [self handleException:ex context:@"loginWithScopes"];
    }
}

- (void) logout
{
    @try
    {
        [self.liveClient logoutWithDelegate:self userState:@"logout"];
    }
    @catch(id ex)
    {
        [self handleException:ex context:@"logout"];
    }
}

- (void) updateSignInButton
{
    LiveConnectSession *session = self.liveClient.session;
    
    if (session == nil)
    {
        [self.signInButton setTitle:@"Jiamao Zheng Sign in" forState:UIControlStateNormal];
    }
    else
    {
        [self.signInButton setTitle:@"Jiamao Zheng Sign out" forState:UIControlStateNormal];
    }
}

- (IBAction)windowSignIn:(id)sender {

    if (self.liveClient.session == nil)
    {
        [self loginWithScopes:@"wl.signin wl.basic wl.skydrive"];
    }
    else
    {
        [self logout];
    }

}

- (IBAction)onClickGetButton:(id)sender
{
    @try
    {
        [self.liveClient getWithPath:@"me"
                            delegate:self
                           userState:@"get"];
    }
    @catch (id ex)
    {
        [self handleException:ex context:@"get"];
    }
    @finally
    {
//        [self closeKeyboard];
    }
}

- (IBAction)onClickDownloadButton:(id)sender
{
    @try
    {
        [self.liveClient downloadFromPath:@"me"
                                 delegate:self
                                userState:@"download"];
    }
    @catch (id ex)
    {
        [self handleException:ex context:@"download"];
    }
    @finally
    {
//        [self closeKeyboard];
    }
}

#pragma mark LiveAuthDelegate

- (void) authCompleted: (LiveConnectSessionStatus) status
               session: (LiveConnectSession *) session
             userState: (id) userState
{
    NSString *scopeText = [session.scopes componentsJoinedByString:@" "];
    [self appendOutput:[NSString stringWithFormat:@"%@ succeeded. scopes: %@",userState, scopeText]];
    [self updateSignInButton];
}

- (void) authFailed: (NSError *) error
          userState: (id)userState
{
    [self handleError:error
              context:[NSString stringWithFormat:@"auth failed during %@", userState ]];
}


#pragma mark LiveOperationDelegate

- (void) liveOperationSucceeded:(LiveOperation *)operation
{
    [self appendOutput: [NSString stringWithFormat:@"The operation '%@' succeeded.", operation.userState]];
    if (operation.rawResult)
    {
        [self appendOutput:operation.rawResult];
    }
    
    if ([operation.userState isEqual:@"download"])
    {
        LiveDownloadOperation *downloadOp = (LiveDownloadOperation *)operation;
        self.imgView.image = [UIImage imageWithData:downloadOp.data];
        
    }
}



//- (void) liveOperationFailed:(NSError *)error
//                   operation:(LiveOperation *)operation
//{
//    [self handleError:error context:operation.userState];
//}
//
//- (void) liveDownloadOperationProgressed:(LiveOperationProgress *)progress data:(NSData *)receivedData operation:(LiveDownloadOperation *)operation
//{
//    NSString *text = [NSString stringWithFormat:@"Download in progress..%u bytes(%f %%, total %u bytes) has been transferred.", (unsigned int)progress.bytesTransferred, progress.progressPercentage * 100, (unsigned int)progress.totalBytes ];
//    [self appendOutput:text];
//}
//
//- (void) liveUploadOperationProgressed:(LiveOperationProgress *)progress
//                             operation:(LiveOperation *)operation
//{
//    NSString *text = [NSString stringWithFormat:@"Upload in progress. %u bytes(%f %%, total %u bytes) has been transferred.", (unsigned int)progress.bytesTransferred, progress.progressPercentage * 100, (unsigned int)progress.totalBytes ];
//    [self appendOutput:text];
//}
@end
