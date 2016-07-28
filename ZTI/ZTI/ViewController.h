//
//  ViewController.h
//  ZTI
//
//  Created by Lukasz Matuszczak on 13/01/16.
//  Copyright © 2016 IT Lite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "ProjectManagerView.h"
#import "MyInfo.h"
#import "SWRevealViewController.h"
@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *numberField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)signUpButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonOutlet;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@end

