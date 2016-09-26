//
//  SJR_HomeViewModel.m
//  ShiJuRenClient
//
//  Created by xuwk on 15/9/21.
//  Copyright (c) 2015年 qijuntonglian. All rights reserved.
//

#import "SJR_HomeViewModel.h"

@implementation SJR_AdInfo
@end

@implementation SJR_RecommendSuppliers
@end

@implementation SJR_HotSaleTailGoods
@end

@implementation SJR_ProjectCases
@end

@implementation SJR_PurchaseGuide
@end

@implementation SJR_HomeViewModel

/**
 *  获取广告轮播
 *
 */
- (void)getHomePageAdList
{
    NSDictionary *paraDic = @{@"userType":@2};
    __weak typeof(self) temp = self;
    self.adViewsArrayLoading = YES;
    [[ToolRequest getRequestManager] GET:[NSString stringWithFormat:@"%@/homePage/advertisementList",BASEURL] parameters:paraDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if(codeNumber.intValue == 0)
        {
            NSArray *adArray = [dic objectForKey:@"rows"];
            temp.adInfoArray = [SJR_AdInfo objectArrayWithKeyValuesArray:adArray];
            NSMutableArray *array = [[NSMutableArray alloc]init];
            if(adArray.count <2)
            {
                temp.adViewsArrayLoading = NO;
                return ;
            }
            for(NSDictionary *obj in adArray)
            {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 159 * DeviceWidth/320.0)];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                [imageView sd_setImageWithURL:[NSURL URLWithString:[obj objectForKey:@"settingValue"]] placeholderImage:IMAGE(@"SJR_LoadFailed640")];
                imageView.clipsToBounds = YES;
                [array addObject:imageView];
            }
            temp.adViewsArray = array;
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
            [ToolRequest showErrorCode:errorStr code:codeNumber.intValue];
        }
        temp.adViewsArrayLoading = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        temp.adViewsArrayLoading = NO;
        [ToolRequest showErrorCode:[NSString stringWithFormat:@"%@",error.localizedDescription] code:(int)error.code];
    }];
}



/**
 *  获取采购指南
 */
- (void)getPurchaseGuideList
{
    NSDictionary *paraDic = @{@"curPage":[NSNumber numberWithInt:0],@"pageNum":[NSNumber numberWithInt:3]};
    __weak typeof(self) temp = self;
    self.purchaseGuideArrayLoading = YES;
    [[ToolRequest getRequestManager] GET:[NSString stringWithFormat:@"%@/consumer/homePage/purchaseGuide",BASEURL] parameters:paraDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if(codeNumber.intValue == 0)
        {
            NSArray *adArray = [dic objectForKey:@"rows"];
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for(NSDictionary *obj in adArray)
            {
                [array addObject:[SJR_PurchaseGuide objectWithKeyValues:obj]];
            }
            temp.purchaseGuideArray = array;
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
            [ToolRequest showErrorCode:errorStr code:codeNumber.intValue];
        }
        temp.purchaseGuideArrayLoading = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        temp.purchaseGuideArrayLoading = NO;
        [ToolRequest showErrorCode:[NSString stringWithFormat:@"%@",error.localizedDescription] code:(int)error.code];
    }];
}

/**
 *  获取工程案例
 */
- (void)getProjectCasesList
{
    NSDictionary *paraDic = @{@"curPage":[NSNumber numberWithInt:0],@"pageNum":[NSNumber numberWithInt:3]};
    __weak typeof(self) temp = self;
    self.projectCasesArrayLoading = YES;
    [[ToolRequest getRequestManager] GET:[NSString stringWithFormat:@"%@/consumer/homePage/projectCases",BASEURL] parameters:paraDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if(codeNumber.intValue == 0)
        {
            NSArray *adArray = [dic objectForKey:@"rows"];
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for(NSDictionary *obj in adArray)
            {
                [array addObject:[SJR_ProjectCases objectWithKeyValues:obj]];
            }
            temp.projectCasesArray = array;
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
            [ToolRequest showErrorCode:errorStr code:codeNumber.intValue];
        }
        temp.projectCasesArrayLoading = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        temp.projectCasesArrayLoading = NO;
        [ToolRequest showErrorCode:[NSString stringWithFormat:@"%@",error.localizedDescription] code:(int)error.code];
    }];
}

