import { HdTag } from '../common/components/HdTag'
import { HdHttp } from '../common/utils/request'
import { promptAction, router } from '@kit.ArkUI'
import { Logger } from '../common/utils/Logger'
import { IvSkeleton } from '../common/components/IvSkeleton'
import { trackingService } from '../common/utils/TrackingService'

export interface QuestionDetail {
  id: string
  stem: string
  difficulty: number
  likeCount: number
  views: number
  readFlag: 0 | 1
  answer: string
  collectFlag: 0 | 1
  likeFlag: 0 | 1
  stage: Array<string>
}

//接收参数的实体
export interface ParamsType {
  id: number
}

// 点赞的数据结构
export interface iBodyParms {
  id: string,
  type: number,
  optType: string
}

@Entry
@Component
export struct QuestionDetailPage {
  @State @Watch("getQuestions")
  questionId: number = 0
  @State
  question: QuestionDetail = {} as QuestionDetail
  @StorageProp('topHeight') topHeight: number = 0
  @StorageProp("ListOfQuestionsId") ListOfQuestionsId: number[] = []
  // 节流阀 false 关 true 开
  isloading: boolean = false

  aboutToAppear(): void {
    trackingService.setStartTime()

    try {
      this.questionId = (router.getParams() as ParamsType).id
      // this.getQuestions()
    } catch (err) {
      Logger.error("题目详情页:", "路由出现错误")
    }
  }

  async aboutToDisappear(): Promise<void> {
    trackingService.setEndTime()
    trackingService.setQuestionId(this.questionId.toString())
    trackingService.save()
  }

  async getQuestions() {

    const res = await HdHttp.get<QuestionDetail>(`question/${this.questionId}`)
    this.question = res.data
    // 关闭节流阀, 表示数据请求完成
    this.isloading = false
  }

  toggleTopics(isNext: boolean) {
    let listIndex = this.ListOfQuestionsId.findIndex(val => this.questionId === val)

    // 判断题目的id是否在保存的列表中
    if (listIndex < 0) {
      promptAction.showToast({
        message: "所查询的题目不在列表中"
      })
    } else {
      // 判断是上一题还是下一题
      if (isNext) {
        // 判断下一题是否小于0
        if (listIndex <= 0) {
          promptAction.showToast({
            message: "当前已经是第一题了~"
          })
        } else {
          if (!this.isloading) {
            this.isloading = true
            // 清空题目内容, 显示骨架屏提示用户数据请求中
            this.question = {} as QuestionDetail
            listIndex--
            this.questionId = this.ListOfQuestionsId[listIndex]
          }
        }
      } else {
        // 判断上一题是否超过了列表长度
        if (listIndex >= this.ListOfQuestionsId.length - 1) {
          promptAction.showToast({
            message: "已经是最后一题了~"
          })
        } else {
          if (!this.isloading) {
            this.isloading = true
            // 清空题目内容, 显示骨架屏提示用户数据请求中
            this.question = {} as QuestionDetail
            listIndex++
            this.questionId = this.ListOfQuestionsId[listIndex]
          }
        }
      }
    }

  }

  // 点赞收藏
  async opt(isOn: boolean, optType: string) {
    if (isOn) {
      await HdHttp.post<object>("question/opt", {
        id: this.questionId.toString(),
        type: 0,
        optType: optType
      } as iBodyParms)
      promptAction.showToast({
        message: `${optType === "1" ? "点赞" : "收藏"}成功`
      })
    } else {
      await HdHttp.post<object>("question/unOpt", {
        id: this.questionId.toString(),
        type: 0,
        optType: optType
      } as iBodyParms)
      promptAction.showToast({
        message: `取消${optType === "1" ? "点赞" : "收藏"}`
      })
    }

    this.getQuestions()
  }

  // 题目所属标签
  @Builder
  tagBuilder(text: string, color: string = '#41B883') {
    Text(text)
      .fontColor(color)
      .fontSize($r('app.float.common_font10'))
      .padding({ left: $r('app.float.common_space4'), right: $r('app.float.common_space4') })
      .constraintSize({ minWidth: $r('app.float.hd_tag_width') })
      .height($r('app.float.hd_tag_height'))
      .backgroundColor($r('app.color.common_gray_bg'))
      .borderRadius($r('app.float.hd_tag_radius'))
      .textAlign(TextAlign.Center)
  }

  // 上一题，下一题
  @Builder
  toggleBuilder() {
    Row() {
      Image($r("app.media.prev_black")).width((80)).onClick(() => {
        // 上一题业务逻辑
        this.toggleTopics(true)

      })
      Image($r("app.media.next_black")).width((80)).onClick(() => {
        // 下一题业务逻辑
        this.toggleTopics(false)
      })
    }.width('100%').justifyContent(FlexAlign.SpaceAround)
  }

  build() {
    Navigation() {
      Flex({ direction: FlexDirection.Column }) {
        Column() {
          Column() {
            Row() {
              if (Object.keys(this.question).length) {
                Text(this.question.stem).width('100%').fontWeight(600)
              } else {
                // 如果没有数据,就显示骨架屏
                IvSkeleton({ widthValue: 220 }).width("100%")
              }
            }

            Row() {
              if (Object.keys(this.question).length) {
                Row({ space: 8 }) {
                  HdTag({ difficulty: this.question.difficulty })
                  ForEach(this.question.stage, (stage: string) => {
                    this.tagBuilder(stage)
                  })
                }

                Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.End }) {
                  Image($r('app.media.icon_point')).width(24).bindMenu([
                    {
                      value: this.question.collectFlag === 1 ? '取消收藏' : '收藏',
                      action: async () => {
                        // 点赞和取消点赞业务逻辑代码
                        // this.opt(1,0)
                        this.opt(this.question.collectFlag !== 1, "2")
                      }
                    },
                    {
                      value: this.question.likeFlag === 1 ? '取消点赞' : '点赞',
                      action: async () => {
                        // 点赞和取消点赞业务逻辑代码
                        // this.opt(1,0)
                        this.opt(this.question.likeFlag !== 1, "1")
                      }
                    }
                  ])
                }
                .layoutWeight(1)
              } else {
                Row({ space: 8 }) {
                  IvSkeleton({ widthValue: 30 })
                  IvSkeleton({ widthValue: 30 })
                  Blank()
                  IvSkeleton({ widthValue: 30 })
                }.width("100%")
              }
            }
            .height((40))
            .width('100%')
            .padding({ top: (15) })
          }.padding((15))
        }

        Divider()
          .strokeWidth((8))
          .color($r('app.color.ih_bg_color'))

        Column() {
          if (Object.keys(this.question).length) {
            Scroll() {

              RichText(`
                      <html>
                        <body>
                          <div style="font-size:54px">${this.question.answer}</div>
                        <body>
                      </html>
                      `)
            }
            .padding((15))
            .layoutWeight(1)
            .onScroll((xOffset: number, yOffset: number) => {
              console.log('mylog->xOffset', xOffset + ' ' + yOffset)
            })
            .onScrollStop(() => {
              console.log('mylog->Scroll Stop')
            })
          } else {
            Column() {
              LoadingProgress()
                .width(100)
              Text("Loading")
                .fontSize(30)
                .fontWeight(500)
            }.height("100%").width("100%").justifyContent(FlexAlign.Center)
          }
        }.layoutWeight(1)

      }
    }
    .padding({ top: this.topHeight })
    .title('题目详情')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .toolbarConfiguration(this.toggleBuilder())
  }
}