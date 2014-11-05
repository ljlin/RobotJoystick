//
//  ViewController.m
//  RobotJoystick
//
//  Created by ljlin on 14-9-5.
//  Copyright (c) 2014年 ljlin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver: self
                           selector: @selector (onStickChanged:)
                               name: @"StickChanged"
                             object: nil];
    //[self startExamine];
}
- (NSArray*)ButtonList
{
    if (!_ButtonList) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ButtonOrder" ofType:@"plist"];
        _ButtonList = [[NSArray alloc]initWithContentsOfFile:plistPath];
    }
    return _ButtonList;
}
- (void)startExamine
{
    self.motionManager = [[CMMotionManager alloc]init];
    self.motionManager.accelerometerUpdateInterval = 0.01;
    if ([self.motionManager isAccelerometerAvailable]){
        NSLog(@"Accelerometer is available.");
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        CMAccelerometerHandler handler = ^(CMAccelerometerData *accelerometerData, NSError *error){
            float dx = accelerometerData.acceleration.x,
                  dy = accelerometerData.acceleration.y,
                  dz = accelerometerData.acceleration.z;
            NSLog(@"x:%g y:%g z:%g",dx,dy,dz);
            self.textView.text = [NSString stringWithFormat:@"x:%g y:%g z:%g",dx,dy,dz];
        };
        [self.motionManager startAccelerometerUpdatesToQueue: queue
                                                 withHandler: handler];
    }
}

- (void)creatSocket
{
    self.socket = [[AsyncSocket alloc]initWithDelegate:self];
    NSString *host = self.HostTxtField.text;
    UInt16    port = self.PortTxtField.text.intValue;
    BOOL res = [self.socket connectToHost:host onPort:port error:nil];
    NSLog(@"connect to %@ %d res %d",host,port,res);
}

- (void)onStickChanged:(id)notification
{
    NSDictionary *dict = [notification userInfo];
    NSValue *vdir = [dict valueForKey:@"dir"];
    CGPoint dir = [vdir CGPointValue];
    NSLog(@"%g %g",dir.x,dir.y);
}

- (IBAction)buttonTouchBegin:(UIButton *)sender forEvent:(UIEvent *)event
{
    if ([self.socket isConnected]) {
        NSLog(@"=======");
        NSData *data = [@"up" dataUsingEncoding:NSASCIIStringEncoding];
        [self.socket writeData:data withTimeout:-1 tag:1];
    }
    
}

- (IBAction)buttonTouchEnd:(UIButton*)sender forEvent:(UIEvent *)event
{
    
}

- (IBAction)buttonClick:(UIButton*)sender
{
    if (sender.tag==3) {
        if (self.connected==0){
            [self creatSocket];
            self.connected = 1;
        }
        else{
            //
            self.connected = 0;
        }
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    NSLog(@"did connect to host");
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"did read data");
    NSString* message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"message is: \n%@",message);
}
@end
