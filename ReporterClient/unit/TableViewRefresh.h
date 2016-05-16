//
//  TableViewRefresh.h
//  ReporterClient
//
//  Created by easaa on 4/16/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZZTABLEHEAD_Y (-40.0) //UITableView的头部提示文字Y坐标距离
#define ZZTABLEFOOT_Y (10.0) //UITableView的尾部提示文字Y坐标距离
#define ZZTABLEREFULSH_Y (40.0) //UITableView的下拉刷新和上拉加载的Y坐标距离
#define ZZTABLEHEADTITLE_REFLUSHING @"正在刷新中……" //UITableView的正在刷新文字
#define ZZTABLEHEADTITLE_CONTINUE @"正在加载中……" //UITableView的正在加载文字
#define ZZTABLEHEADTITLE_DEFAULFT @"下拉可以刷新" //UITableView的头部正常状态文字
#define ZZTABLEHEADTITLE_SHOLUDREFLUSH @"松开即将刷新" //UITableView的头部松手刷新文字

#define ZZTABLEFOOTTITLE_DEFAULFT @"上拉可以加载" //UITableView的尾部正常状态文字
#define ZZTABLEFOOTTITLE_SHOLUDDOWNLOAD @"松开即将加载" //UITableView的尾部松手加载文字
#define ZZTABLEFOOTTITLE_FINISH @"已经是最后一条了" //UITableView的尾部松手加载文字

typedef NS_ENUM(NSInteger, ZZTableShowType)
{
    ZZTableShowTypeAscend = 0,//正序
    ZZTableShowTypeDescend = 1,//倒序
};


@protocol ZZTableViewReFreshDelegate;

@interface TableViewRefresh : UIView
{
    UILabel *tableViewHeadTitleLabel;
    UILabel *tableViewHeadTimeLabel;
    UILabel *tableViewFootLabel;
    
}
@property (nonatomic, assign)id delegate;
@property (nonatomic, assign)ZZTableShowType showType;
@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, assign)BOOL refreshing;
@property (nonatomic, assign)BOOL lastPage;
@property (nonatomic, retain)UILabel *tableViewHeadTitleLabel;
@property (nonatomic, retain)UILabel *tableViewHeadTimeLabel;
@property (nonatomic, retain)UILabel *tableViewFootLabel;

-(id)initWith:(UITableView *)tableView;
-(id)initWith:(UITableView *)tableView withShowType:(ZZTableShowType)showType;

-(void)beginReLoadData;

-(void)reLoadDataSuccse:(BOOL)succse isLastPage:(BOOL)lastPage;//刷新数据后调用此方法,加载后succse 1:成功 2:失败 lastPage: 1.最后一条 2.不是最后一条
-(void)continueLoadDataSuccse:(BOOL)succse isLastPage:(BOOL)lastPage;//加载数据后调用此方法 加载后succse 1:成功 2:失败 lastPage: 1.最后一条 2.不是最后一条

-(void)setFootLabelFrame;


- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end

@protocol ZZTableViewReFreshDelegate <NSObject>

@optional
-(void)mustReLaodData:(TableViewRefresh *)tableViewReFresh;//达到刷新条件，应开启多线程重新加载数据
-(void)mustContinueLoadData:(TableViewRefresh *)tableViewReFresh;//达到加载下页的条件，应开启多线程继续加载数据

@end
