//
//  SLJInputViewController.m
//  TextInput
//
//  Created by Stanley Jackson on 10/26/14.
//  Copyright (c) 2014 Stanley Jackson. All rights reserved.
//

#import "SLJInputViewController.h"

@interface SLJInputViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;


@end

@implementation SLJInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}
- (IBAction)saveButtonTapped:(id)sender {
    if (self.completionHandler) {
        self.completionHandler(self.textField.text);
    }
}

- (IBAction)cancelButtonTapped:(id)sender {
    if (self.completionHandler) {
        self.completionHandler(nil);
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (self.completionHandler) {
        self.completionHandler(self.textField.text);
    }
    return YES;
}

- (BOOL) textField: (UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    [self validateSaveButtonForText: changedString];
    return YES;
}

-(void) validateSaveButtonForText: (NSString *) text {
    self.saveButton.enabled = ([text length] > 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
