//
//  SJR_TabBarController.m
//  ShiJuRen
//
//  Created by newman on 15/8/16.
//  Copyright (c) 2015年 qijuntonglian. All rights reserved.
//

#import "SJR_TabBarController.h"

#import "SJR_LoginViewController.h"
#import "SJR_SuccessfulViewController.h"
#import "SJR_MessageViewController.h"
#import "SJR_HomeViewController.h"

@interface SJR_TabBarController ()
{
    UINavigationController *navigationControllerHome;
    UINavigationController *navigationControllerMy;
    UINavigationController *navigationControllerMessage;
    UINavigationController *navigationControllerOther;
    
    UIButton *centerBtn;
}
@end

@implementation SJR_TabBarController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self loadTabBarViewControllers];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        [self loadTabBarViewControllers];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:SJR_NetTokenExpiredEvent object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self);
        if([SJR_UserInfo sharedUserInfo].isLoginView == NO)
        {
            [SJR_UserInfo sharedUserInfo].isLoginView = YES;
            SJR_LoginViewController *loginViewController = [[SJR_LoginViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginViewController];
            nav.interactivePopGestureRecognizer.delegate = nil;
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
    }
     ];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:SJR_NotCertifiedExpiredEvent object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self);
        if([SJR_UserInfo sharedUserInfo].isLoginView == NO)
        {
            [SJR_UserInfo sharedUserInfo].isLoginView = YES;
            SJR_SuccessfulViewController *successfulViewController = [[SJR_SuccessfulViewController alloc]init];
            successfulViewController.title = @"请先完成认证";
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:successfulViewController];
            nav.interactivePopGestureRecognizer.delegate = nil;
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
    }
     ];
    
    centerBtn = [[UIButton alloc]initWithFrame:CGRectMake((DeviceWidth/2) - 47.5, DeviceHeight - 55, 95, 55)];
    [centerBtn setBackgroundImage:IMAGE(@"SJR_TabProcurementBtn") forState:UIControlStateNormal];
    [centerBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:centerBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadTabBarViewControllers
{
    UIStoryboard* homeStoryboard = [UIStoryboard storyboardWithName:@"SJR_HomeView" bundle:nil];
    UIStoryboard* myStoryboard = [UIStoryboard storyboardWithName:@"SJR_MyView" bundle:nil];
    
    QJTL_BaseViewController* viewController1 = [homeStoryboard instantiateViewControllerWithIdentifier:@"SJR_HomeViewStory"];
    QJTL_BaseViewController *viewController2 = [myStoryboard instantiateViewControllerWithIdentifier:@"SJR_MyViewStory"];
    
    //UIViewController *viewController1        = [[UIViewController alloc]init];
    UIViewController *viewController3        = [[SJR_MessageViewController alloc]init];
    UIViewController *viewController4        = [[UIViewController alloc]init];

    navigationControllerHome          = [[UINavigationController alloc]initWithRootViewController:viewController1];
    navigationControllerHome.title    = @"首页";
    navigationControllerMy            = [[UINavigationController alloc]initWithRootViewController:viewController2];
    navigationControllerMy.title      = @"我的";
    navigationControllerMessage       = [[UINavigationController alloc]initWithRootViewController:viewController3];
    navigationControllerMessage.title = @"信息";
    navigationControllerOther         = [[UINavigationController alloc]initWithRootViewController:viewController4];
    navigationControllerOther.title   = @"更多";

    [navigationControllerHome setNavigationBarHidden:YES animated:NO];
    [navigationControllerMy setNavigationBarHidden:YES animated:NO];
    [navigationControllerMessage setNavigationBarHidden:YES animated:NO];
    [navigationControllerOther setNavigationBarHidden:YES animated:NO];
    
    viewController1.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页          "
                                                              image:IMAGEOriginal(@"SJR_TabImage1")
                                                      selectedImage:IMAGEOriginal(@"SJR_TabImage1d")];
    
    viewController2.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"          我的"
                                                              image:IMAGEOriginal(@"SJR_TabImage2")
                                                      selectedImage:IMAGEOriginal(@"SJR_TabImage2d")];
    
    viewController3.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"信息"
                                                              image:IMAGEOriginal(@"SJR_TabImage3")
                                                      selectedImage:IMAGEOriginal(@"SJR_TabImage3d")];
    
    viewController4.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"更多"
                                                              image:IMAGEOriginal(@"SJR_TabImage4")
                                                      selectedImage:IMAGEOriginal(@"SJR_TabImage4d")];

    viewController1.tabBarItem.imageInsets   = UIEdgeInsetsMake(0, -15, -0, 15);
    viewController2.tabBarItem.imageInsets   = UIEdgeInsetsMake(0, 15, -0, -15);
    viewController3.tabBarItem.imageInsets   = UIEdgeInsetsMake(0, 0, -0, 0);
    viewController4.tabBarItem.imageInsets   = UIEdgeInsetsMake(0, 0, -0, 0);

    self.viewControllers                     = @[navigationControllerHome,navigationControllerMy];
    
//    [self.tabBar.items[2] setBadgeValue:@"1"];
    self.delegate = self;
//    [self.tabBar setTintColor:[UIColor colorWithRed:0.107 green:0.322 blue:0.796 alpha:1.000]];
//    [self.tabBar setBarTintColor:[UIColor colorWithWhite:0.973 alpha:1.000]];
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSLog(@"切换到页面%@",viewController.title);
    if([viewController.title isEqualToString:@"我的"])
    {
//        if([SJR_UserInfo sharedUserInfo].token == nil)
//        {
//            [[NSNotificationCenter defaultCenter]postNotificationName:SJR_NetTokenExpiredEvent object:nil userInfo:nil];
//            return NO;
//        }
//        if([SJR_UserInfo sharedUserInfo].authState == 0)
//        {
//            SJR_SuccessfulViewController *successfulViewController = [[SJR_SuccessfulViewController alloc]init];
//            successfulViewController.title = @"请先完成认证";
//            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:successfulViewController];
//            [self.navigationController presentViewController:nav animated:YES completion:nil];
//            return NO;
//        }
    }
    return YES;
}

-(void)buttonAction:(UIButton*)button
{
    UIStoryboard* purchaseOrderStoryboard = [UIStoryboard storyboardWithName:@"SJR_PurchaseOrderView" bundle:nil];
    QJTL_BaseViewController* viewController = [purchaseOrderStoryboard instantiateViewControllerWithIdentifier:@"SJR_PurchaseOrder"];
    viewController.title = @"我要采购";
    
    [self.navigationController pushViewController:viewController animated:YES];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    [super setTabBarHidden:hidden animated:animated];
    CGFloat height = hidden == YES ? DeviceHeight : DeviceHeight - 55;
    if(animated == YES)
    {
        [UIView animateWithDuration:.3 animations:^{
            [centerBtn setFrame:CGRectMake((DeviceWidth/2) - 47.5, height, 95, 55)];
        }];
    }
    else
    {
        [centerBtn setFrame:CGRectMake((DeviceWidth/2) - 47.5, height, 95, 55)];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
