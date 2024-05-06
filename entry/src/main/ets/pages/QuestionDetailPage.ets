import { HdTag } from '../common/components/HdTag'
import { HdHttp } from '../common/utils/request'
import { router } from '@kit.ArkUI'

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

@Entry
@Component
export struct QuestionDetailPage {
  @State
  questionId: number = 0
  @State
  question: QuestionDetail = {
    id: '1',
    stem: 'Vue生命周期',
    difficulty: 4,
    likeCount: 100,
    views: 122,
    readFlag: 1,
    answer: `<strong>Vue生命周期分为四个阶段，10个周期函数</strong>`,
    collectFlag: 1,
    likeFlag: 1,
    stage: ['Vue', '前端']
  } as QuestionDetail
  @StorageProp('topHeight') topHeight: number = 0

  aboutToAppear(): void {
    this.questionId = (router.getParams() as ParamsType).id
    this.getQuestions()
  }

  async getQuestions() {
    const res = await HdHttp.get<QuestionDetail>(`question/${this.questionId}`)
    this.question = res.data
  }

  // 题目所属标签
  @Builder
  tagBuilder(text: string, color: string = '#41B883') {
    Text(text)
      .fontSize(12)
      .padding(5)
      .backgroundColor($r('app.color.ih_bg_color'))
      .borderRadius(2)
      .fontColor(color)
      .margin({ right: 5 })
  }

  // 上一题，下一题
  @Builder
  toggleBuilder() {
    Row() {
      Image($r("app.media.prev_black")).width((80)).onClick(() => {
        // 上一题业务逻辑
      })
      Image($r("app.media.next_black")).width((80)).onClick(() => {
        // 下一题业务逻辑
      })
    }.width('100%').justifyContent(FlexAlign.SpaceAround)
  }

  build() {
    Navigation() {
      Flex({ direction: FlexDirection.Column }) {
        Column() {
          Column() {
            Row() {
              Text(this.question.stem).width('100%')
            }

            Row() {
              if (this.question.id) {
                HdTag({ difficulty: this.question.difficulty })
                ForEach(this.question.stage, (stage: string) => {
                  this.tagBuilder(stage)
                })
                Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.End }) {
                  Image($r('app.media.icon_point')).width(24).bindMenu([
                    {
                      value: this.question.collectFlag === 1 ? '取消收藏' : '收藏',
                      action: () => {
                        // 收藏和取消收藏业务逻辑代码
                        // this.opt(1,0)
                      }
                    },
                    {
                      value: this.question.likeFlag === 1 ? '取消点赞' : '点赞',
                      action: () => {
                        // 点赞和取消点赞业务逻辑代码
                        // this.opt(1,0)
                      }
                    }
                  ])
                }
                .layoutWeight(1)
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
          Scroll() {
            // RichText(this.question.answer)
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