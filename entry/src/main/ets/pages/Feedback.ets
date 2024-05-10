import { router } from '@kit.ArkUI'
import { TopBar } from '../common/components/TopBar';
import { Logger } from '../common/utils/Logger';
import { HdHttp } from '../common/utils/Request'


export interface Datum {
  /**
   * 反馈类型code
   */
  code: string;

  /**
   * 反馈类型信息
   */
  name: string;
}

// 反馈上传的结构
export interface myFeedback {
  /**
   * 反馈记录
   */
  feedbackInfo?: string;

  /**
   * 试题id
   */
  questionId?: string;

  /**
   * 反馈类型,数组，1内容不准确2、知识点不准确3题目重复4其他
   */
  type?: string[];

}

@Entry
@Component
struct Feedback {
  @StorageProp("topHeight") topHeight: number = 0
  @State name: string[] = ["知识点不准确", "内容不准或错误", "题目重复", "其他"]
  @State input: string = ""
  // 控制模态显示框
  @State isShow: boolean = false
  // 提交结果
  @State submitTheResults: boolean = true
  selectTheArray: number[] = []
  questionsId: number = 0

  async aboutToAppear(): Promise<void> {
    try {
      const resData = await HdHttp.get<Datum[]>("question/feedback/type")
      this.name = resData.data.map((val) => val.name)
      this.questionsId = (router.getParams() as object)["id"]
    } catch (e) {
      Logger.info("反馈:", "路由跳转没有携带试题ID")
    }
  }

  async feedback() {
    try {
      const mySelected: string[] = this.selectTheArray.map(val => this.name[val])
      const myFeed: myFeedback = {
        type: mySelected,
        feedbackInfo: this.input
      }
      // questionId: this.questionsId.toString(),
      if (this.questionsId) {
        myFeed.questionId = this.questionsId.toString()
      }
      await HdHttp.post<object>("question/feedback", myFeed)
      Logger.info("反馈:", `${this.questionsId}问题反馈成功`)
      this.submitTheResults = true
    } catch (e) {
      Logger.error("问题反馈:", "问题反馈提交错误")
      this.submitTheResults = false
    }
  }

  build() {
    Column() {
      // title
      TopBar({ barTitle: "意见反馈" })

      Column() {

        Row() {
          Text() {
            Span("*")
              .fontColor("#EA5C2F")
            Span("错误类型（可多选）")
          }
          .width("100%")
          .fontWeight(700)
        }
        .margin({ left: 20, right: 20, top: 15, bottom: 10 })


        Column() {
          ForEach(
            this.name,
            (item: string, index) => {
              Row() {
                Checkbox({ name: index.toString() })
                  .margin({ right: 10 })
                  .onChange((val) => {
                    if (val) {
                      this.selectTheArray.push(index)
                    } else {
                      this.selectTheArray.splice(this.selectTheArray.indexOf(index), 1)
                    }
                  })
                Text(item)
              }.width("100%").height(48)

              if (index != this.name.length - 1) {
                Divider()
                  .strokeWidth(0.5)
                  .color("#F7F7F7")
              }
            }
          )
        }.margin({ left: 20, right: 20 })

        Divider()
          .strokeWidth(8)
          .color("#F6F7F9")

        Column() {
          Text("问题描述（可选填）")
            .width("100%")
            .fontWeight(600)
            .margin({ top: 15, bottom: 10 })
          TextArea({
            placeholder: "请输入问题描述（可选填）"
          })
            .maxLength(200)
            .showCounter(true)
            .padding(10)
            .placeholderColor($r("app.color.common_gray_01"))
            .placeholderFont({ weight: 400, size: 15 })
            .height(160)
            .borderRadius(8)
        }.margin({ left: 20, right: 20, top: 8 })

        Row() {
          Button("提交反馈")
            .type(ButtonType.Normal)
            .borderRadius(5)
            .width("100%")
            .height(45)
        }
        .bindSheet(this.isShow, this.feedbackTheResults, {
          height: 550,
          showClose: false,
        })
        .position({ y: "100%" })
        .translate({ y: "-350%" })
        .margin({ left: 20, right: 20 })
        .onClick(async () => {
          await this.feedback()
          this.isShow = true
        })
      }

    }
    .width("100%")
    .height("100%")
    .padding({ top: this.topHeight })

  }

  @Builder
  feedbackTheResults() {
    Column() {
      Text("提交反馈")
        .height(70)
        .fontSize(18)
        .fontWeight(600)
      Column() {
        Image(this.submitTheResults ? $r("app.media.ic_chenggong") : $r("app.media.ic_cuowu"))
          .width(50)
          .margin({ top: 30, bottom: 15 })
        Text(this.submitTheResults ? "提交成功，感谢您的反馈" : "OAO!_提交失败")
          .fontColor("#3C3E42")
          .fontSize(15)
          .fontWeight(500)
        Text(this.submitTheResults ? "工作人员将在5-7个工作日内解决您的问题" : "请检查您的网络后，重新提交一下吧")
          .fontSize(12)
          .fontColor("#C3C3C5")
          .margin({ top: 8 })
      }.margin({ bottom: 250 })

      Row({ space: 5 }) {
        Text(this.submitTheResults ? (this.questionsId ? "返回题目详情" : "返回我的页面") : "重新提交")
          .fontSize(15)
          .fontColor("#3C3E42")
        Image($r("app.media.icon_right"))
          .width(12)
          .fillColor($r("app.color.tab_selected_color"))
      }.onClick(() => {
        if (this.submitTheResults) {
          router.back()
        } else {
          this.isShow = false
        }
      })
    }
  }
}