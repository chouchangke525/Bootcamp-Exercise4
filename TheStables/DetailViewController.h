//
//  DetailViewController.h
//  TheStables
//
//  Created by T. Andrew Binkowski on 11/15/12.
//  Copyright (c) 2012 The University of Chicago, Department of Computer Science. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Animal.h"

@interface DetailViewController : UIViewController
@property (strong, nonatomic) Animal *currentAnimal;
@property (weak, nonatomic) IBOutlet UIImageView *animalImage;
@property (weak, nonatomic) IBOutlet UILabel *animalName;

@end
