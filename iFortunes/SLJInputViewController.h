//
//  SLJInputViewController.h
//  TextInput
//
//  Created by Stanley Jackson on 10/26/14.
//  Copyright (c) 2014 Stanley Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SLJInputCompletionHandler)(NSString *inputText);

@interface SLJInputViewController : UIViewController

@property (copy, nonatomic) SLJInputCompletionHandler completionHandler;


@end

