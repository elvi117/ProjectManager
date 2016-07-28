//
//  UserInfoViewController.h
//  ZTI
//
//  Created by Lukasz Matuszczak on 15/01/16.
//  Copyright © 2016 IT Lite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyInfo.h"
#import "SWRevealViewController.h"
@interface UserInfoViewController : UIViewController
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * lastname;
@property ( nonatomic) NSInteger * isNotAboutMe;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameField;
@property (strong, nonatomic) NSString * userId;
@property (weak, nonatomic) IBOutlet UIButton *buttonOutlet;
- (IBAction)buttonZapisz:(id)sender;
@property (strong, nonatomic) UIBarButtonItem * sidebarButton;
@property (weak, nonatomic) IBOutlet UILabel *UUILabel;

@end