/**
 *  热销尾货
 */
- (void)getHotSaleTailGoodsList
{
    NSDictionary *paraDic = @{@"curPage":[NSNumber numberWithInt:0],@"pageNum":[NSNumber numberWithInt:3]};
    __weak typeof(self) temp = self;
    self.hotSaleTailGoodsArrayLoading = YES;
    [[ToolRequest getRequestManager] GET:[NSString stringWithFormat:@"%@/consumer/tailGoods/list",BASEURL] parameters:paraDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if(codeNumber.intValue == 0)
        {
            NSArray *adArray = [dic objectForKey:@"rows"];
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for(NSDictionary *obj in adArray)
            {
                [array addObject:[SJR_HotSaleTailGoods objectWithKeyValues:obj]];
            }
            temp.hotSaleTailGoodsArray = array;
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
            [ToolRequest showErrorCode:errorStr code:codeNumber.intValue];
        }
        temp.hotSaleTailGoodsArrayLoading = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        temp.hotSaleTailGoodsArrayLoading = NO;
        NSLog(@"%@",error);
        [ToolRequest showErrorCode:[NSString stringWithFormat:@"%@",error.localizedDescription] code:(int)error.code];
    }];
}

/**
 *  推荐供应商
 */
- (void)getRecommendSuppliersList
{
    NSDictionary *paraDic = @{@"curPage":[NSNumber numberWithInt:0],@"pageNum":[NSNumber numberWithInt:3]};
    __weak typeof(self) temp = self;
    self.recommendSuppliersArrayLoading = YES;
    [[ToolRequest getRequestManager] GET:[NSString stringWithFormat:@"%@/consumer/homePage/recommendSuppliers",BASEURL] parameters:paraDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if(codeNumber.intValue == 0)
        {
            NSArray *adArray = [dic objectForKey:@"rows"];
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for(NSDictionary *obj in adArray)
            {
                [array addObject:[SJR_RecommendSuppliers objectWithKeyValues:obj]];
            }
            temp.recommendSuppliersArray = array;
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
            [ToolRequest showErrorCode:errorStr code:codeNumber.intValue];
        }
        temp.recommendSuppliersArrayLoading = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        temp.recommendSuppliersArrayLoading = NO;
        [ToolRequest showErrorCode:[NSString stringWithFormat:@"%@",error.localizedDescription] code:(int)error.code];
    }];
}

/**
 *  5.1.11 活动
 */
- (void)getActivityHudBlock:(void (^)(NSDictionary*dic, NSError *error))dataBlock
{
    NSDictionary *paraDic = @{@"systemType":@(2),@"userType":@(2)};
    NSString *url = [NSString stringWithFormat:@"%@/homePage/activity",BASEURL];
    NSLog(@"%@",url);
    __weak typeof(self) temp = self;
    [[ToolRequest getRequestManager] GET:url parameters:paraDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if(codeNumber.intValue == 0)
        {
            NSDictionary *dataDic = [dic objectForKey:@"result"];
            dataBlock(dataDic,nil);
            NSLog(@"成功 %@",dic);
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
            dataBlock(nil,[NSError errorWithDomain:errorStr
                                          code:codeNumber.intValue
                                      userInfo:nil]);
            [ToolRequest showErrorCode:errorStr code:codeNumber.intValue];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dataBlock(nil,error);
        [ToolRequest showErrorCode:[NSString stringWithFormat:@"%@",error.localizedDescription] code:(int)error.code];
    }];
}

@end




