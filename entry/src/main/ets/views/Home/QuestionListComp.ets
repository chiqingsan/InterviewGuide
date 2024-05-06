import { Logger } from '../../common/utils/Logger'
import { HdHttp } from '../../common/utils/request'
import { questionDataStructure, row } from '../../models/TopicData'
import { QuestionItemComp, QuestionItem } from '../QuestionItemComp'
import { TopicData } from './HomeCategoryComp'
import { router } from '@kit.ArkUI'

@Component
export struct QuestionListComp {
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
      Logger.error("首页问题列表:", "网络请求出错")
      this.isRefreshing = false
      this.isLoad = false
    }
  }

  build() {
    Column() {

      Refresh({ refreshing: $$this.isRefreshing }) {
        List() {
          ForEach(this.questions, (item: row, index) => {
            ListItem() {
              QuestionItemComp({ item: item })
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
          // TODO 下拉bug待解决(骨架屏填充解决)
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
    .padding({ bottom: 180 })
  }
}