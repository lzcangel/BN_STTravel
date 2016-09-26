//
//  SJR_HomeViewModel.h
//  ShiJuRenClient
//
//  Created by xuwk on 15/9/21.
//  Copyright (c) 2015年 qijuntonglian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJR_AdInfo : NSObject

@property (nonatomic,assign) long     advertisementId;//广告ID
@property (nonatomic,strong) NSString *settingValue;//广告地址
@property (nonatomic,strong) NSString *hrefUrl;//跳转地址

@end

@interface SJR_RecommendSuppliers : NSObject

@property (nonatomic,assign) long     supplierId;//供应商ID
@property (nonatomic,strong) NSString *supplierName;//供应商名称
@property (nonatomic,assign) BOOL     ealNameAuth;//实名认证 0未认证 1认证
@property (nonatomic,assign) long     tradSore;//易评分（0到100整数）
@property (nonatomic,strong) NSString *mainStoneCategory;//主要石材品种


@end

@interface SJR_HotSaleTailGoods : NSObject //热销尾货

@property (nonatomic,assign) long     tailGoodsId;//尾货ID
@property (nonatomic,strong) NSString *tailGoodsPic;//尾货图片
@property (nonatomic,strong) NSString *stoneName;//石材名称

@property (nonatomic,assign) int      supplierType;//供应商类型 1:工厂 2：经销商
@property (nonatomic,strong) NSString *supplierTypeDesc;//供应商类型描述
@property (nonatomic,strong) NSString *spec;//规格
@property (nonatomic,strong) NSString *price;//单价（元）
@property (nonatomic,strong) NSString *unit;//单位
@property (nonatomic,strong) NSString *tailGoodsName;//尾货名称
@property (nonatomic,strong) NSString *supplierName;//供应商名称
@property (nonatomic,assign) int      realNameAuth;//实名认证 0未认证 1认证
@property (nonatomic,assign) long     tradScore;//交易评分(0-100)
@property (nonatomic,assign) long     totalDealCount;//成交单数

//@property (nonatomic,assign) int      tailGoodsId;//主键
//@property (nonatomic,strong) NSString *tailGoodsName;//尾货名称
//@property (nonatomic,assign) int      minAmount;//金额(元)
//@property (nonatomic,assign) int      maxAmount;//金额(元)
//@property (nonatomic,strong) NSString *supplierName;//供应商名称
//@property (nonatomic,strong) NSString *picUrl;//图片地址
//@property (nonatomic,assign) int      tradScore;//交易评分（0-100）


@end

@interface SJR_ProjectCases : NSObject //工程案例

@property (nonatomic,assign) int      homePageProjectCaseId;//主键
@property (nonatomic,strong) NSString *projectCaseName;//工程案例名称
@property (nonatomic,assign) int      homePagePosition;//图片首页位置(从左到右，从上到下排位1到3)
@property (nonatomic,strong) NSString *picUrl;//图片url


@end

@interface SJR_PurchaseGuide : NSObject //采购指南

@property (nonatomic,strong)NSString *stoneEncyclopaediasId;//32位UUID
@property (nonatomic,strong)NSString *titleName;//标题
@property (nonatomic,strong)NSString *picUrl;//图片地址
@property (nonatomic,strong)NSString *chapterHtmlUrl;//章节HTML地址
@property (nonatomic,strong)NSString *chapterShareUrl;//章节分享地址

@end

@interface SJR_HomeViewModel : NSObject

@property (nonatomic,strong) NSArray *adViewsArray;
@property (nonatomic,assign) BOOL    adViewsArrayLoading;

@property (nonatomic,strong) NSArray *adInfoArray;

@property (nonatomic,strong) NSArray *purchaseGuideArray;//SJR_PurchaseGuide
@property (nonatomic,assign) BOOL    purchaseGuideArrayLoading;

@property (nonatomic,strong) NSArray *projectCasesArray;//SJR_ProjectCases
@property (nonatomic,assign) BOOL    projectCasesArrayLoading;

@property (nonatomic,strong) NSArray *hotSaleTailGoodsArray;//SJR_HotSaleTailGoods
@property (nonatomic,assign) BOOL    hotSaleTailGoodsArrayLoading;

@property (nonatomic,strong) NSArray *recommendSuppliersArray;//SJR_RecommendSuppliers
@property (nonatomic,assign) BOOL    recommendSuppliersArrayLoading;


/**
 *  获取广告轮播
 *
 */
- (void)getHomePageAdList;

/**
 *  获取采购指南
 */
- (void)getPurchaseGuideList;

/**
 *  获取工程案例
 */
- (void)getProjectCasesList;

/**
 *  热销尾货
 */
- (void)getHotSaleTailGoodsList;

/**
 *  推荐供应商
 */
- (void)getRecommendSuppliersList;

/**
 *  5.1.11 活动
 */
- (void)getActivityHudBlock:(void (^)(NSDictionary*dic, NSError *error))dataBlock;

@end

