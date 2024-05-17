import { TopBar } from '../common/components/TopBar';
import { http } from '@kit.NetworkKit';
import { iLoginDataModel } from '../models/UserData';
import { router } from '@kit.ArkUI';

interface conversationStructure {
  substance: string
  sender: boolean
}


@Entry
@Component
struct AiInterview {
  @StorageProp("topHeight") topHeight: number = 0
  @StorageProp("user") user: iLoginDataModel = {} as iLoginDataModel
  @State isShow: boolean = true
  ScrollController: Scroller = new Scroller()
  @State aListOfConversations: conversationStructure[] = [{
    substance: "请问什么是响应式设计,它的作用是什么",
    sender: false
  },]
  @State userInput: string = ""

  async sendAMessage() {

    if (this.userInput.trim() === "") {
      return
    }

    const msg = encodeURIComponent(this.userInput)

    this.aListOfConversations.push({
      substance: this.userInput,
      sender: true
    } as conversationStructure,
    )

    setTimeout(() => {
      this.aListOfConversations.push({
        substance: "加载中...",
        sender: false
      } as conversationStructure,
      )
      this.goToTheBottom()
    }, 600)

    this.userInput = ""
    this.goToTheBottom()

    const res = await http.createHttp().request(
      `https://hmajax.itheima.net/api/robot?spoken=${msg}`,
      { expectDataType: http.HttpDataType.OBJECT }
    )

    console.log(JSON.stringify(res.result))
    animateTo({
      duration: 350,
      curve: Curve.Friction
    }, () => {
      this.aListOfConversations.splice(this.aListOfConversations.length - 1, 1,
        {
          substance: res?.result["data"]["info"]["text"] || "",
          sender: false
        } as conversationStructure
      )
    })
    this.goToTheBottom()

  }

  goToTheBottom() {
    animateTo({
      duration: 300,
      curve: Curve.Ease
    }, () => {
      this.ScrollController.scrollEdge(Edge.Bottom)
    })
  }

  build() {
    Column() {
      Column() {
        TopBar({ barTitle: "AI面试" })

        if (!this.isShow) {
          Stack() {
            Column() {

              List({ space: 18, scroller: this.ScrollController }) {
                ForEach(
                  this.aListOfConversations,
                  (item: conversationStructure) => {
                    ListItem() {
                      this.conversationLine(item)
                    }
                  }
                )
              }.scrollBar(BarState.Off)
            }
            .width("100%")
            .height("100%")
            .padding({ left: 10, right: 10, top: 10, bottom: 100 })


            Stack() {
              TextInput({
                placeholder: "请输入你的答案",
                text: $$this.userInput
              })
                .height(44)
                .backgroundColor("#fff")
                .borderRadius(7)
                .shadow({
                  radius: 5,
                  offsetX: 1,
                  offsetY: 1,
                  color: "#ddd"
                })
                .onSubmit(async () => {
                  this.sendAMessage()
                })
              Row() {
                Image($r("app.media.fasong"))
                  .width(22)
              }
              .height(44)
              .aspectRatio(1)
              .justifyContent(FlexAlign.Center)
              .onClick(() => {
                this.sendAMessage()
              })
            }
            .padding(15)
            .alignContent(Alignment.End)
            .margin({ bottom: 20 })

          }
          .layoutWeight(1)
          .alignContent(Alignment.Bottom)
        } else {
          Column() {
            Text("正在准备面试环境，请稍等…").margin({ top: 160 }).fontColor($r("app.color.common_gray_01"))
          }.layoutWeight(1)
        }
      }
      .width("100%")
      .height("100%")
      .backgroundColor("#F6F7F9")
      .padding({ top: this.topHeight + 5 })


      if (this.isShow) {
        Column() {
          Column() {
            Image($r("app.media.Slice"))
              .width("80%")
            Text("接下来，请开始面试")
              .height(80)
              .width("80%")
              .textAlign(TextAlign.Center)
              .fontSize(28)
              .fontWeight(500)
              .backgroundColor("#000000")
              .fontColor(Color.White)
              .borderRadius({ bottomLeft: 12, bottomRight: 12 })
              .onClick(() => {
                animateTo({
                  duration: 500,
                  curve: Curve.Ease
                }, () => {
                  this.isShow = false
                })
              })

            Row({ space: 10 }) {
              Image($r("app.media.icon_left"))
                .width(16)
                .fillColor(Color.White)
              Text("再想想，返回首页")
                .fontSize(18)
                .fontColor(Color.White)
            }
            .margin({ top: 30 })
            .onClick(() => {
              router.back()
            })
          }
        }
        .width("100%")
        .height("100%")
        .backgroundColor("#82000000")
        .justifyContent(FlexAlign.Center)
        .position({})
      }
    }
  }

  @Builder
  conversationLine(item: conversationStructure) {
    Row({ space: 10 }) {
      Image(item.sender ? this.user.avatar : $r("app.media.ic_interview_avatar"))
        .width(38)
        .aspectRatio(1)
        .borderRadius(99);
      Row() {
        Text(item.substance)
          .fontSize(15)
      }
      .constraintSize({
        minHeight: 42,
        minWidth: 80,
        maxWidth: "75%"
      })
      .backgroundColor("#E5E7EB")
      .borderRadius({
        topLeft: item.sender ? 10 : 0,
        topRight: item.sender ? 0 : 10,
        bottomLeft: 10,
        bottomRight: 10
      })
      .padding({ left: 12, right: 12, top: 8, bottom: 8 })
      .direction(item.sender ? Direction.Rtl : Direction.Ltr)

    }
    .width("100%")
    .alignItems(VerticalAlign.Top)
    .direction(item.sender ? Direction.Rtl : Direction.Ltr)
  }
}