//
//  UserInfoViewController.m
//  ZTI
//
//  Created by Lukasz Matuszczak on 15/01/16.
//  Copyright © 2016 IT Lite. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.UUILabel.text = [MyInfo getToken ];
    self.sidebarButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_save.png"]
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(sideBarButtonAction)];
    self.navigationItem.rightBarButtonItem=self.sidebarButton;
    
    self.navigationController.navigationBar.tintColor =[UIColor colorWithRed:(231/255.0) green:(86/255.0) blue:(96/255.0) alpha:1];
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"Georgia" size:15];
    titleView.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    titleView.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleView.textColor = [UIColor colorWithRed:(231/255.0) green:(86/255.0) blue:(96/255.0) alpha:1]; // Your color here
    self.navigationItem.titleView = titleView;
    titleView.text =@"Z T I";
    [titleView sizeToFit];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        self.sidebarButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"31353.png"]
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(revealToggle:)];
        [self.sidebarButton setTarget: self.revealViewController];
        self.navigationItem.leftBarButtonItem=self.sidebarButton;
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }

    
    NSMutableURLRequest *request;
    if(self.isNotAboutMe >0){
     request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://zti-project-manager.meteor.com/api/ios/%@/user/%@", [MyInfo getToken], self.userId]]];}
    else {
         request = [NSMutableURLRequest
                                        requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://zti-project-manager.meteor.com/api/ios/%@/user/%@", [MyInfo getToken], [MyInfo getID]]]];
    
    }
    [request setHTTPMethod:@"GET"];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];

    if(self.isNotAboutMe == 0)
    {
        self.nameField.enabled = true;
        self.lastnameField.enabled = true;
        self.buttonOutlet.hidden = false;
    }
    else
        {
            self.nameField.enabled = false;
            self.lastnameField.enabled = false;
            self.buttonOutlet.hidden = true;
        }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString* newStr=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self parseJSON:newStr];
    
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{[self showAlert:@"Sprawdź połączenie z internetem":@"Ops!?"];
    
}

- (void)parseJSON: (NSString*) jsonText{
    
  
    NSData *data =  [jsonText dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:&error];
    
    if([json valueForKey:@"status" ] ==nil){

        self.nameField.text =[json valueForKey:@"firstName"]  ;
        self.lastnameField.text =[json valueForKey:@"lastName"]  ;
    
    }
    else if([[json valueForKey:@"status" ] isEqualToString:@"success"])
            [self showAlert:@"Zapisano poprawnie!": @""];
    
 
}
-(IBAction)showAlert:(NSString*) text :(NSString* ) subject
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: subject
                                                   message: text
                                                  delegate: self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    
    [alert show];
    
    
}


-(void) sideBarButtonAction{
    if (self.nameField.text.length <4 || self.lastnameField.text.length<4) {
        [self showAlert:@"Imię i nazwisko powinny zawierać minimul 3 znaki" :@"Uwaga" ];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://zti-project-manager.meteor.com/api/ios/%@/user/%@/%@", [MyInfo getToken], self.nameField.text, self.lastnameField.text]]];
    [request setHTTPMethod:@"POST"];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

@end
