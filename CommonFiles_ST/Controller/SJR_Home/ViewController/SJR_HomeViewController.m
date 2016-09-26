//
//  SJR_HomeViewController.m
//  ShiJuRenClient
//
//  Created by yqc on 15/11/11.
//  Copyright © 2015年 qijuntonglian. All rights reserved.
//

#import "SJR_HomeViewController.h"
#import "SJR_TabBarController.h"
#import "UINavigationBar+Awesome.h"
#import "SJR_HomeEngineerCaseCell.h"
#import "SJR_ReactViewController.h"
#import "CycleScrollView.h"
#import "UnReadBubbleView.h"
#import "UIButton+WebCache.h"
#import "SJR_HomeSupplierTableViewCell.h"
#import "SJR_HomeHotSaleTailGoodCell.h"
#import "SJR_SJR_SupplierDetailViewController.h"
#import "SJR_URLViewController.h"
#import "SJR_MessageViewController.h"
#import "MJRefresh.h"
#import "SJR_MessageViewModel.h"
#import "SJR_MessageViewController.h"
#import "ZipArchive.h"
#import "SJR_ActivityWebView.h"
#import "SJR_TRYJSD.h"

#define NAVBAR_CHANGE_POINT 50

typedef NS_ENUM(NSInteger, BtnActionEvent) {
    BtnInquiryEvent           = 101,
    BtnPurchaseManagerEvent   = 103,
    BtnHotSaleEvent           = 104,
    BtnSupplierEvent          = 105,
    BtnSearchPriceEvent       = 106,
    BtnSearchFreightEvent     = 107,
    BtnMorePurchaseGuideEvent = 110,
    BtnMoreProjectCaseEvent   = 111,
    BtnMoreProjectCase1Event  = 112,
    BtnMoreProjectCase2Event  = 113,
    BtnMoreProjectCase3Event  = 114,
    BtnMoreHomeHotSaleEvent   = 115,
    BtnMessageEvent           = 121,
    BtnHomeCustomerEvent      = 122,
};

@interface SJR_PurchaseGuideCell()

@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnMiddle;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;


@end

@implementation SJR_PurchaseGuideCell

- (void)awakeFromNib {
    @weakify(self);
  [RACObserve(self, infoArray) subscribeNext:^(NSArray *array) {
      @strongify(self);
      if(array.count > 0){
          SJR_PurchaseGuide *info_1 = array[0];
                [self.btnLeft sd_setImageWithURL:[NSURL URLWithString:info_1.picUrl] forState:UIControlStateNormal placeholderImage:IMAGE(@"SJR_LoadFailed256")];
          self.leftLabel.text = info_1.titleName;
      }
      if(array.count > 1){
          SJR_PurchaseGuide *info_2 = array[1];
                [self.btnMiddle sd_setImageWithURL:[NSURL URLWithString:info_2.picUrl] forState:UIControlStateNormal placeholderImage:IMAGE(@"SJR_LoadFailed256")];
          self.middleLabel.text = info_2.titleName;
      }
      if(array.count > 2){
          SJR_PurchaseGuide *info_3 = array[2];
                [self.btnRight sd_setImageWithURL:[NSURL URLWithString:info_3.picUrl] forState:UIControlStateNormal placeholderImage:IMAGE(@"SJR_LoadFailed256")];
          self.rightLabel.text = info_3.titleName;
      }
      self.btnLeft.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
  }];
    
}

- (IBAction)btnAction:(UIButton *)sender
{
    if(self.infoArray.count <= (sender.tag - 101))return ;
    SJR_PurchaseGuide *info = self.infoArray[sender.tag - 101];
    SJR_URLViewController *urlViewController = [[SJR_URLViewController alloc]init];
    urlViewController.showShare = YES;
    urlViewController.title = info.titleName;
    urlViewController.urlSr = info.chapterHtmlUrl;
    urlViewController.showUrl = info.chapterShareUrl;
    [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:urlViewController animated:YES];
}

@end

@interface SJR_HomeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    CGRect initialFrame;
    CGFloat defaultViewHeight;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *tableViewHeader;
