//
//  SLJViewController.m
//  iFortunes
//
//  Created by Stanley Jackson on 9/26/14.
//  Copyright (c) 2014 Stanley Jackson. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "SLJFortunesViewController.h"

@interface SLJFortunesViewController ()
@property (weak, nonatomic) IBOutlet UILabel *fortuneLabel;
@property (readonly) SystemSoundID soundFileID;

@end

@implementation SLJFortunesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.model = [SLJFortunesModel sharedModel];
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"TaDa" ofType:@"wav"];
    
    NSURL *soundURL = [NSURL fileURLWithPath:soundFilePath];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &_soundFileID);
   
    
    UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc] init] initWithTarget:self action:@selector(singleTapRecognized:)];
    [self.view addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[[UITapGestureRecognizer alloc] init] initWithTarget:self action:@selector(doubleTapRecognized:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];

    
    //Single tap only recognized if it isn't proceeded by another tap
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    
    //Method tests
    //Should return the answer at index 4 which is "The harder you work, the luckier you get."
    NSLog(@"Intial number of answers: %lu", (unsigned long)[self.model numberOfAnswers]);
    
    //Now remove that answer and display the answers to confirm deletion
    [self.model removeAnswerAtIndex:4];
    NSLog(@"Number of answers after deletion: %lu", (unsigned long)[self.model numberOfAnswers]);
    
    //Finally, re-insert the deleted answer to it's previous index (4)
    [self.model insertAnswer:@"The harder you work, the luckier you get." atIndex:4];
    NSLog(@"Number of answers after insertion: %lu", (unsigned long)[self.model numberOfAnswers]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void) viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
}

- (void) singleTapRecognized: (UITapGestureRecognizer *) recognizer {
    //Play sound
    AudioServicesPlaySystemSound(self.soundFileID);

    [self displayAnswer:self.model.randomAnswer];
}

- (void) doubleTapRecognized: (UITapGestureRecognizer *) recognizer {
    //Vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    [self displayAnswer:self.model.secretAnswer];

}

- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        [self displayAnswer:self.model.randomAnswer];
    }
}

- (void) displayAnswer: (NSString *) answer {
    [UIView animateWithDuration:1.0 animations:^{
    
        self.fortuneLabel.alpha = 0;
    }
     
     completion:^(BOOL finished) {
         [self animateAnswer: answer];
        }
     ];
}


- (void) animateAnswer: (NSString *) answer {
    [UIView animateWithDuration:1.0 animations:^{
        self.fortuneLabel.text = answer;
        
        //If black, set to orange
        if (self.fortuneLabel.textColor == UIColor.blackColor) {
            self.fortuneLabel.textColor = [UIColor orangeColor];
        } else {
            self.fortuneLabel.textColor = UIColor.blackColor;
        }
        
        self.fortuneLabel.alpha = 1;
    }];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    SLJInputViewController *inputVC = segue.destinationViewController;
    inputVC.completionHandler = ^(NSString *text) {
        if (text != nil) {
            self.model.secretAnswer = text;
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    };
}


@end
