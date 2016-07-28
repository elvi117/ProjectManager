//
//  TaskInfo.h
//  ZTI
//
//  Created by Lukasz Matuszczak on 15/01/16.
//  Copyright © 2016 IT Lite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskInfo : NSObject
@property (strong, nonatomic) NSString* taskId;
@property (strong, nonatomic) NSString* taskName;
@property (strong, nonatomic) NSString* taskDesc;
@property (strong, nonatomic) NSString* taskTerm;
@property (strong, nonatomic) NSString* taskProgress;
@property (strong, nonatomic) NSString* status;
@property (strong, nonatomic) NSString* userId;
@end
