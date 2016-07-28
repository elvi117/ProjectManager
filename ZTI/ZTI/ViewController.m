//
//  ViewController.m
//  ZTI
//
//  Created by Lukasz Matuszczak on 13/01/16.
//  Copyright © 2016 IT Lite. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
-(void) addAI{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    [self.spinner setTag:123];
   self.spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    self.spinner.layer.cornerRadius = 0;
    self.spinner.opaque = NO;
    self.spinner.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    self.spinner.center = self.view.center;
    self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.spinner setColor:[UIColor colorWithRed:0.6 green:0.8 blue:1.0 alpha:1.0]];
    [self.view addSubview:self.spinner]; // spinner is not visible until started
    [self.spinner startAnimating];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"Georgia" size:15];
    titleView.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    titleView.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleView.textColor = [UIColor colorWithRed:(231/255.0) green:(86/255.0) blue:(96/255.0) alpha:1]; // Your color here
    self.navigationItem.titleView = titleView;
    titleView.text =@"Z T I";
    [titleView sizeToFit];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpButton:(id)sender {
    [self addAI];
    if (self.passwordField.text.length < 6) {
        [self showAlert:@"Hasło powinno zawierać minimum 6 znaków"];
        return;
    }
    else{
        self.token=[self sha1:[NSString stringWithFormat:@"%@%@", self.passwordField.text, self.numberField.text]];
        
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://zti-project-manager.meteor.com/api/ios/%@/user", self.token]]];
    [request setHTTPMethod:@"GET"];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        self.buttonOutlet.enabled=false;
    }
   
   

}




- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{[self.spinner removeFromSuperview];
    
    
     NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString * outputValue =[self parseJSON:newStr] ;
    if ([outputValue isEqual:@"201"]) {
        //doNothing:)
    }
   else if( [outputValue isEqual:@"200"] && [MyInfo setToken:self.token] ){
        ProjectManagerView *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"ProjectManagerView"];

        [self.navigationController pushViewController:detail animated:YES];
    
        NSMutableURLRequest *request = [NSMutableURLRequest
                                        requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://zti-project-manager.meteor.com/api/ios/%@/yourid", self.token]]];
        [request setHTTPMethod:@"GET"];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    }
    else {self.buttonOutlet.enabled=true; [self showAlert:@"Błędny login lub hasło"];}
    self.passwordField.text=@"";
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{[self showAlert:@"Błąd logowania, sprawdź połączenie z internetem"];
    [self.spinner removeFromSuperview];
    self.buttonOutlet.enabled=true;
}

- (NSString *)parseJSON: (NSString*) jsonText{
  
    NSMutableArray *retval = [[NSMutableArray alloc]init];
    NSData *data =  [jsonText dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:&error];
    if([json valueForKey:@"userId" ] !=nil){
        [MyInfo setID:[json valueForKey:@"userId"]];
        return @"201";
    }
  else if([json valueForKey:@"status" ] ==nil){
        return  @"200";
    }
    else
        return [json valueForKey:@"status"];
        
}

-(NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}
-(IBAction)showAlert:(NSString*) text
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Ops!?"
                                                   message: text
                                                  delegate: self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    
    [alert show];
}

@end
