//
//  TaskAddViewController.h
//  ZTI
//
//  Created by Lukasz Matuszczak on 15/01/16.
//  Copyright © 2016 IT Lite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskInfo.h"
#import "ProjectInfo.h"
#import "MyInfo.h"
@interface TaskAddViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate , UIScrollViewDelegate, UITextViewDelegate>


@property (strong, nonatomic) TaskInfo* taskObject;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextView *descField;
@property (weak, nonatomic) IBOutlet UITextField *termField;
@property (weak, nonatomic) IBOutlet UITextField *statusField;
- (IBAction)progressBar:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UISlider *sliderOutlet;
@property (weak, nonatomic) IBOutlet UITextField *developerField;
@property (strong,nonatomic) NSArray * statusArray;
@property (weak, nonatomic) IBOutlet UITextField *textFieldWithDesc;

@property (strong, nonatomic) ProjectInfo* projectObject;
@property (strong, nonatomic) UIPickerView * pickerUsers;
@property (strong, nonatomic) UIBarButtonItem * sidebarButton;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;

@end
