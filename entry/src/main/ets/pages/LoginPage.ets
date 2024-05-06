import { promptAction, router } from '@kit.ArkUI'
import { Logger } from '../common/utils/Logger'
import { http } from '@kit.NetworkKit'
import { iLoginDataModel, iResponseModel, userInfo } from '../models/UserData'
import { HdHttp } from '../common/utils/request'


@Entry
@Component
struct LoginPage {
  // 用户名
  @State userAccount: string = "hmheima"
  // 用户密码
  @State userPassword: string = "Hmheima%123"
  // 多选框状态
  @State multiSelectStatus: boolean = false
  // 登陆节流控制 false表示未请求, true表示请求中
  // 控制登录动画
  @State isloading: boolean = false

  async login() {

    // 判断用户名是否输入
    if (this.userAccount === "") {
      promptAction.showToast({
        message: "用户名不能为空, 请输入用户名"
      })
      return
    }

    if (this.userPassword === "") {
      promptAction.showToast({
        message: "密码不能为空, 请输入密码"
      })
      return
    }

    if (!this.multiSelectStatus) {
      promptAction.showToast({
        message: "请同意用户协议和隐私政策"
      })
      return
    }

    if (!this.isloading) {
      // 开启节流阀
      this.isloading = true

      try {
        const resData = await HdHttp.post<iLoginDataModel>("login", {
          username: this.userAccount,
          password: this.userPassword
        } as userInfo)
        //
        // http.createHttp().request(
        //   "https://api-harmony-teach.itheima.net/hm/login",
        //   {
        //     header: { contentType: "application/json" },
        //     method: http.RequestMethod.POST,
        //     extraData: {
        //       username: this.userAccount,
        //       password: this.userPassword
        //     },
        //     expectDataType: http.HttpDataType.OBJECT
        //   }
        // )
        // .then((res) => {
        Logger.info(JSON.stringify(resData.data))
        // const resData = res.result as iResponseModel<iLoginDataModel>

        // 判断业务码是否为10000
        if (resData.code === 10000) {
          AppStorage.setOrCreate("user", resData.data)

          // 跳转到主页
          router.replaceUrl({
            url: "pages/Index"
          })
          promptAction.showToast({
            message: "登录成功"
          })
        } else {
          Logger.info("login", JSON.stringify(resData))
          promptAction.showToast({
            message: `登录失败, ${resData.message}`
          })
        }

        // 关闭节流阀
        this.isloading = false

      } catch (err) {
        promptAction.showToast({
          message: `网络请求失败, 错误信息:${err.message}`
        })

        // 关闭节流阀
        this.isloading = false

      }

      // })
      // .catch((err: Error) => {
      //   promptAction.showToast({
      //     message: `网络请求失败, 错误信息:${err.message}`
      //   })
      //
      //   // 关闭节流阀
      //   this.isloading = false
      // })
    }

  }

  build() {
    Column() {

      // 上部logo部分
      Column() {
        Image($r("app.media.ic_interview_logo"))
          .width(40)
        Text("面试宝典")
          .mytextsytle(24, 600, "#393E4A")
          .margin({ top: 20, bottom: 10 })
        Text("搞定企业面试真题，就用面试宝典")
          .mytextsytle(14, 400, "#6F6F6F")
      }

      // 用户输入框
      Column({ space: 10 }) {
        TextInput({
          placeholder: "  输入用户名",
          text: this.userAccount
        })
          .myinput()
          .maxLength(11)
          .onChange((val) => {
            this.userAccount = val
          })
        TextInput({
          placeholder: "  请输入密码",
          text: this.userPassword
        })
          .myinput()
          .type(InputType.Password)
          .passwordIcon({
            onIconSrc: $r("app.media.eye"),
            offIconSrc: $r("app.media.eyeclose")
          })
          .onChange((val) => {
            this.userPassword = val
          })
      }
      .width("100%")
      .justifyContent(FlexAlign.Center)
      .margin({ top: 45, bottom: 20 })

      // 用户协议和隐私政策
      Row() {
        Checkbox()
          .select($$this.multiSelectStatus)
          .width(18)
          .selectedColor("#FA6D1D")
        Text() {
          Span("已阅读并同意")
          Span(" 用户协议 ")
            .fontColor("#616161")
            .onClick(() => {
              router.pushUrl({
                url: "pages/UserAgreement"
              })
            })
          Span("和")
          Span(" 隐私政策 ")
            .fontColor("#616161")
            .onClick(() => {
              router.pushUrl({
                url: "pages/PrivacyPolicy"
              })
            })
        }
        .mytextsytle(14, 400, "#ffb6b6b6")
      }
      .width("85%")

      Button({ type: ButtonType.Normal }) {
        Row({ space: 5 }) {
          if (this.isloading) {
            LoadingProgress()
              .width(35)
              .color("#eee")
          }
          Text("登录")
            .fontColor("#eee")
            .fontWeight(500)

        }
      }
      .margin(25)
      .height(45)
      .width("85%")
      .linearGradient({
        angle: 135,
        colors: [["#FCA21C", 0], ["#FA6D1D", 1]]
      })
      .borderRadius(5)
      .onClick(() => {
        // 登录逻辑
        this.login()
      })
    }
    .padding({ top: 120 })
  }
}

@Extend(Text)
function mytextsytle(size: number, wei: number, color: string) {
  .fontSize(size)
  .fontWeight(wei)
  .fontColor(color)
}

@Extend(TextInput)
function myinput() {
  .height(50)
  .width("85%")
  .padding(0)
  .backgroundColor("#00000000")
  .border({
    width: { bottom: .5 },
    color: "#ccc",
    radius: 0
  })
  .placeholderColor("#ccc")
  .placeholderFont({
    size: 14
  })
}
