@Entry
@Component
struct LoginPage {
  @State userAccount: string = ""
  @State userPassword: string = ""

  build() {
    Column() {

      // 上部logo部分
      Column() {
        Image($r("app.media.ic_interview_logo"))
          .width(30)
        Text("面试宝典")
          .mytextsytle(24, 600, "#393E4A")
          .margin({ top: 20, bottom: 10 })
        Text("搞定企业面试真题，就用面试宝典")
          .mytextsytle(14, 400, "#929292")
      }

      // 用户输入框
      Column({ space: 10 }) {
        TextInput({
          placeholder: "  输入用户名"
        })
          .myinput()
          .onChange((val) => {
            this.userAccount = val
          })
        TextInput({
          placeholder: "  请输入密码"
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
      .margin({ top: 40, bottom: 30 })

      // 用户协议和隐私政策
      Row() {
        Checkbox()
          .width(18)
          .selectedColor("#FA6D1D")
        Text() {
          Span("已阅读并同意")
          Span(" 用户协议 ")
            .fontColor("#616161")
          Span("和")
          Span(" 隐私政策 ")
            .fontColor("#616161")

        }
        .mytextsytle(14, 400, "#BFBFBF")
      }
      .width("85%")

      Button({ type: ButtonType.Normal }) {
        Row({ space: 5 }) {
          LoadingProgress()
            .width(35)
            .color("#eee")
          Text("登录")
            .fontColor("#eee")
            .fontWeight(500)
        }
      }
      .margin(20)
      .height(45)
      .width("85%")
      .linearGradient({
        direction: GradientDirection.Right,
        colors: [["#FC9E1C", 0], ["#FA711D", 1]]
      })
      .borderRadius(5)
    }
    .padding({ top: 150 })
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
