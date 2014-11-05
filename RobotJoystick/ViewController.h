//
//  ViewController.h
//  RobotJoystick
//
//  Created by ljlin on 14-9-5.
//  Copyright (c) 2014年 ljlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "AsyncSocket/AsyncSocket.h"

@interface ViewController : UIViewController<UITextFieldDelegate,AsyncSocketDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *HostTxtField;
@property (weak, nonatomic) IBOutlet UITextField *PortTxtField;
@property (strong, nonatomic) AsyncSocket *socket;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (nonatomic) BOOL connected;
@property (strong, nonatomic) NSArray *ButtonList;
@end