@property (weak, nonatomic) IBOutlet UIView *searchButtonView;
@property (weak, nonatomic) IBOutlet UIView *headerADView;
@property (nonatomic , retain)  CycleScrollView   *mainScorllView;
@property (nonatomic,strong)UnReadBubbleView *bubble;

@property (nonatomic,strong)SJR_HomeViewModel *viewModel;
@property (nonatomic,strong)SJR_MessageViewModel *messageViewModel;

@property (nonatomic,strong)SJR_ActivityWebView *activityWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnLayout;
@property (nonatomic,strong)IBOutlet UIButton *phoneBtn;

@property (nonatomic,strong)SJR_TRYJSD *ddd;

@end

@implementation SJR_HomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [(SJR_TabBarController*)self.tabBarController setTabBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor blueColor]];
    [self scrollViewDidScroll:self.tableview];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [[self.navigationController.navigationBar layer] setShadowOffset:CGSizeMake(1.5, 1.5)];
    [[self.navigationController.navigationBar layer] setShadowRadius:1];
    [[self.navigationController.navigationBar layer] setShadowOpacity:0.0];
    [[self.navigationController.navigationBar layer] setShadowColor:[UIColor colorWithRed:0.3604 green:0.3754 blue:0.3831 alpha:1.0].CGColor];
    
    UIColor * color = [UIColor whiteColor];
    CGFloat offsetY = self.tableview.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = 0.4 + MIN(0.7, 0.7 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        [[self.navigationController.navigationBar layer] setShadowOpacity:alpha - 0.3];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0.3]];
        [[self.navigationController.navigationBar layer] setShadowOpacity:0.0];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3]];
    [[self.navigationController.navigationBar layer] setShadowOpacity:0.0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ddd = [[SJR_TRYJSD alloc]init];
    [self.ddd getHomePageAdList];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.ddd = nil;
    });
}

- (void)failRecord
{

}
- (void)beginConvert
{
    
}
- (void)endConvertWithData:(NSData *)voiceData
{
    NSLog(@"%ld",voiceData.length);
}



