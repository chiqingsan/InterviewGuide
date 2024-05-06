// 项目请求的基地址
import { http } from '@kit.NetworkKit'
import { iResponseModel, iLoginDataModel } from '../../models/UserData'
import { promptAction, router } from '@kit.ArkUI'
import { Logger } from './Logger'

const baseUrl: string = "https://api-harmony-teach.itheima.net/hm/"

export class HdHttp {
  // 封装 get 请求方法
  static async get<T>(url: string, query?: string | object, isJSON: boolean = false) {

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
        promptAction.showToast({ message: '登录超时，请重新登录' })
        router.pushUrl({ url: 'pages/LoginPage' })
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
  static async post<T>(url: string, query: string | object) {

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
      Logger.info("token", user?.token as string)

      // 判断有无token,有则添加头部的token信息
      if (token && options.header) {
        options.header["token"] = `Bearer ${token}`
      }

      const res = await httpRequest.request(baseUrl + url, options)

      const resData = res.result as iResponseModel<T>
      // 如果业务码为401, 则提示登录过期, 跳转回登录页
      if (resData.code === 401) {
        promptAction.showToast({ message: '登录超时，请重新登录' })
        router.pushUrl({ url: 'pages/LoginPage' })
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