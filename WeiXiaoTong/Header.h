//
//  Header.h
//  WeiXiaoTong
//
//  Created by 李世明 on 14-2-26.
//  Copyright (c) 2014年 WXT. All rights reserved.
//

#ifndef WeiXiaoTong_Header_h
#define WeiXiaoTong_Header_h

//接口参数
#define CONFIG                        @"config"
#define GET_CHANPIN                   @"getChanPin"
#define GET_CHANPIN_BY_ID             @"getChanPinById"
#define GET_CHANPIN_BY_DANGKOU        @"getChanPinByDangkou"
#define DOWNLOAD                      @"download"
#define USER_LOGIN                    @"userLogin"
#define USER_REGISTER                 @"userRegister"
#define FIND_SOURCE_USERS             @"findSourceUsers"

#define ALLOW_FRIEND                  @"allowFriend"
#define DECLINE_FRIEND                @"declineFriend"
#define ADD_FRIEND                    @"addFriend"
#define GET_FRIENDS                   @"getFriends"
#define DELETE_FRIENDS                @"deleteFriends"
#define GET_APPLY_FRIENDS             @"getApplyFriends"

//url
#define DEFAULT_URL                   @"http://115.28.17.18:8080/service/interface.do"
#define IMAGE_URL(ID) [NSString stringWithFormat:@"http://115.28.17.18:8080/data/%d/small.jpg",ID]
#define IMAGE_URL_BY_CPID(CPID,W,H,PICS) [NSString stringWithFormat:@"http://115.28.17.18:8080/service/showPic.do?cpid=%d&lunbo=1&setW=%.0f&setH=%.0f&index=%d",CPID,W,H,PICS]
#define IMAGE_URL_BY_TN(ID,W,H,PICS) [NSString stringWithFormat:@"http://115.28.17.18:8080/service/showPic.do?cpid=%d&lunbo=1&setW=%.0f&setH=%.0f&index=%d",ID,W,H,PICS]
#define IMAGE_URL_BY_TN_ID(TN,ID,W,H,PICS) [NSString stringWithFormat:@"http://115.28.17.18:8080/service/showPic.do?cpid=%d-%d&lunbo=1&setW=%.0f&setH=%.0f&index=%d",TN,ID,W,H,PICS]

//public final static String CONFIG = "config";
///**查询产品*/
//public final static String GET_CHANPIN = "getChanPin";
///**查询自己的产品*/
//public final static String GET_SELF_CHANPIN = "getSelfChanPin";
///**修改自己产品价格*/
//public final static String UPDATE_SELF_CHANPIN_PRICE = "updateSelfChanpinPrice";
///**根据ID查询产品*/
//public final static String GET_CHANPIN_BY_ID = "getChanPinById";
///**查询档口产品*/
//public final static String GET_CHANPIN_BY_DANGKOU = "getChanPinByDangkou";
///**下载产品*/
//public final static String DOWNLOAD = "download";
//
//public final static String USER_LOGIN = "userLogin";
//
//public final static String CHANGE_TABLE="changeTable";
//
//public final static String USER_REGISTER = "userRegister";
///**查询合作商用户*/
//public final static String FIND_SOURCE_USERS="findSourceUsers";
//
////	--------------------------好友模块--------------------------------
///**收藏产品*/
//public final static String COLLECT_CHANPIN="CollectChanPin";
///**同意好友*/
//public final static String ALLOW_FRIEND="allowFriend";
///**拒绝好友*/
//public final static String DECLINE_FRIEND="declineFriend";
///**添加好友*/
//public final static String ADD_FRIEND="addFriend";
///**获取好友列表*/
//public final static String GET_FRIENDS="getFriends";
///**删除好友*/
//public final static String DELETE_FRIENDS="deleteFriends";
///**获取好友申请列表*/
//public final static String GET_APPLY_FRIENDS="getApplyFriends";



#endif