- (IBAction)btnAction:(UIButton *)sender
{
    switch (sender.tag) {
        case BtnInquiryEvent:
        {
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"SJR_InquiryManagerView" bundle:nil];
            QJTL_BaseViewController* viewController1 = [storyboard instantiateViewControllerWithIdentifier:@"SJR_InquiryManagerViewController"];
            [self.navigationController pushViewController:viewController1 animated:YES];
        }
            break;
        case BtnPurchaseManagerEvent:
        {
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"SJR_PurchaseManagerView" bundle:nil];
            QJTL_BaseViewController* viewController1 = [storyboard instantiateViewControllerWithIdentifier:@"SJR_PurchaseManagerStory"];
            [self.navigationController pushViewController:viewController1 animated:YES];
        }
            break;
        case BtnHotSaleEvent:
        {
            NSNumber *version = [[NSUserDefaults standardUserDefaults] objectForKey:HOTVERSIONCODE];
            if(version.intValue >= 1)
            {
                SJR_ReactViewController* viewController = [[NSClassFromString(@"SJR_ReactViewController") alloc] init];
                viewController.moduleName = @"HotSaleList";
                [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:viewController animated:YES];
            }
            else
            {
               [self showHudPrompt:@"玩命开发中，尽请期待"];
            }
        }
            break;
        case BtnSupplierEvent:
        {
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"SJR_SupplierListView" bundle:nil];
            QJTL_BaseViewController* viewController1 = [storyboard instantiateViewControllerWithIdentifier:@"SJR_SupplierListViewController"];
            [self.navigationController pushViewController:viewController1 animated:YES];
        }
            break;
        case BtnSearchPriceEvent:
        {
            QJTL_BaseViewController* viewController = [[NSClassFromString(@"SJR_SearchStonePriceController") alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case BtnSearchFreightEvent:
        {
            QJTL_BaseViewController* viewController = [[NSClassFromString(@"SJR_SearchFreightController") alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case BtnMorePurchaseGuideEvent:
        {
            SJR_ReactViewController* viewController = [[NSClassFromString(@"SJR_ReactViewController") alloc] init];
            viewController.moduleName = @"consumerGuideNav";
            [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:viewController animated:YES];
        }
            break;
        case BtnMoreProjectCaseEvent:
        {
            SJR_ReactViewController* viewController = [[NSClassFromString(@"SJR_ReactViewController") alloc] init];
            viewController.moduleName = @"Meiztu";
            [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:viewController animated:YES];
        }
            break;
        case BtnMoreProjectCase1Event:
        {
            if(self.viewModel.projectCasesArray.count < 1)return ;
            SJR_ReactViewController* viewController = [[NSClassFromString(@"SJR_ReactViewController") alloc] init];
            viewController.moduleName = @"Meiztu";
            SJR_ProjectCases *projectCases = self.viewModel.projectCasesArray[0];
            viewController.initialProperties = @{@"projectCaseId":[NSNumber numberWithInt:projectCases.homePageProjectCaseId]};
            [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:viewController animated:YES];
        }
            break;
        case BtnMoreProjectCase2Event:
        {
            if(self.viewModel.projectCasesArray.count < 2)return ;
            SJR_ReactViewController* viewController = [[NSClassFromString(@"SJR_ReactViewController") alloc] init];
            viewController.moduleName = @"Meiztu";
            SJR_ProjectCases *projectCases = self.viewModel.projectCasesArray[1];
            viewController.initialProperties = @{@"projectCaseId":[NSNumber numberWithInt:projectCases.homePageProjectCaseId]};
            [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:viewController animated:YES];
        }
            break;
        case BtnMoreProjectCase3Event:
        {
            if(self.viewModel.projectCasesArray.count < 3)return ;
            SJR_ReactViewController* viewController = [[NSClassFromString(@"SJR_ReactViewController") alloc] init];
            viewController.moduleName = @"Meiztu";
            SJR_ProjectCases *projectCases = self.viewModel.projectCasesArray[2];
            viewController.initialProperties = @{@"projectCaseId":[NSNumber numberWithInt:projectCases.homePageProjectCaseId]};
            [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:viewController animated:YES];
        }
            break;
        case BtnMoreHomeHotSaleEvent:
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否联系客服购买尾货？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert.rac_buttonClickedSignal subscribeNext:^(NSNumber *value) {
                if (value.intValue == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://05928555666"]];
                }
            }];
            [alert show];
        }
            break;
        case BtnMessageEvent:
        {
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"SJR_MessageView" bundle:nil];
            SJR_MessageViewController* viewController1 = [storyboard instantiateViewControllerWithIdentifier:@"SJR_MessageViewController"];
            viewController1.viewModel = self.messageViewModel;
            [self.navigationController pushViewController:viewController1 animated:YES];
        }
          break;
            case BtnHomeCustomerEvent:
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否呼叫0592-8555666" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert.rac_buttonClickedSignal subscribeNext:^(NSNumber *value) {
                if (value.intValue == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://05928555666"]];
                }
            }];
            [alert show];
        }
            break;
        default:
        {
            [self showHudPrompt:@"玩命开发中，尽请期待"];
        }
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)buildControls {
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        SJR_URLViewController *ccc = [[SJR_URLViewController alloc]init];
//        ccc.urlSr = @"http://192.168.0.167/updateDemo/webDemo.html";
//        [self.navigationController pushViewController:ccc animated:YES];
//        
//    });

    _viewModel = [[SJR_HomeViewModel alloc]init];
//    [_viewModel getHomePageAdList];
//    [_viewModel getProjectCasesList];
//    [_viewModel getPurchaseGuideList];
//    [_viewModel getHotSaleTailGoodsList];
//    [_viewModel getRecommendSuppliersList];
    
    self.messageViewModel = [[SJR_MessageViewModel alloc]init];
    if([SJR_UserInfo sharedUserInfo].token != nil)[self.messageViewModel getMessageInfoArrayClearData:YES];

    
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.backgroundView.backgroundColor = [UIColor clearColor];
    
    NSMutableArray* imageArray = [NSMutableArray array];
    for (int i = 0;i < 5; i++ ) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 159 * DeviceWidth/320.0)];
        imageView.image = [UIImage imageNamed:@"SJR_HomeBanner"];
        [imageArray addObject:imageView];
    }
    self.viewModel.adViewsArray = imageArray;
    self.mainScorllView                         = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 159 * DeviceWidth/320.0) animationDuration:5];
    self.mainScorllView.backgroundColor         = [[UIColor clearColor] colorWithAlphaComponent:0.2];
    
    __weak typeof(self) temp = self;
    self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        if(temp.viewModel.adViewsArray.count <= pageIndex)return [[UIView alloc] init];
        return temp.viewModel.adViewsArray[pageIndex];
    };
    self.mainScorllView.totalPagesCount         = ^NSInteger(void){
        return temp.viewModel.adViewsArray.count;
    };
    self.mainScorllView.TapActionBlock          = ^(NSInteger pageIndex){
        NSLog(@"点击了第%ld个",(long)pageIndex);
        if(temp.viewModel.adInfoArray.count >=2)
        {
            SJR_AdInfo *info                         = temp.viewModel.adInfoArray[pageIndex];
            if(info.hrefUrl == nil || info.hrefUrl.length == 0)return ;
            SJR_URLViewController *urlViewController = [[SJR_URLViewController alloc]init];
            urlViewController.title                  = @"广告";
            urlViewController.urlSr                  = info.hrefUrl;
            urlViewController.showUrl                = info.hrefUrl;
            [temp.navigationController pushViewController:urlViewController animated:YES];
        }
    };
    [self.headerADView addSubview:self.mainScorllView];
    
    @weakify(self);
    [RACObserve(_viewModel, adViewsArray) subscribeNext:^(id x) {
        @strongify(self);
        self.mainScorllView.totalPagesCount = ^NSInteger(void){
            return temp.viewModel.adViewsArray.count;
        };
    }];
    
    [[RACSignal combineLatest:@[RACObserve(self.viewModel, adViewsArrayLoading),
                               RACObserve(self.viewModel, purchaseGuideArrayLoading),
                               RACObserve(self.viewModel, projectCasesArrayLoading),
                               RACObserve(self.viewModel, hotSaleTailGoodsArrayLoading),
                               RACObserve(self.viewModel, recommendSuppliersArrayLoading),
                                                      ] reduce:^(NSNumber *value1,NSNumber *value2,NSNumber *value3,NSNumber *value4,NSNumber *value5) {
                                                          NSLog(@"%@%@%@%@%@",value1,value2,value3,value4,value5);
                                                          return @(value1.boolValue || value2.boolValue || value3.boolValue || value4.boolValue || value5.boolValue);
                                                      }] subscribeNext:^(NSNumber *value) {
                                                          @strongify(self);
                                                          if(value.boolValue == NO)
                                                          {
                                                              [self.tableview reloadData];
                                                              [self.tableview headerEndRefreshing];
                                                          }
                                                      }];
    
    [self.tableview addHeaderWithCallback:^{
        [temp.viewModel getHomePageAdList];
        [temp.viewModel getProjectCasesList];
        [temp.viewModel getPurchaseGuideList];
        [temp.viewModel getHotSaleTailGoodsList];
        [temp.viewModel getRecommendSuppliersList];
        if([SJR_UserInfo sharedUserInfo].token != nil)
        {
            [temp.messageViewModel getMessageInfoArrayClearData:YES];
        }
        else
        {
            self.bubble.hidden = YES;
        }
    }];
    
    [self.tableview setRefreshBlock:^{
        [temp.viewModel getHomePageAdList];
        [temp.viewModel getProjectCasesList];
        [temp.viewModel getPurchaseGuideList];
        [temp.viewModel getHotSaleTailGoodsList];
        [temp.viewModel getRecommendSuppliersList];
        if([SJR_UserInfo sharedUserInfo].token != nil)
        {
            [temp.messageViewModel getMessageInfoArrayClearData:YES];
        }
        else
        {
            self.bubble.hidden = YES;
        }
    }];
    
    [RACObserve(_messageViewModel, messageInfoArray) subscribeNext:^(NSArray *array) {
        @strongify(self);
        int num = 0;
        for(SJR_MessageInfo *info in array)
        {
            num = num + info.messageNums;
        }
        NSString *numStr = num > 99 ? @"99+":[NSString stringWithFormat:@"%d",num];
        _bubble.hidden = num == 0 ? YES:NO;
        self.bubble.bubbleLabel.text = numStr;
    }];
    
    [self.viewModel getActivityHudBlock:^(NSDictionary *dic, NSError *error) {
        NSLog(@"活动信息回调%@ %@",dic,error);
        if(error != nil)return ;
        NSString *activityUrl = [dic objectForKey:@"activityUrl"];
//        NSString *activityUrl = @"http://192.168.0.167/updateDemo/webDemo.html";
        NSNumber *isHasActivity = [dic objectForKey:@"isHasActivity"];
        if(isHasActivity.boolValue == NO)return;
        temp.activityWebView = [[SJR_ActivityWebView alloc]init];
        [temp.activityWebView showActivityInSupViewCon:self url:activityUrl];
        NSLog(@"活动信息回调%@",dic);
    }];
}

