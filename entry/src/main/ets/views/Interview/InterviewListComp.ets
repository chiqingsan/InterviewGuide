import { Logger } from '../../common/utils/Logger'
import { HdHttp } from '../../common/utils/request'
import { questionDataStructure, row } from '../../models/TopicData'
import { QuestionItemComp, QuestionItem } from '../QuestionItemComp'

import { router } from '@kit.ArkUI'
import { IvSkeleton } from '../../common/components/IvSkeleton'
import { TopicData } from '../Home/HomeCategoryComp'
import { InterviewItem, InterviewItemComp } from './InterviewItemComp'

@Component
export struct InterviewListComp {
  // 试题列表
  @Link questions: row[]
  // 拿到记录当前列表结构的对象
  @Prop issue: TopicData
  // 定义一个状态属性，用来和Refresh组件进行双向数据绑定
  @State isRefreshing: boolean = false
  // 节流, false表示未请求, true表示正在请求
  isLoad: boolean = false

  async loadQuestion(isFlushed: boolean) {
    try {
      const resData = await HdHttp.get<questionDataStructure>("question/list", this.issue)
      isFlushed ? this.questions = resData.data.rows as row[] : this.questions.push(...resData.data.rows as row[])
      Logger.info("questions", JSON.stringify(this.questions).slice(0, 1000))
      this.isRefreshing = false
      this.isLoad = false
    } catch (err) {
      Logger.error("试题列表:", "网络请求出错")
      this.isRefreshing = false
      this.isLoad = false
    }
  }

  // 骨架屏
  @Builder
  skeletonScreen() {
    Column({ space: 8 }) {
      Row({ space: 10 }) {
        IvSkeleton({ widthValue: 30 }); // 指定宽度
        IvSkeleton({ widthValue: 100 }); // 指定宽度
        Blank()
        IvSkeleton({ widthValue: 30 }); // 指定宽度
      }
      .width("100%")

      Column({ space: 3 }) {
        IvSkeleton({ widthValue: 350, heightValue: 16 }); // 指定宽度
        IvSkeleton({ widthValue: 300, heightValue: 16 }); // 指定宽度
      }.width("100%").alignItems(HorizontalAlign.Start)

      Row({ space: 8 }) {
        IvSkeleton({ widthValue: 25, heightValue: 16 }); // 指定宽度
        IvSkeleton({ widthValue: 25, heightValue: 16 }); // 指定宽度
      }
      .width("100%")

      Row({ space: 12 }) {
        IvSkeleton({ widthValue: 25, heightValue: 15 }); // 指定宽度
        IvSkeleton({ widthValue: 30, heightValue: 15 }); // 指定宽度
        IvSkeleton({ widthValue: 20, heightValue: 15 }); // 指定宽度
      }
      .width("100%")

    }
    .width("100%")
  }

  build() {
    Column() {
      if (this.questions.length === 0) {
        Column() {
          Column({ space: 28 }) {
            ForEach(
              Array.from({ length: 10 }),
              () => {
                this.skeletonScreen()
              }
            )
          }
          .height("100%")
          .margin({ top: 17 })
        }
      } else {
        Refresh({ refreshing: $$this.isRefreshing }) {
          List() {
            ForEach(this.questions, (item: InterviewItem, index) => {
              ListItem() {
                InterviewItemComp({ item: item })
                  .onClick(() => {
                    router.pushUrl({
                      url: "pages/QuestionDetailPage",
                      params: {
                        id: this.questions[index].id
                      }
                    })
                  })
              }
            })
          }
          .height("100%")
          .scrollBar(BarState.Off)
          .onReachEnd(() => {
            if (!this.isLoad) {
              this.isLoad = true
              Logger.info("面经页面:", "上拉加载")
              this.issue.page = `${parseInt(this.issue.page) + 1}`
              Logger.info("issue", JSON.stringify(this.issue))
              this.loadQuestion(false)
            }
          })
        }.onRefreshing(() => {
          if (!this.isLoad) {
            this.isLoad = true
            Logger.info("面经页面:", "下拉更新")
            this.issue.page = "1"
            Logger.info("issue", JSON.stringify(this.issue))
            this.loadQuestion(true)
          }
        })
      }


    }
  }
}