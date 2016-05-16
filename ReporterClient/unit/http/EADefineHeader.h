//
//  EADefineHeader.h
//  ReporterClient
//
//  Created by easaa on 4/18/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#ifndef ReporterClient_EADefineHeader_h
#define ReporterClient_EADefineHeader_h


#endif
#pragma mark 服务器地址

//#define BASEURL             @"http:api.pahn.cn?"   //服务器的url
//#define   BASEURL               @"http://113.105.159.115:5021?"  //测试api
#define BASEURL               @"http://114.215.137.27:5001?"

#define TABLEVIEWREFRESH_ZZ @"tableViewReFresh_ZZ" //一个界面多个tableView时，区别刷新类的加入字典键名


#define METHOD              @"Method"               //接口加密私钥字符串
#define IMG                 @"img"                  //上传的图片名
//#define METHODKEY           @"Fazh#)@6"             //method与3des加密的key

#define METHODKEY           @"WB#)@F01"
#define PARAMS              @"Params"               //参数加密的串
#define SIGN                @"Sign"                 //用appSecret与所有参数进行签名的结果

#define ISNOIMAGE           @"isNoImage"            //是否为全屏模式
#define USERNAME            @"username"             //用户名
#define PASSWORD            @"password"             //密码
#define DATA                @"data"                 //返回的数组字段
#define TOTAL               @"total"                 //返回数据条数


#define SEARCHKEY           @"searchkey"            //搜索关键字
#define HISTORYSEARCH       @"historySearch"        //历史搜索记录

//登录接口
#define SET_MEMBER_LOGIN    @"set.member.login"     //1用户登录
#define USER_NAME           @"user_Name"            //登录用户名
#define PASSWORD_ZZ         @"passWord"             //登录密码
#define USERTYPE            @"usertype"             //登录类型
#define USER_INFO_DICTIONARY @"user_Info_Dictionary" //用户登录成功后保存的信息
#define STATE               @"state"                 //状态0失败 1成功  //我的稿件状态
                                                    //未上传=1,已上传=2,已审核=3,已发布=4 若是0则查询所有

#define MSG                 @"msg"                   //信息
#define USERMOBILE          @"usermobile"            //用户手机
#define REALNAME            @"realname"              //真实姓名
#define USERID              @"userid"                //用户ID
#define PORTRAIT            @"portrait"              //用户头像

//新闻编写

// 接口名称：set.Manuscript.add

#define  SET_MANUSCRIPT_ADD @"set.Manuscript.add"   //编写新闻
#define  SET_MANUSCRIPT_UPDATE @"set.Manuscript.add" //上传新闻

#define  NEWSTITLE          @"Title"                //新闻标题
#define  NEWSCONTENTS       @"contents"             //新闻内容
#define  LINKNEWSID         @"clueId"               //关联线索编号      int
#define  REPORTERID         @"uid"                  //记者编号         int

#define  SOURCETIME         @"SourceTime"           //线索时间



//上传图片、视频

#define IMAGES              @"images"               //新添加图片(多图请用“,”分割)
#define VIDEOS              @"videos"               //新添加视频(多图请用“,”分割)
#define AUDIOS              @"audios"               //新添加语音(多图请用“,”分割)
#define PICTURENAME         @"picturename"          //上传的图片名
#define VIDEONAME           @"videoname"            //上传的视频名
#define URL                 @"url"                  //视频入库路径（上传成功返回路径）
#define MANUSCRIPTID        @"manuscriptid"         //所属稿件编号

#define SOURCEID            @"sourceid"              //报料id	int

//#defie  MANUSCRIPTID        @"manuscriptid"         //稿件id
#define UPDATE_MEMBER_MODIFYPWD @"update.member.modifypwd"  //  update.member.modifypwd 修改密码
#define GET_MEMBER_REPWD        @"get.member.repwd"         //  get.member.repwd 找回密码
#define GET_SEARCHSOURCE_LIST   @"get.searchsource.list"    //  get.searchsource.list 搜索（关联）线索列表
#define GET_RELEVANCYSOURCE_LIST @"get.relevancysource.list" //get.relevancysource.list 关联线索列表
#define GET_SOURCE_DETAIL       @"get.source.detial"        //  get.source.detial  报料详情
#define GET_SOURCE_REPLY        @"get.source.reply"         //  get.source.reply 报料评论列表
#define SET_SOURCE_REPLY        @"set.source.reply"         //  set.source.reply  报料评论
#define GET_SOURCE_FELLOWS      @"get.source.fellows"       //  get.source.fellows  报料追踪报道列表
#define SET_SOURCE_FELLOWS      @"set.source.fellows"       //  set.source.fellows  报料追踪报道
#define UPDATE_SOURCE_SETSTATE  @"update.source.setstate"   //  update.source.setstate 抢占采用线索
#define SET_ACCESSORYPIC_ADD    @"set.picture.add"          //  set.accessorypic.add 上传图片
#define SET_ACCESSORYVIDEO_ADD  @"set.video.add"            //  set.accessoryvideo.add 上传视频
#define SET_ACCESSORYAUDIO_ADD  @"set.audio.add"            //  set.accessoryaudio.add 上传音频
#define GET_MAYMANUSCRIPT_LIST  @"get.maymanuscript.list"   //  get.maymanuscript.list  我的稿件
#define GET_MANUSCRIPT_DETAIL   @"get.manuscript.detial"    //  get.manuscript.detial  稿件详情
#define GET_ACCESSORY_LIST      @"get.accessory.list"       //  get.accessory.list 获取稿件附件列表
#define SET_PORTRAIT_UPDATE     @"set.portrait.update"      //  set.portrait.update  	修改头像
#define GET_MYSOURCE_LIST       @"get.mysource.list"        //  get.mysource.list    我的线索
#define SET_SOURCE_SETSTATE     @"set.source.setstate"      //  set.source.setstate  抢占采用线索
#define GET_MOBILE_VERSION      @"get.mobile.version"       //  get.mobile.version    检测版本
#define GET_ABOUT_DETAIL        @"get.about.detial"         //  get.about.detial   关于

#define GET_RELEVANCYMANUSCRIPT_LIST  @"get.relevancymanuscript.list" //get.relevancymanuscript.list 关联稿件列表

//关联线索
#define  PAGESIZE             @"pageSize"             //每页记录数（分页调用订单数据）
#define  PAGEINDEX            @"pageIndex"            //当前页码（分页调用订单数据），此参数不传默认为1。
#define TITLE                 @"title"                    //线索标题
#define SOURCEID              @"sourceid"                 //线索ID
#define ADDTIME               @"addtime"                  //添加日期
#define CONDITION             @"condition"                //状态(0未采用，1抢占，2采用)

#define ISREPLY             @"isreply"               //是否回复	Int（0未回复 1以回复）
#define ISFOLLOW            @"isfollow"              //是否已根进	Int（0未跟进 1已根进）
#define PHONE               @"phone"                 //报料人电话	string

#define COMMENT             @"comment"                  //评论

#define USERNAME            @"username"              //报料人姓名
#define NOETS               @"notes"                 //内容
#define IMAGE               @"image"                 //图片	string
#define VIDEO               @"video"                 //	视频	string
#define CONDITIONUSER       @"conditionuser"        //抢占、采用的记者编号	int
#define CLUEATATE           @"cluestate"            //原始的 = 1,已跟进 = 2,     已解答 = 3

#define VERIFICATION        @"verification"         //查证；核实
#define ERROR               @"error"                //错误信息