- (void)setControlsFrame {
    CGRect rect                = _tableViewHeader.frame;
    rect.size.height           = _searchButtonView.frame.origin.y + _searchButtonView.frame.size.height + 10;
    _tableViewHeader.frame     = rect;
    _tableview.tableHeaderView = _tableViewHeader;

//    defaultViewHeight          = initialFrame.size.height;
}

- (void)loadCustomNavigationButton
{
    [super loadCustomNavigationButton];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:IMAGEOriginal(@"SJR_HomeNav")];
    [self.navigationItem.leftBarButtonItem setImage:IMAGEOriginal(@"SJR_HomeNavLeft")];
    
    UIButton *messageBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    messageBtn.tag = BtnMessageEvent;
    [messageBtn setImage:IMAGE(@"SJR_MessageBtn") forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    _bubble=[[UnReadBubbleView alloc] initWithFrame:CGRectMake(messageBtn.frame.size.width/2.0, 0, 20, 25)];
    [_bubble setBubbleWidth:28];
    [messageBtn addSubview:self.bubble];
    _bubble.bubbleLabel.text = @"0";
    _bubble.hidden = YES;
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:messageBtn];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if(scrollView.contentOffset.y>=0)
    {
        CATransform3D transform                 = CATransform3DIdentity;
        transform                               = CATransform3DScale(transform, 1, 1.0, 1);
        transform                               = CATransform3DTranslate(transform, 0, (scrollView.contentOffset.y)/2.0, 0);
     //   _headerBackgroundView.layer.transform = transform;
    }
    else
    {
        float y_offset                          = scrollView.contentOffset.y;
        float height = DeviceWidth * 10/27.0;
        CATransform3D transform                 = CATransform3DIdentity;
        transform                               = CATransform3DTranslate(transform, 0, (scrollView.contentOffset.y)/2.0, 0);
        transform                               = CATransform3DScale(transform, (height-y_offset)/height, (height-y_offset)/height, 1);
       // _headerBackgroundView.layer.transform = transform;
    }
    
    //UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    UIColor * color = [UIColor whiteColor];
    CGFloat offsetY = scrollView.contentOffset.y;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (offsetY > NAVBAR_CHANGE_POINT) {
            CGFloat alpha = 0.4 + MIN(0.7, 0.7 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
            [[self.navigationController.navigationBar layer] setShadowOpacity:alpha - 0.3];
        } else {
            [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0.3]];
            [[self.navigationController.navigationBar layer] setShadowOpacity:0.0];
        }
    });
    
    static int _lastPosition;
    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion - _lastPosition > 25) {
        _lastPosition = currentPostion;
        NSLog(@"ScrollUp now");
        [UIView animateWithDuration:0.3 animations:^{
            self.btnLayout.constant = -50;
            [self.phoneBtn layoutIfNeeded];
        }];
    }
    else if (_lastPosition - currentPostion > 25)
    {
        _lastPosition = currentPostion;
        NSLog(@"ScrollDown now");
        [UIView animateWithDuration:0.3 animations:^{
            self.btnLayout.constant = 15;
            [self.phoneBtn layoutIfNeeded];
        }];
    }
}

