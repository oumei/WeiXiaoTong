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
#define GET_CHANPIN                   @"getChanPin"              /**查询自己的产品*/
#define GET_CHANPIN_BY_ID             @"getChanPinById"          /**根据ID查询产品*/
#define GET_CHANPIN_BY_DANGKOU        @"getChanPinByDangkou"     /**查询档口产品*/
#define DOWNLOAD                      @"download"                /**下载产品*/
#define USER_LOGIN                    @"userLogin"               /**用户登录*/
#define USER_REGISTER                 @"userRegister"            /**用户注册*/
#define FIND_SOURCE_USERS             @"findSourceUsers"         /**查询合作商用户*/

#define ALLOW_FRIEND                  @"allowFriend"             /**同意好友*/
#define DECLINE_FRIEND                @"declineFriend"           /**拒绝好友*/
#define ADD_FRIEND                    @"addFriend"               /**添加好友*/
#define GET_FRIENDS                   @"getFriends"              /**获取好友列表*/
#define DELETE_FRIENDS                @"deleteFriends"           /**删除好友*/
#define GET_APPLY_FRIENDS             @"getApplyFriends"         /**获取好友申请列表*/

#define GET_SELF_CHANPIN              @"getSelfChanPin"          /**查询自己的产品*/
#define UPDATE_SELF_CHANPIN_PRICE     @"updateSelfChanpinPrice"  /**修改自己产品价格*/
#define CHANGE_TABLE                  @"changeTable"             /**切换商家*/
#define COLLECT_CHANPIN               @"CollectChanPin"          /**收藏产品*/

#define DELETE_CHANPIN                @"DeleteChanPin"           /**删除产品*/
#define UPDATE_SELF_CHANPIN_PRICE     @"updateSelfChanpinPrice"  /**修改自己产品价格*/
#define UPLOAD_CHANPIN                @"uploadChanPin"           /**上传产品*/


//url
#define DEFAULT_URL                   @"http://115.28.17.18:8080/service/interface.do"
#define IMAGE_URL(ID) [NSString stringWithFormat:@"http://115.28.17.18:8080/data/%d/small.jpg",ID]
#define IMAGE_URL_BY_CPID(CPID,W,H,PICS) [NSString stringWithFormat:@"http://115.28.17.18:8080/service/showPic.do?cpid=%d&lunbo=1&setW=%.0f&setH=%.0f&index=%d",CPID,W,H,PICS]
#define IMAGE_URL_BY_TN(ID,W,H,PICS) [NSString stringWithFormat:@"http://115.28.17.18:8080/service/showPic.do?cpid=%d&lunbo=1&setW=%.0f&setH=%.0f&index=%d",ID,W,H,PICS]
#define IMAGE_URL_BY_TN_ID(TN,ID,W,H,PICS) [NSString stringWithFormat:@"http://115.28.17.18:8080/service/showPic.do?cpid=%d-%d&lunbo=1&setW=%.0f&setH=%.0f&index=%d",TN,ID,W,H,PICS]
#define UPLOAD_IMAGES(CPID,NUM) [NSString stringWithFormat:@"http://192.168.1.107:8080/service/upload.do?cpid=%@&name=%d.jpg",CPID,NUM]






#endif
