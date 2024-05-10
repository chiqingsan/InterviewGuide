import { Logger } from '../../common/utils/Logger'
import { HdHttp } from '../../common/utils/Request'
import { questionDataStructure, row, TopicData } from '../../models/TopicData'
import { QuestionItemComp} from '../../common/components/QuestionItemComp'
import { router } from '@kit.ArkUI'
import { IvSkeleton } from '../../common/components/IvSkeleton'
import { BasicConstant } from '../../common/constants/BasicConstant'

@Component
export struct QuestionListComp {
  // 试题列表
  @Link @Watch("recordID") questions: row[]
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

  recordID() {
    AppStorage.setOrCreate("ListOfQuestionsId", this.questions.map(item => item.id))
  }

  aboutToAppear(): void {
    this.recordID()
  }

  // 骨架屏
  @Builder
  skeletonScreen() {
    Column({ space: 12 }) {
      Row({ space: 10 }) {
        IvSkeleton({ widthValue: 35 }); // 指定宽度
        IvSkeleton({ widthValue: 250 }); // 指定宽度
      }
      .width("100%");
      Row({ space: 18 }) {
        IvSkeleton({ widthValue: 30 }); // 指定宽度
        IvSkeleton({ widthValue: 8 }); // 指定宽度
        IvSkeleton({ widthValue: 40 }); // 指定宽度
      }
      .width("100%");

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
          .margin({ top: 12 })
        }
      } else {
        Refresh({ refreshing: $$this.isRefreshing }) {
          List() {
            ForEach(this.questions, (item: row, index) => {
              ListItem() {
                QuestionItemComp({ item: item })
                  .onClick(() => {
                    router.pushUrl({
                      url: BasicConstant.PAGE_QuestionDetailPage,
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
              console.log("上拉加载")
              this.issue.page = `${parseInt(this.issue.page) + 1}`
              Logger.info("issue", JSON.stringify(this.issue))
              this.loadQuestion(false)
            }
          })
        }.onRefreshing(() => {
          if (!this.isLoad) {
            this.isLoad = true
            console.log("下拉更新")
            this.issue.page = "1"
            Logger.info("issue", JSON.stringify(this.issue))
            this.loadQuestion(true)
          }
        })
      }


    }
  }
}