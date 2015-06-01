//
//  QAConstant.h
//  quizApp
//  Created by Mac5 on 11/15/14.
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#pragma mark - IOs Vesrion

#define IS_DEVICE_RUNNING_IOS_7_AND_ABOVE() ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
#define iPhoneVersion ([[UIScreen mainScreen] bounds].size.height == 568 ? 5 : ([[UIScreen mainScreen] bounds].size.height == 480 ? 4 : ([[UIScreen mainScreen] bounds].size.height == 667 ? 6 : ([[UIScreen mainScreen] bounds].size.height == 736 ? 61 : 999))))

#pragma mark - AppConstant
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.7;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 120;
#define FONT_NAME @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"

#pragma mark - AppMessages
#define LOGINBG_IMAGE @"loginbg.png"
#define BUILDINGBG_IMAGE @"bg_buildigng.png"

#pragma mark - AppURL
//#define MAIN_QA_SERVICE_URL @"http://192.168.1.11/quiz_game/v1/"
#define MAIN_QA_SERVICE_URL @"http://netleondev.com/kentapi/"

NSMutableArray *arrQuestionList;
NSInteger QuestionNumber;
