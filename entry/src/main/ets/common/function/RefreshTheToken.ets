// 不好测试, 暂时未加入运行代码中
import { http } from '@kit.NetworkKit'
import { iLoginDataModel, iResponseModel, refreshTheToken } from '../../models/UserData'
import { Logger } from '../utils/Logger'
import { PreferencesManager } from '../utils/Preference'
import { promptAction } from '@kit.ArkUI'

export async function RefreshTheToken(userDataStr: string) {

  // 找到之前的登录的用户数据, 开始执行刷新token流程
  Logger.info("开始刷新Token", userDataStr)
  const userData = JSON.parse(userDataStr) as iLoginDataModel
  const res = await http.createHttp().request(
    "https://api-harmony-teach.itheima.net/hm/refreshToken",
    {
      header: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${userData.refreshToken}`
      },
      method: http.RequestMethod.POST,
      extraData: {
        token: userData.token
      },
      expectDataType: http.HttpDataType.OBJECT
    }
  )

  // 完成token刷新, 开始替换掉过期的token
  Logger.info("完成Token刷新, 开始替换过期的Token", JSON.stringify(res.result))
  const resData = res.result as iResponseModel<refreshTheToken>

  // 刷新appStorage中的用户数据
  const user = AppStorage.get("user") as iLoginDataModel

  user.token = resData.data.token
  user.refreshToken = resData.data.refreshToken

  AppStorage.set("user", user)

  // 刷新持久化的token
  await PreferencesManager.savaData("store", "USERDATA", JSON.stringify(user))

  //完成token刷新, 提示用户再次操作
  Logger.info("完成Token刷新,提示用户再次操作")
  promptAction.showToast({
    message: "用户token过期, 已刷新token"
  })

}