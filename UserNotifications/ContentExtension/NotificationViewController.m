//
//  NotificationViewController.m
//  ContentExtension
//
//  Created by suhc on 2017/4/14.
//  Copyright © 2017年 kongjianjia. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *titleView;

@property IBOutlet UILabel *subTitleView;

@property IBOutlet UILabel *contentView;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //title在这里设置无法成为通知上面的标题
    self.title = @"这是一个自定义通知界面";
}

- (void)didReceiveNotification:(UNNotification *)notification {
    //title设置在这里才有效，在viewDidLoad里面无效
    self.title = @"这是一个自定义通知界面哦~";
    //标题
    self.titleView.text = notification.request.content.title;
    //副标题
    self.subTitleView.text = notification.request.content.subtitle;
    //内容
    self.contentView.text = notification.request.content.body;
}

@end
