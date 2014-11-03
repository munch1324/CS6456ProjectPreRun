//
//  UIDDrawingViewController.h
//  UserInterfaceDesignRunning
//
//  Created by Michael Grande on 11/1/14.
//  Copyright (c) 2014 MLConsulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDDrawingViewController : UIViewController

@property (nonatomic) UIImage *baseImage;
@property (weak, nonatomic) IBOutlet UIImageView *drawingCanvasImageView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (IBAction)erasePressed:(id)sender;
- (IBAction)drawPressed:(id)sender;
@end
