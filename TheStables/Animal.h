//
//  Animal.h
//  TheStables
//
//  Created by T. Andrew Binkowski on 11/15/12.
//  Copyright (c) 2012 The University of Chicago, Department of Computer Science. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Animal : NSObject
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *age;
@property (strong, nonatomic) NSURL *imageURL;
@end
