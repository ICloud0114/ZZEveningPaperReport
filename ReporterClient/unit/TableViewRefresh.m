//
//  TableViewRefresh.m
//  ReporterClient
//
//  Created by easaa on 4/16/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "TableViewRefresh.h"

@implementation TableViewRefresh
@synthesize tableViewFootLabel;
@synthesize tableViewHeadTimeLabel;
@synthesize tableViewHeadTitleLabel;

-(id)initWith:(UITableView *)tableView
{
    self = [super init];
    if (self)
    {
        self.tableView = tableView;
        
        tableViewHeadTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ZZTABLEHEAD_Y, SCREENWIDTH, 15)];
        [_tableView addSubview:tableViewHeadTitleLabel];

        [tableViewHeadTitleLabel setText:ZZTABLEHEADTITLE_DEFAULFT];
        [tableViewHeadTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [tableViewHeadTitleLabel setFont:[UIFont systemFontOfSize:13]];
        [tableViewHeadTitleLabel setBackgroundColor:[UIColor clearColor]];
        
        tableViewHeadTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ZZTABLEHEAD_Y + 20, SCREENWIDTH, 15)];
        [_tableView addSubview:tableViewHeadTimeLabel];

        [tableViewHeadTimeLabel setTextAlignment:NSTextAlignmentCenter];
        [tableViewHeadTimeLabel setFont:[UIFont systemFontOfSize:13]];
        [tableViewHeadTimeLabel setBackgroundColor:[UIColor clearColor]];
        
        tableViewFootLabel = [[UILabel alloc]init];
        [_tableView addSubview:tableViewFootLabel];

        [tableViewFootLabel setFont:[UIFont systemFontOfSize:13]];
        [tableViewFootLabel setTextAlignment:NSTextAlignmentCenter];
        //    [tableViewFootLabel setText:ZZTABLEFOOTTITLE_DEFAULFT];
        [tableViewFootLabel setBackgroundColor:[UIColor clearColor]];
        
    }
    
    return self;
}

-(id)initWith:(UITableView *)tableView withShowType:(ZZTableShowType)showType
{
    if ([self initWith:tableView])
    {
        self.showType = showType;
    }
    return self;
}

-(void)setShowType:(ZZTableShowType)showType
{
    _showType = showType;
    
}

-(void)setFootLabelFrame
{
    [tableViewFootLabel setFrame:CGRectMake(0, _tableView.contentSize.height + ZZTABLEFOOT_Y, SCREENWIDTH, 15)];
}

