//
//  ProjectManagerView.h
//  ZTI
//
//  Created by Lukasz Matuszczak on 13/01/16.
//  Copyright © 2016 IT Lite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectCollectionViewCell.h"
#import "MyInfo.h"
#import "ProjectInfo.h"
#import "UserInfoViewController.h"
#import "SWRevealViewController.h"
#import "ProjectDirectViewController.h"
@interface ProjectManagerView : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewMy;
@property (strong, nonatomic) NSMutableArray * projectTable;
@property (strong, nonatomic) UIBarButtonItem * sidebarButton;
@property (strong, nonatomic) UIBarButtonItem * sidebarButton2;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSMutableArray* jsonArray;
@end
