//
//  TaskAddViewController.m
//  ZTI
//
//  Created by Lukasz Matuszczak on 15/01/16.
//  Copyright © 2016 IT Lite. All rights reserved.
//

#import "TaskAddViewController.h"

@interface TaskAddViewController ()

@end

@implementation TaskAddViewController

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
  
    
//    self.sidebarButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"airbrush_add.png"]
//                                                       style:UIBarButtonItemStylePlain
//                                                      target:self
//                                                      action:@selector(sideBarButtonAction)];
    
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

    
    self.descField.layer.borderWidth = 5.0f;
    self.descField.layer.borderColor = [[UIColor grayColor] CGColor];
    self.nameField.delegate=self;
    self.descField.delegate=self;
    self.termField.delegate=self;
    self.textFieldWithDesc.delegate=self;
    self.developerField.delegate = self;
   
    self.statusArray = [[NSArray alloc]init];
    self.statusArray = @[@"Utworzone" , @"Przypisane", @"Rozpoczęte" , @"Testowane", @"Zakończone"];

    
    self.statusField.delegate=self;
    // Do any additional setup after loading the view.
    if(self.taskObject != nil){
    
        self.nameField.text = self.taskObject.taskName;
        self.descField.text = self.taskObject.taskDesc;
        self.textFieldWithDesc.text = self.taskObject.taskDesc;
        self.termField.text = self.taskObject.taskTerm;
        self.progressLabel.text =[NSString stringWithFormat:@"Progress= %@ %%", self.taskObject.taskProgress];
        self.sliderOutlet.value = [self.taskObject.taskProgress floatValue];
        self.statusField.text = [self.statusArray objectAtIndex: [self.taskObject.status intValue]];
        
        for (NSString *s  in self.projectObject.usersProject) {
            if ([[s valueForKey: @"_id"] isEqualToString:self.taskObject.userId] ) {
                self.developerField.text = [s valueForKey:@"emial"] ;
            }
        }
    }
      [super viewDidLoad];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.termField.inputView = datePicker;
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.dataSource = self;
    pickerView.delegate = self;
 
    self.statusField.inputView = pickerView;
    
    self.pickerUsers = [[UIPickerView alloc] init];
    self.pickerUsers.dataSource = self;
    self.pickerUsers.delegate = self;
    
    self.developerField.inputView = self.pickerUsers;
    
    self.sidebarButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_save.png"]
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(sideBarButtonAction)];
    self.navigationItem.rightBarButtonItem=self.sidebarButton;
   
}




-(void)textFieldDidBeginEditing:(UITextField *)textField {
   
    //Keyboard becomes visible
    if (textField == self.textFieldWithDesc || textField == self.descField) {
        self.descField.hidden = NO;
        [self.descField becomeFirstResponder];
        self.descField.keyboardType = UIKeyboardTypeEmailAddress;
     
     
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    //keyboard will hide
    self.descField.hidden=YES;
    self.textFieldWithDesc.text = self.descField.text;
  }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation


- (IBAction)progressBar:(id)sender {
    self.progressLabel.text = [NSString stringWithFormat:@"Progress= %d %%", (int)self.sliderOutlet.value];
}
- (void)datePickerValueChanged:(id)sender{
    
    NSDate* date =  [sender date];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-YYYY"];
    
    
  self.termField.text =[df stringFromDate:date];
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView ==self.pickerUsers) {
        return self.projectObject.usersProject.count;
    }
    return 5;}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView ==self.pickerUsers) {
        return [[self.projectObject.usersProject valueForKey:@"emial"] objectAtIndex:row];
    }
return [self.statusArray objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView ==self.pickerUsers) {
        self.developerField.text= [[self.projectObject.usersProject valueForKey:@"emial"] objectAtIndex:row];
    }
        else
    self.statusField.text = [self.statusArray objectAtIndex:row];
}

-(void)sideBarButtonAction{
    [self resignFirstResponder];
  self.textFieldWithDesc.text=  self.descField.text;
    [self addAI];
    if (self.nameField.text.length == 0 ||self.textFieldWithDesc.text.length == 0 ||self.termField.text.length == 0 ||self.statusField.text.length == 0 ||self.developerField.text.length == 0
        ) {
        [self showAlert:@"Pamiętaj aby wypełnić wszystkie pola"];
        [self.spinner removeFromSuperview];
      
        return;
    }
    
    NSString *tmp = [[NSString alloc] init];
    for (NSString *s  in self.projectObject.usersProject) {
        if ([[s valueForKey: @"emial"] isEqualToString:self.developerField.text] ) {
            tmp =[s valueForKey: @"_id"];
        }
    }
     NSString *tmp2 = [[NSString alloc] init];
    for (int i = 0 ; i<self.statusArray.count ; i++) {
        if ([[self.statusArray objectAtIndex:i] isEqualToString:self.statusField.text]) {
            tmp2 = [NSString stringWithFormat:@"%d", i];
            break;
        }
    }
    NSLog(@"%@",[[[[self.progressLabel.text componentsSeparatedByString:@" "] objectAtIndex:1 ] componentsSeparatedByString:@"%"] objectAtIndex:0]);
    
    NSMutableURLRequest *request;
    
    if(self.taskObject != nil){
     request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://zti-project-manager.meteor.com/api/ios/%@/tasks/%@/%@/%@/%@/%@/%@/%@/%@", [MyInfo getToken],  self.projectObject.idProject, self.taskObject.taskId,[self.nameField.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"] , [self.textFieldWithDesc.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"], tmp, self.termField.text,tmp2,   [[[[self.progressLabel.text componentsSeparatedByString:@" "] objectAtIndex:1 ] componentsSeparatedByString:@"%"] objectAtIndex:0] ]]];
      [request setHTTPMethod:@"POST"];
    }
    else{
    
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://zti-project-manager.meteor.com/api/ios/%@/tasks/%@/%@/%@/%@/%@/%@/%@", [MyInfo getToken],  self.projectObject.idProject, [self.nameField.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"], [self.textFieldWithDesc.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"], tmp, self.termField.text,tmp2,   [[[[self.progressLabel.text componentsSeparatedByString:@" "] objectAtIndex:1 ] componentsSeparatedByString:@"%"] objectAtIndex:0] ]]];
      [request setHTTPMethod:@"PUT"];
    }
    
    

    
   
  
    [[NSURLConnection alloc] initWithRequest:request delegate:self];

}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{   [self.spinner removeFromSuperview];
    NSString* newStr=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self parseJSON:newStr];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{[self showAlert:@"Sprawdź połączenie z internetem"];
    [self.spinner removeFromSuperview];
   
    
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
-(IBAction)showAlertPositive:(NSString*) text
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @":)"
                                                   message: text
                                                  delegate: self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    
    [alert show];
    
    
}
- (void)parseJSON: (NSString*) jsonText{
    
   
    NSData *data =  [jsonText dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:&error];
    
    if ([[json valueForKey:@"status"] isEqualToString:@"success"]) {
        [self showAlertPositive:@"Poprawnie zaktualizowano"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else [self showAlert:@"Wystąpił błąd zapisu"];
}

@end
