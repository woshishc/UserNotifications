//
//  AppDelegate.m
//  UserNotifications
//
//  Created by suhc on 2017/4/7.
//  Copyright © 2017年 kongjianjia. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import <HCTools/HCTools.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //注册通知类型(当收到服务端推送过来的通知的时候，会根据里面的identifier在已经注册的category里面去匹配，然后显示出来的通知样式就会和匹配成功的那个category一样，如果所有注册的category都不匹配，就显示一个默认的不带任何action的样式)
    [center setNotificationCategories:[self createNotificationCategoryActions]];
    //必须写代理，不然无法监听通知的接收与点击
    center.delegate = self;
    //获取通知设置信息
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    NSLog(@"granted");
                    //注册远程推送
                    [application registerForRemoteNotifications];
                } else {
                    NSLog(@"not granted");
                }
            }];
        }else{
            //do other things
            NSLog(@"do other things");
        }
    }];
    
    return YES;
}

- (NSSet *)createNotificationCategoryActions{
    //定义通知交互按钮(最好不要超过4个)
    UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"操作一" options:UNNotificationActionOptionDestructive|UNNotificationActionOptionForeground];
    UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"action2" title:@"操作二" options:UNNotificationActionOptionDestructive|UNNotificationActionOptionForeground];
    UNNotificationAction *action3 = [UNNotificationAction actionWithIdentifier:@"action3" title:@"操作三" options:UNNotificationActionOptionDestructive|UNNotificationActionOptionForeground];
    
    //定义文本框的action
    UNTextInputNotificationAction *inputAction = [UNTextInputNotificationAction actionWithIdentifier:@"text" title:@"输入框" options:UNNotificationActionOptionAuthenticationRequired|UNNotificationActionOptionDestructive|UNNotificationActionOptionForeground];
    
    //将这些action带入category
    UNNotificationCategory *category1 = [UNNotificationCategory categoryWithIdentifier:@"category1" actions:@[action1,action2,action3] intentIdentifiers:@[@"action1",@"action2",@"action3"] options:UNNotificationCategoryOptionNone];
    
    UNNotificationCategory *category2 = [UNNotificationCategory categoryWithIdentifier:@"category2" actions:@[inputAction] intentIdentifiers:@[@"text"] options:UNNotificationCategoryOptionNone];
    
    return [NSSet setWithObjects:category1,category2,nil];
}

#pragma mark - 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error=%@",error);
}

#pragma mark - 注册并成功获取deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //注意：deviceToken在某些情况下是会改变的，同时长度也不是固定的，如果在APP运行的时候deviceToken改变了，将会重新调用此方法，重新获取新的deviceToken
    NSLog(@"deviceToken=%@",deviceToken);
}

#pragma mark - 收到远程推送
//iOS10之前
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;{
    NSLog(@"收到远程推送");
}

//iOS10之后(静默通知)
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"收到静默通知");
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - UNUserNotificationCenterDelegate
//当APP处于后台模式或者没有运行的时候不会调用此方法，方法的最后，调用completionHandler处理通知数据，在通知展示之前调用此方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    /*
     UNNotificationRequest *request = notification.request; // 原始请求
     NSDictionary *userInfo = request.content.userInfo;// userInfo数据
     UNNotificationContent *content = request.content; // 原始内容
     NSString *title = content.title;  // 标题
     NSString *subtitle = content.subtitle;  // 副标题
     NSNumber *badge = content.badge;  // 角标
     NSString *body = content.body;    // 推送消息体
     UNNotificationSound *sound = content.sound;  // 指定的声音
     */
    if ([notification isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 收到远程通知");
    }else{
        NSLog(@"iOS10 收到本地通知");
    }
    
    // 回调block，将设置传入
    //如果括号中选项为UNNotificationPresentationOptionNone则在APP处于前台的时候不显示通知栏，否则在APP处于前台的时候依然可以显示通知栏
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

//用户与通知进行交互后的response，比如说用户直接点开通知打开App、用户点击通知的按钮或者进行输入文本框的文本
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"与用户交互完成处理交互结果");
    /*
    UNNotificationRequest *request = response.notification.request; // 原始请求
    NSDictionary *userInfo = request.content.userInfo;// userInfo数据
    UNNotificationContent *content = request.content; // 原始内容
    NSString *title = content.title;  // 标题
    NSString *subtitle = content.subtitle;  // 副标题
    NSNumber *badge = content.badge;  // 角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;
     */
    //在此，可判断response的种类和request的触发器是什么，可根据远程通知和本地通知分别处理，再根据action进行后续回调
    //可根据actionIdentifier来做业务逻辑
    if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {
        //输入框action的处理
        UNTextInputNotificationResponse *textResponse = (UNTextInputNotificationResponse *)response;
        NSString *text = textResponse.userText;
        //do something
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"文本框输入" message:text preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    } else{
        if ([response.actionIdentifier isEqualToString:@"action1"]) {
            NSLog(@"操作一");
        }
        if ([response.actionIdentifier isEqualToString:@"action2"]) {
            NSLog(@"操作二");
        }
        if ([response.actionIdentifier isEqualToString:@"action3"]) {
            NSLog(@"操作三");
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:response.actionIdentifier message:response.notification.request.content.body preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    completionHandler();
}

@end
