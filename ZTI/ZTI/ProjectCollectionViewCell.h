//
//  ProjectCollectionViewCell.h
//  ZTI
//
//  Created by Lukasz Matuszczak on 13/01/16.
//  Copyright © 2016 IT Lite. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectInfo.h"
@interface ProjectCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) ProjectInfo * projectInfoObject;

@end
