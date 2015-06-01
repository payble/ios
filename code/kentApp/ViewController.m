//
//  ViewController.m
//  kentApp
//
//  Created by pericent on 12/18/14.
//  Copyright (c) 2014 pericent. All rights reserved.
//

#import "ViewController.h"
#import "registration.h"
#import "login.h"

#import "HomeVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//       self.navigationController.navigationBar.hidden=YES;
    
//    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    
    
  /*  UIImage *img = [UIImage imageNamed:@"fb.png"];
    NSData *imageData = UIImagePNGRepresentation(img);
    NSString *imageString = [imageData base64EncodedStringWithOptions:0];
    
    NSLog(@"%@", imageString);
    NSData *data = [[NSData alloc]initWithBase64EncodedString:imageString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    imgV.image=[UIImage imageWithData:data];
   
   */
    
    
    NSString *str1=@"Nakul";
    
    str1=@"Kumar";
    
    NSLog(@"%@-----%@",str1,FONT_NAME_MAIN);
    
    if ( IDIOM == IPAD ) {
        btnSignIn.titleLabel.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
        btnRegister.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:22];
    }else{
        btnSignIn.titleLabel.font   =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
        btnRegister.titleLabel.font =   [UIFont fontWithName:FONT_NAME_MAIN size:14];
    }
    
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userdataKey"])
    {
        [self.navigationController pushViewController:[[HomeVC alloc]init] animated:YES];
    }
    
//    btnSignIn.layer.cornerRadius=3.0f;
//    btnSignIn.clipsToBounds=YES;
//    
//    btnRegister.layer.cornerRadius=3.0f;
//    btnRegister.clipsToBounds=YES;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- IB_Action

-(IBAction)btn_TouchDown:(id)sender
{
   /* UIButton *btn=sender;
    if (btn.tag==10)
    {
       [ btn setBackgroundColor:[UIColor colorWithRed:84.0/255.0 green:134.0/255.0 blue:182.0/255.0 alpha:1]];
    }
    else if(btn.tag==20)
    {
        [ btn setBackgroundColor:[UIColor colorWithRed:84.0/255.0 green:134.0/255.0 blue:182.0/255.0 alpha:1]];
    }
    
    */
}

- (IBAction)registerBTN:(id)sender
{
    
    UIButton *btn=sender;
  // [ btn setBackgroundColor:[UIColor blackColor]];

    registration *regOBj = [[registration alloc]init];
    [self.navigationController pushViewController:regOBj animated:YES];
    
    
}

- (IBAction)signInClick:(id)sender {
    
    UIButton *btn=sender;
    
    [ btn setBackgroundColor:[UIColor blackColor]];
    
    login *loginObj = [[login alloc]init];
    [self.navigationController pushViewController:loginObj animated:YES];
    
    
}
@end
