//
//  ProjectInfo.h
//  ZTI
//
//  Created by Lukasz Matuszczak on 13/01/16.
//  Copyright © 2016 IT Lite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectInfo : NSObject
@property (strong, nonatomic) NSString* idProject;
@property (strong, nonatomic) NSString* colorProject;
@property (strong, nonatomic) NSString* nameProject;
@property (strong, nonatomic) NSString* descProject;
@property (strong, nonatomic) NSMutableArray* usersProject;
@end
