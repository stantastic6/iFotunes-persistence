//
//  SLJFortunesModel.m
//  iFortunes
//
//  Created by Stanley Jackson on 9/26/14.
//  Copyright (c) 2014 Stanley Jackson. All rights reserved.
//

#import "SLJFortunesModel.h"

//Keys for dictionary
NSString *const AnswerArray = @"AnswerArray";
NSString *const SecretAnswer = @"SecretAnswer";

//Filename for plist
NSString *const AnswersPlist = @"answers.plist";

@interface SLJFortunesModel()


@property (strong, nonatomic) NSMutableArray *answers;
@property (strong, nonatomic) NSString *filepath;
@property (strong, nonatomic) NSMutableDictionary *plist;
@end


@implementation SLJFortunesModel


- (id) init {
    self = [super init];
    if (self) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        _filepath = [documentsDirectory stringByAppendingPathComponent:AnswersPlist];
        _plist = [NSMutableDictionary dictionaryWithContentsOfFile:_filepath];

    

        //If there is no plist file, create one
        if (!_plist) {
            _plist = [NSMutableDictionary dictionaryWithCapacity:2];
            _answers = [[NSMutableArray alloc] initWithObjects:
                        @"A beautiful, smart, and loving person will be coming into your life.",
                        @"A dubious friend may be an enemy in camouflage.",
                        @"A smile is your personal welcome mat.",
                        @"It is worth reviewing some old lessons.",
                        @"The harder you work, the luckier you get.",
                        @"Welcome change.",
                        nil];
            [_plist setObject:_answers forKey:AnswerArray];
        
        
        
            //Setup initial Secret Answer
            NSMutableArray *lottoNumbers = [[NSMutableArray alloc] init];
        
        
            for (int i = 0; i < 4; i++) {
                [lottoNumbers addObject:[NSNumber numberWithInteger:rand()%76]];
            }
        
            [lottoNumbers addObject:[NSNumber numberWithInteger:rand()%16]];
            NSString *lottoString = [lottoNumbers componentsJoinedByString:@", "];
        
            _secretAnswer = [NSString stringWithFormat:@"You will win the lottery if you pick these numbers: \n"];
            _secretAnswer = [_secretAnswer stringByAppendingString:lottoString];
            [_plist setObject:_secretAnswer forKey:SecretAnswer];
        } else {
            //Retrieve answers from the plist file
        
            _answers = [_plist objectForKey:AnswerArray];
            _secretAnswer = [_plist objectForKey:SecretAnswer];
        }
    }
    
    return self;
}


+ (instancetype) sharedModel {
    static SLJFortunesModel *_sharedModel = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        //thread safe execution
        _sharedModel = [[self alloc] init];
    });
    
    return _sharedModel;
}


//public methods
-(NSString *) randomAnswer{
    if ([self.answers count]) {
        return [self.answers objectAtIndex:random()%[self.answers count]];
    }
    
    return @"I have no fortunes for you today";
}

-(NSUInteger) numberOfAnswers{
    return [self.answers count];
}

-(NSString *) answerAtIndex:(NSUInteger)index{
    return self.answers[index];
}

-(void) removeAnswerAtIndex:(NSUInteger)index{
    NSUInteger numOfAnswers = [self numberOfAnswers];
    
    if (index < numOfAnswers) {
        [self.answers removeObjectAtIndex:index];
        [self save];
    }
}

-(void) insertAnswer:(NSString *)answer atIndex:(NSUInteger)index{
    NSUInteger numOfAnswers = [self numberOfAnswers];
    
    if (index <= numOfAnswers) {
        [self.answers insertObject:answer atIndex:index];
        [self save];
    }
}

-(void) setSecretAnswer:(NSString *) newSecretAnswer {
    _secretAnswer = newSecretAnswer;
    [self save];
}

-(void) save {
    [self.plist setObject:self.answers forKey:AnswerArray];
    [self.plist setObject:self.secretAnswer forKey:SecretAnswer];
    
    [self.plist writeToFile:self.filepath atomically:YES];
}


@end