- (void)setNavigationBarTransformProgress:(CGFloat)progress
{
    [self.navigationController.navigationBar lt_setTranslationY:(-44 * progress)];
    [self.navigationController.navigationBar lt_setElementsAlpha:(1-progress)];
}


#pragma mark - tableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell* headerCell;
    switch (section) {
        case 0:
            headerCell = [self.tableview dequeueReusableCellWithIdentifier:@"SJR_HomeBuyingGuideSection"];
            break;
        case 1:
            headerCell = [self.tableview dequeueReusableCellWithIdentifier:@"SJR_HomeEngineerCaseSection"];
            break;
        case 2:
            headerCell = [self.tableview dequeueReusableCellWithIdentifier:@"SJR_HomeHotSurplusSection"];
            break;
        case 3:
            headerCell = [self.tableview dequeueReusableCellWithIdentifier:@"SJR_HomeRecommendSuplierSection"];
            break;
        default:
            break;
    }
    UIButton* headerCellButton = [headerCell viewWithTag:1];
    if (section > 0) {   //section0没有更多的按钮
        [[headerCellButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            NSLog(@"sectin%ld 的按钮被按下",(long)section);
        }];
    }
    
    return headerCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView* clearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 10)];
    clearView.backgroundColor = [UIColor clearColor];
    return clearView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 114;
            break;
        case 1:
            return 157 * DeviceWidth / 320;
            break;
        case 2:
            return 142;
            break;
        case 3:
            return 80;
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return self.viewModel.hotSaleTailGoodsArray.count;
            break;
        case 3:
            return self.viewModel.recommendSuppliersArray.count;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            SJR_PurchaseGuideCell* cell = [self.tableview dequeueReusableCellWithIdentifier:@"SJR_HomeBuyingGuide"];
            cell.infoArray = self.viewModel.purchaseGuideArray;
            return cell;
        }
        case 1:
        {
            SJR_HomeEngineerCaseCell* cell = [self.tableview dequeueReusableCellWithIdentifier:@"SJR_HomeEngineerCase"];
            cell.infoArray = self.viewModel.projectCasesArray;
            return cell;
        }
            break;
        case 2:
        {
            SJR_HomeHotSaleTailGoodCell* cell = [self.tableview dequeueReusableCellWithIdentifier:@"SJR_HomeHotSurplus"];
            cell.info = self.viewModel.hotSaleTailGoodsArray[indexPath.row];
            return cell;
        }
        case 3:
        {
            SJR_HomeSupplierTableViewCell* cell = [self.tableview dequeueReusableCellWithIdentifier:@"SJR_HomeRecommendSuplier"];
            cell.info = self.viewModel.recommendSuppliersArray[indexPath.row];
            return cell;
        }
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.section) {
        case 0:
        {

        }
        case 1:
        {

        }
            break;
        case 2:
        {
            SJR_ReactViewController* viewController = [[NSClassFromString(@"SJR_ReactViewController") alloc] init];
            viewController.moduleName = @"hotSaleDetailsNav";
            SJR_HotSaleTailGoods *saleTailGoods =  self.viewModel.hotSaleTailGoodsArray[indexPath.row];
            viewController.initialProperties = @{@"tailGoodsId":[NSNumber numberWithInt:saleTailGoods.tailGoodsId]};
            [(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController pushViewController:viewController animated:YES];
            
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否联系客服购买尾货？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            [alert.rac_buttonClickedSignal subscribeNext:^(NSNumber *value) {
//                if (value.intValue == 1) {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://05928555666"]];
//                }
//            }];
//            [alert show];
        }
            break;
        case 3:
        {
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"SJR_SupplierListView" bundle:nil];
            SJR_SJR_SupplierDetailViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"SJR_SJR_SupplierDetailViewController"];
            SJR_RecommendSuppliers *suppliers = self.viewModel.recommendSuppliersArray[indexPath.row];
            viewController.viewModel = [SJR_SupplierInfo objectWithKeyValues:[suppliers keyValues]];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        default:
            break;
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
