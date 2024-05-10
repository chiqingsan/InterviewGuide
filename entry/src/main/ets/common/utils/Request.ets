// 项目请求的基地址
import { http } from '@kit.NetworkKit'
import { iResponseModel, iLoginDataModel, refreshTheToken } from '../../models/UserData'
import { promptAction, router } from '@kit.ArkUI'
import { Logger } from './Logger'
import { BasicConstant } from '../constants/BasicConstant'
import { preferences } from '@kit.ArkData'
import { PreferencesManager } from './Preference'

const baseUrl: string = "https://api-harmony-teach.itheima.net/hm/"

export class HdHttp {
  // 封装 get 请求方法
  static async get<T>(url: string, query?: object, isJSON: boolean = false) {

    try {
      // 创建请求对象
      const httpRequest = http.createHttp()

      const user = AppStorage.get<iLoginDataModel>("user")
      const token = user?.token
      Logger.info("token", user?.token as string)

      const res = await httpRequest.request(
        baseUrl + url,
        {
          header: {
            "Content-Type": isJSON ? "application/json" : "",
            'Authorization': `Bearer ${token}`
          },
          extraData: query,
          expectDataType: http.HttpDataType.OBJECT
        }
      )

      const resData = res.result as iResponseModel<T>
      Logger.info("resData:", JSON.stringify(resData))
      // 如果业务码为401, 则提示登录过期, 跳转回登录页
      if (resData.code === 401) {

        const userDataStr = await PreferencesManager.getData<string>("store", "USERDATA", "")
        if (userDataStr) {

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


        } else {
          promptAction.showToast({ message: '登录超时，请重新登录' })
          router.pushUrl({ url: BasicConstant.PAGE_LoginPage })

        }

      }

      return resData

    } catch (err) {
      promptAction.showToast({
        message: "Get请求出错误"
      })
      Logger.error("Get", JSON.stringify(err))

      return Promise.reject(err)
    }

  }

  // 封装 post 请求方法
  static async post<T>(url: string, query: object) {

    try {
      // 创建请求对象
      const httpRequest = http.createHttp()


      const options: http.HttpRequestOptions = {
        method: http.RequestMethod.POST,
        header: {
          "Content-Type": "application/json"
        },
        extraData: query,
        expectDataType: http.HttpDataType.OBJECT
      }


      const user = AppStorage.get<iLoginDataModel>("user")
      const token = user?.token
      Logger.info("token_Post", user?.token as string)

      // 判断有无token,有则添加头部的token信息
      if (token && options.header) {
        options.header["Authorization"] = `Bearer ${token}`
      }

      const res = await httpRequest.request(baseUrl + url, options)

      const resData = res.result as iResponseModel<T>
      Logger.info("resDate_Post:", JSON.stringify(resData))
      // 如果业务码为401, 则提示登录过期, 跳转回登录页
      if (resData.code === 401) {
        promptAction.showToast({ message: '登录超时，请重新登录' })
        router.pushUrl({ url: BasicConstant.PAGE_LoginPage })
      }

      return resData


    } catch (err) {
      promptAction.showToast({
        message: "Post请求出错误"
      })
      Logger.error("Post", JSON.stringify(err))

      return Promise.reject(err)
    }
  }
}