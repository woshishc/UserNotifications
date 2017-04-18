//
//  ViewController.m
//  UserNotifications
//
//  Created by suhc on 2017/4/7.
//  Copyright © 2017年 kongjianjia. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <HCTools/HCTools.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.size = CGSizeMake(200, 50);
    button1.bottom = self.view.centerY - 20;
    button1.centerX = self.view.centerX;
    [button1 setTitle:@"清空通知栏消息" forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor redColor];
    [button1 addTarget:self action:@selector(clearMessages) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.size = CGSizeMake(200, 50);
    button2.top = self.view.centerY + 20;
    button2.centerX = self.view.centerX;
    [button2 setTitle:@"发送一条本地通知" forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor blueColor];
    [button2 addTarget:self action:@selector(createOneLocalNotification) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}

#pragma mark - 清空通知栏消息
- (void)clearMessages{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllDeliveredNotifications];
}

#pragma mark - 创建一条本地通知
- (void)createOneLocalNotification{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"标题";
    content.subtitle = @"副标题";
    content.body = @"这里是通知内容";
    content.badge = @0;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"image1" ofType:@"png"];
    NSError *error = nil;
    UNNotificationAttachment *img_attachment = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    content.attachments = @[img_attachment];
    //设置为@""以后，进入app将没有启动页
    content.launchImageName = @"";
    //收到通知时候的声音文件名(音频文件必须在bundle中或者在Library/Sounds目录下)
    UNNotificationSound *sound = [UNNotificationSound soundNamed:@"sound.wav"];
    content.sound = sound;
    //一秒后收到通知，并且不重复
    UNTimeIntervalNotificationTrigger *time_trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    NSString *requestIdentifer = @"requestIdentifer";
    content.categoryIdentifier = @"category1";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:time_trigger];
    
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
}

@end
