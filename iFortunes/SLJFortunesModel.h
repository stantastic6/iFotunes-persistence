//
//  SLJFortunesModel.h
//  iFortunes
//
//  Created by Stanley Jackson on 9/26/14.
//  Copyright (c) 2014 Stanley Jackson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLJFortunesModel : NSObject

//public property
@property (strong, nonatomic) NSString *secretAnswer;

//public methods
- (NSString *) randomAnswer;
- (NSUInteger) numberOfAnswers;
- (NSString *) answerAtIndex: (NSUInteger) index;
- (void) removeAnswerAtIndex: (NSUInteger) index;
- (void) insertAnswer: (NSString *) answer atIndex: (NSUInteger) index;

+ (instancetype) sharedModel;
@end
