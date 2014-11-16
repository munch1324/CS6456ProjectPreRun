//
//  UIDPictureViewController.h
//  UserInterfaceDesignRunning
//
//  Created by Michael Grande on 11/3/14.
//  Copyright (c) 2014 MLConsulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDPictureViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *capturingImageView;
@property (weak, nonatomic) IBOutlet UIView *confirmationPrompt;

- (IBAction)capturePressed:(id)sender;
- (IBAction)retakePressed:(id)sender;
- (IBAction)usePressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *captureButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end
