//
//  ViewController.h
//  kentApp
//
//  Created by pericent on 12/18/14.
//  Copyright (c) 2014 pericent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    IBOutlet UIImageView *imgV;
    
      UIDatePicker *datePicker;
    
    
    IBOutlet UIButton *btnSignIn;
    IBOutlet UIButton *btnRegister;
}
- (IBAction)registerBTN:(id)sender;

- (IBAction)signInClick:(id)sender;

@end

