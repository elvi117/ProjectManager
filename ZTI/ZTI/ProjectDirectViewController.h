//
//  ProjectDirectViewController.h
//  ZTI
//
//  Created by Lukasz Matuszczak on 15/01/16.
//  Copyright © 2016 IT Lite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyInfo.h"
#import "ProjectInfo.h"
#import "TaskInfo.h"
#import "taskTableViewCell.h"
#import "TaskAddViewController.h"
@interface ProjectDirectViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleOfView;
@property (weak, nonatomic) IBOutlet UITextView *projectDesc;
@property (strong, nonatomic ) ProjectInfo * projectInfoObject;

@property (strong, nonatomic) NSMutableArray* tasksTable;
@property (strong, nonatomic) NSMutableArray* tasksTableMY;
- (IBAction)segmentView:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableViewMy;
@property (nonatomic) NSInteger* segmentedFlag;
@property (strong, nonatomic) UIBarButtonItem * sidebarButton;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentViewOutlet;

- (IBAction)lisaZadanbutton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *listaZadanOutlet;

@end
