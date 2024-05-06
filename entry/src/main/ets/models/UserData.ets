
// 所有接口返回数据的类型
export interface iResponseModel<T> {
  /**
   * 请求成功10000标志
   */
  code: number;
  /**
   * 返回数据
   */
  data: T;
  /**
   * 请求成功
   */
  message: string;
  /**
   * 请求成功标志
   */
  success: boolean;
}

/**
 * 登录成功之后的 返回数据
 */
export interface iLoginDataModel {
  /**
   * 用户头像地址
   */
  avatar?: string;
  /**
   * 连续打卡天数
   */
  clockinNumbers: number;
  /**
   * 用户id
   */
  id: string;
  /**
   * 昵称
   */
  nickName: string;
  /**
   * token过期后，刷新token使用
   */
  refreshToken: string;
  /**
   * 分享加密串
   */
  shareInfo: string;
  /**
   * 后续交互使用的token
   */
  token: string;
  /**
   * 学习时长，单位s
   */
  totalTime: number;
  /**
   * 昵称
   */
  username?: string;
}

/*
 * 用户名和密码提交的数据结构
 * */
export interface userInfo{
  username:string
  password:string
}