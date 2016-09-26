//
//  SJR_ActivityWebView.m
//  ShiJuRenClient
//
//  Created by xuwk on 16/5/6.
//  Copyright © 2016年 qijuntonglian. All rights reserved.
//

#import "SJR_ActivityWebView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "ZWIntroductionViewController.h"

@interface SJR_ActivityWebView ()<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (weak, nonatomic) UITabBarController *supViewCon;

@end

@implementation SJR_ActivityWebView

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.webView = [[UIWebView alloc]init];
    self.webView.delegate = self;
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.webView setOpaque:NO];
    self.webView.scrollView.scrollEnabled = NO;
    return self;
}

- (void)showActivityInSupViewCon:(QJTL_BaseViewController *)viewCon url:(NSString *)urlStr
{
    self.supViewCon = viewCon.navigationController.tabBarController;
    [_webView setFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    NSURL *url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    if([SJR_UserInfo sharedUserInfo].token != nil)
    {
        [request addValue:[SJR_UserInfo sharedUserInfo].token forHTTPHeaderField:@"token"];
    }
    [_webView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"活动页加载完成");
    [self addJSFunction:webView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while([[[UIApplication sharedApplication].keyWindow.subviews.lastObject getViewController] isKindOfClass:[ZWIntroductionViewController class]])
        {
            usleep(200);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication].keyWindow addSubview:_webView];
        });
    });
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"活动页发生错误 %@",error);
}


- (void)addJSFunction:(UIWebView *)webView
{
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak typeof(self) temp = self;
    context[@"openViewController"] = ^() {
        NSArray *args = [JSContext currentArguments];
        NSLog(@"开始");
        JSValue *obj = args.firstObject;
        NSDictionary *userInfo = obj.toDictionary;
        NSDictionary *result = [userInfo objectForKey:@"result"];
        NSString *viewControllerClass = [userInfo objectForKey:@"class"];
        NSString *storyboardName = [userInfo objectForKey:@"storyboard"];
        
        QJTL_BaseViewController *tempViewCon = (QJTL_BaseViewController *)self.supViewCon.selectedViewController;
        if(storyboardName.length > 1 && result != nil)
        {
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
            if(storyboard == nil)
            {
                [tempViewCon showHudPrompt:@"参数错误！"];
                return ;
            }
            QJTL_BaseViewController* baseViewController = [storyboard instantiateViewControllerWithIdentifier:viewControllerClass];
            if(baseViewController == nil)
            {
                [tempViewCon showHudPrompt:@"参数错误！"];
                return ;
            }
            [baseViewController loadViewControllerWithInfo:result];
            dispatch_async(dispatch_get_main_queue(), ^{
                [tempViewCon.navigationController pushViewController:baseViewController animated:YES];
            });
        }
        else if(viewControllerClass.length > 1 && result != nil)
        {
            QJTL_BaseViewController* baseViewController = [[NSClassFromString(viewControllerClass) alloc] init];
            if(baseViewController == nil)
            {
                [tempViewCon showHudPrompt:@"参数错误！"];
                return ;
            }
            [baseViewController loadViewControllerWithInfo:result];
            dispatch_async(dispatch_get_main_queue(), ^{
                [tempViewCon.navigationController pushViewController:baseViewController animated:YES];
            });
        }
        else
        {
            NSLog(@"参数有误");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [temp.webView removeFromSuperview];
        });
    };
    
    context[@"closeActivity"] = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            [temp.webView removeFromSuperview];
        });
    };
}


@end
