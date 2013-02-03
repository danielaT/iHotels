//
//  SocialViewController.m
//  iHotels v1.0
//
//  Created by Desislava on 2/3/13.
//  Copyright (c) 2013 Student14. All rights reserved.
//

#import "SocialViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>

@interface SocialViewController ()

@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePhoto;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UIButton *facebookPost;
@property (weak, nonatomic) IBOutlet UIButton *twitterPost;

@end

@implementation SocialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.profilePhoto.hidden = YES;
    self.facebookPost.hidden = YES;
    self.twitterPost.hidden = YES;
    
    if (FBSession.activeSession.isOpen)
    {
        [self populateUserDetails];
    }
    
	// Do any additional setup after loading the view.
}

- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen)
    {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 //self.userNameLabel.text = user.name;
                 self.profilePhoto.profileID = user.id;
                 NSLog(@"user's id %@",self.profilePhoto.profileID);
             }
         }];
    }

}
- (IBAction)segmentedSwitch:(id)sender
{
    NSInteger selectedSegment = self.segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0)
    {
        self.profilePhoto.hidden = NO;
        self.facebookPost.hidden = NO;
        self.twitterPost.hidden = YES;
        if (!FBSession.activeSession.isOpen) {
            // if the session is closed, then we open it here, and establish a handler for state changes
            [FBSession.activeSession openWithCompletionHandler:^(FBSession *session,
                                                                 FBSessionState state,
                                                                 NSError *error) {
                switch (state) {
                    case FBSessionStateClosedLoginFailed:
                    {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                            message:error.localizedDescription
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                        [alertView show];
                    }
                        break;
                    default:
                        break;
                }
            }];
            [self populateUserDetails];
        }

        //toggle the correct view to be visible
    }
    else
    {
        //toggle the correct view to be visible
        self.profilePhoto.hidden = YES;
        self.facebookPost.hidden = YES;
        self.twitterPost.hidden = NO;

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    if (FBSession.activeSession.isOpen)
    {
        [self populateUserDetails];
    }
}
- (IBAction)postInFacebook:(id)sender
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookSheet setInitialText:@"post from my ios app"];
        
        [facebookSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        [self presentViewController:facebookSheet animated:YES completion:nil];
    }
}

- (IBAction)postInTwitter:(id)sender
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [facebookSheet setInitialText:@"post from my ios app"];
        
        [facebookSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Post Canceled");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Post Sucessful");
                    break;
                    
                default:
                    break;
            }
        }];
        [self presentViewController:facebookSheet animated:YES completion:nil];
    }

}


@end
