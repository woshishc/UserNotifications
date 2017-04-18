//
//  NotificationService.m
//  extension
//
//  Created by suhc on 2017/4/14.
//  Copyright © 2017年 kongjianjia. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
//    // Modify the notification content here...
//    //修改标题
//    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
//    //修改副标题
//    self.bestAttemptContent.subtitle = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.subtitle];
//    //修改内容
//    self.bestAttemptContent.body = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.body];
//    //添加附件
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"image2.png" ofType:nil];
//    NSError *error = nil;
//    UNNotificationAttachment *img_attachment = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
//    if (error) {
//        NSLog(@"%@", error);
//    }
//    self.bestAttemptContent.attachments = @[img_attachment];
    self.contentHandler(self.bestAttemptContent);

}

- (void)serviceExtensionTimeWillExpire {
    NSLog(@"最后一个改变的机会，然后结束服务");
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