-(void)reLoadDataSuccse:(BOOL)succse isLastPage:(BOOL)lastPage;//刷新完成后调用此方法,加载后succse 1:成功 2:失败 lastPage: 1.最后一条 2.不是最后一条
{
    _refreshing = NO;
    _lastPage = lastPage;
    [_tableView reloadData];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        UIEdgeInsets inset = _tableView.contentInset;
        inset.top = 0;
        [_tableView setContentInset:inset];
    }];
    if (succse == YES)
    {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        [tableViewHeadTimeLabel setText:[NSString stringWithFormat:@"上次刷新：%@", dateString]];
        [tableViewHeadTitleLabel setText:ZZTABLEHEADTITLE_DEFAULFT];
        
        switch (_showType)
        {
            case ZZTableShowTypeAscend:
            {
                if (_lastPage == YES)//已经是最后条了
                {
                    [tableViewFootLabel setText:ZZTABLEFOOTTITLE_FINISH];
                }
                else
                {
                    [tableViewFootLabel setText:ZZTABLEFOOTTITLE_DEFAULFT];
                }
                
            }
                break;
            case ZZTableShowTypeDescend://倒序
            {
                [tableViewHeadTimeLabel setText:nil];
                if (_lastPage == YES)//已经是最后条了
                {
                    [tableViewHeadTitleLabel setText:ZZTABLEFOOTTITLE_FINISH];
                }
                else
                {
                    [tableViewHeadTitleLabel setText:@"下拉加载更多"];
                }
            }
                
            default:
                break;
        }
        
        
        [self performSelector:@selector(setFootLabelFrame)];
        //        [tableViewFootLabel setFrame:CGRectMake(0, _tableView.contentSize.height + ZZTABLEFOOT_Y, 320, 15)];
        [self performSelector:@selector(setFootLabelFrame) withObject:nil afterDelay:0.05];
        
    }
    else
    {
        
    }
    
}
-(void)continueLoadDataSuccse:(BOOL)succse isLastPage:(BOOL)lastPage;//加载完成后调用此方法 加载后succse 1:成功 2:失败 lastPage: 1.最后一条 2.不是最后一条
{
    
    
    switch (_showType)
    {
        case ZZTableShowTypeAscend:
        {
            _refreshing = NO;
            _lastPage = lastPage;
            [_tableView reloadData];
        }
            break;
        case ZZTableShowTypeDescend://倒序
        {
            _refreshing = NO;
            [_tableView reloadData];
        }
            
        default:
            break;
    }
    
    
    [UIView animateWithDuration:0.5 animations:^{
        UIEdgeInsets inset = _tableView.contentInset;
        inset.bottom -= ZZTABLEREFULSH_Y;
        [_tableView setContentInset:inset];
    }];
    if (succse == YES)
    {
        //        [tableViewFootLabel setFrame:CGRectMake(0, _tableView.contentSize.height + ZZTABLEFOOT_Y, 320, 15)];
        [self performSelector:@selector(setFootLabelFrame)];
        [self performSelector:@selector(setFootLabelFrame) withObject:nil afterDelay:0.05];
        
        switch (_showType)
        {
            case ZZTableShowTypeAscend:
            {
                if (_lastPage == YES)//已经是最后条了
                {
                    [tableViewFootLabel setText:ZZTABLEFOOTTITLE_FINISH];
                }
                else
                {
                    [tableViewFootLabel setText:ZZTABLEFOOTTITLE_DEFAULFT];
                }
            }
                break;
            case ZZTableShowTypeDescend://倒序
            {
                
            }
                
            default:
                break;
        }
        
        
    }
    else
    {
        
    }
    
    
    
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    DLog(@"scrollView:%f",scrollView.contentOffset.y);
    //头部、尾部-------提示文字----------begin----------
    if (_refreshing == NO)
    {
        if (scrollView.contentOffset.y < -ZZTABLEREFULSH_Y)
        {
            [tableViewHeadTitleLabel setText:ZZTABLEHEADTITLE_SHOLUDREFLUSH];
            switch (_showType)
            {
                case ZZTableShowTypeAscend:
                {
                    //                   [tableViewHeadTitleLabel setText:ZZTABLEHEADTITLE_SHOLUDREFLUSH];
                    
                }
                    break;
                case ZZTableShowTypeDescend://倒序
                {
                    if (_lastPage == YES)//已经是最后条了
                    {
                        [tableViewHeadTitleLabel setText:ZZTABLEFOOTTITLE_FINISH];
                    }
                    else
                    {
                        if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height + ZZTABLEREFULSH_Y)//需要加载
                        {
                            [tableViewHeadTitleLabel setText:@"松开即将加载"];
                        }
                        else
                        {
                            [tableViewHeadTitleLabel setText:@"下拉加载更多"];
                        }
                    }
                    
                    
                }
                    
                default:
                    break;
            }
        }
        else
        {
            [tableViewHeadTitleLabel setText:ZZTABLEHEADTITLE_DEFAULFT];
            switch (_showType)
            {
                case ZZTableShowTypeAscend:
                {
                    //                    [tableViewHeadTitleLabel setText:ZZTABLEHEADTITLE_DEFAULFT];
                }
                    break;
                case ZZTableShowTypeDescend://倒序
                {
                    [tableViewHeadTitleLabel setText:@"下拉加载更多"];
                }
                    
                default:
                    break;
            }
        }
        
        if (_lastPage == YES)//已经是最后条了
        {
            [tableViewFootLabel setText:ZZTABLEFOOTTITLE_FINISH];
        }
        else
        {
            if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height + ZZTABLEREFULSH_Y)//需要加载
            {
                [tableViewFootLabel setText:ZZTABLEFOOTTITLE_SHOLUDDOWNLOAD];
            }
            else
            {
                [tableViewFootLabel setText:ZZTABLEFOOTTITLE_DEFAULFT];
            }
        }
        
    }
    //头部、尾部-------提示文字----------end------------
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    DLog(@"scrollView:%f",scrollView.contentOffset.y);
    if (_refreshing == NO)
    {
        switch (_showType)
        {
            case ZZTableShowTypeAscend:
            {
                if (scrollView.contentOffset.y < -ZZTABLEREFULSH_Y && scrollView.contentOffset.y < 0)//需要刷新
                {
                    [UIView animateWithDuration:0.2 animations:^{
                        UIEdgeInsets inset = scrollView.contentInset;
                        inset.top = ZZTABLEREFULSH_Y;
                        [scrollView setContentInset:inset];
                    }];
                    
                    _refreshing = YES;
                    [tableViewHeadTitleLabel setText:ZZTABLEHEADTITLE_REFLUSHING];
                    [tableViewFootLabel setText:ZZTABLEHEADTITLE_REFLUSHING];
                    switch (_showType)
                    {
                        case ZZTableShowTypeAscend:
                        {
                            //                    [tableViewHeadTitleLabel setText:ZZTABLEHEADTITLE_REFLUSHING];
                        }
                            break;
                        case ZZTableShowTypeDescend://倒序
                        {
                            [tableViewHeadTitleLabel setText:@"正在加载中……"];
                        }
                            
                        default:
                            break;
                    }
                    if ([_delegate respondsToSelector:@selector(mustReLaodData:)])
                    {
                        [_delegate mustReLaodData:self];
                    }
                }
            }
                break;
            case ZZTableShowTypeDescend://倒序
            {
                if (scrollView.contentOffset.y < -ZZTABLEREFULSH_Y && scrollView.contentOffset.y < 0)//需要刷新
                {
                    if (_lastPage == YES)//已经是最后条了
                    {
                        [tableViewHeadTitleLabel setText:ZZTABLEFOOTTITLE_FINISH];
                    }
                    else
                    {
                        [UIView animateWithDuration:0.2 animations:^{
                            UIEdgeInsets inset = scrollView.contentInset;
                            inset.top = ZZTABLEREFULSH_Y;
                            [scrollView setContentInset:inset];
                        }];
                        
                        _refreshing = YES;
                        [tableViewHeadTitleLabel setText:ZZTABLEHEADTITLE_REFLUSHING];
                        [tableViewFootLabel setText:ZZTABLEHEADTITLE_REFLUSHING];
                        switch (_showType)
                        {
                            case ZZTableShowTypeAscend:
                            {
                                //                    [tableViewHeadTitleLabel setText:ZZTABLEHEADTITLE_REFLUSHING];
                            }
                                break;
                            case ZZTableShowTypeDescend://倒序
                            {
                                [tableViewHeadTitleLabel setText:@"正在加载中……"];
                            }
                                
                            default:
                                break;
                        }
                        if ([_delegate respondsToSelector:@selector(mustReLaodData:)])
                        {
                            [_delegate mustReLaodData:self];
                        }
                    }
                }
            }
                
            default:
                break;
        }
        
        
        
        switch (_showType)
        {
            case ZZTableShowTypeAscend:
            {
                if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height + ZZTABLEREFULSH_Y && scrollView.contentOffset.y > 0)//需要加载
                {
                    if (_lastPage == YES)//已经是最后条了
                    {
                        [tableViewFootLabel setText:ZZTABLEFOOTTITLE_FINISH];
                    }
                    else
                    {
                        [UIView animateWithDuration:0.2 animations:^{
                            UIEdgeInsets inset = scrollView.contentInset;
                            inset.bottom += ZZTABLEREFULSH_Y;
                            [scrollView setContentInset:inset];
                        }];
                        _refreshing = YES;
                        [tableViewHeadTitleLabel setText:ZZTABLEHEADTITLE_CONTINUE];
                        [tableViewFootLabel setText:ZZTABLEHEADTITLE_CONTINUE];
                        if ([_delegate respondsToSelector:@selector(mustContinueLoadData:)])
                        {
                            [_delegate mustContinueLoadData:self];
                        }
                    }
                }
            }
                break;
            case ZZTableShowTypeDescend://倒序
            {
                
            }
                
            default:
                break;
        }
        
    }
    
}

-(void)beginReLoadData
{
    [UIView animateWithDuration:0.2 animations:^{
        UIEdgeInsets inset = _tableView.contentInset;
        inset.top = ZZTABLEREFULSH_Y;
        [_tableView setContentInset:inset];
    }];
    
    _refreshing = YES;
    [tableViewHeadTitleLabel setText:ZZTABLEHEADTITLE_REFLUSHING];
    [tableViewFootLabel setText:ZZTABLEHEADTITLE_REFLUSHING];
    switch (_showType)
    {
        case ZZTableShowTypeAscend:
        {
            //            [tableViewHeadTitleLabel setText:ZZTABLEHEADTITLE_REFLUSHING];
        }
            break;
        case ZZTableShowTypeDescend://倒序
        {
            [tableViewHeadTitleLabel setText:@"正在加载中……"];
        }
            
        default:
            break;
    }
    if ([_delegate respondsToSelector:@selector(mustReLaodData:)])
    {
        [_delegate mustReLaodData:self]; 
    }
    
    
}
@end
