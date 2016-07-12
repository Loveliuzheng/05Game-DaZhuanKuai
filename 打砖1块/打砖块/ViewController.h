//
//  ViewController.h
//  打砖块
//
//  Created by cqy on 16/4/20.
//  Copyright © 2016年 刘征. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController



@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *blockImageArray;

@property (weak, nonatomic) IBOutlet UIImageView *ballImage;

@property (weak, nonatomic) IBOutlet UIImageView *paddleImage;


@end

