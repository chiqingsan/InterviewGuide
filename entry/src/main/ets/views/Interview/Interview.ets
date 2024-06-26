import { HdSearch } from '../../common/components/HdSearch'
import { HdHttp } from '../../common/utils/Request'
import { questionDataStructure, row, TopicData } from '../../models/TopicData'
import { InterviewListComp } from './InterviewListComp'

// 热门企业实体
interface Company {
  icon: ResourceStr
  count: number
}

interface TabItem {
  name: string
  value: string
  onAreaChange?: (area: Area) => void
}

@Entry
@Component
export struct Interview {
  @State
  left: number = 16
  // 需要请求题目的数据结构类型
  @State @Watch("updateInterview") issue: TopicData = {
    page: "1",
    questionBankType: "9",
    sort: "30",
    type: "0"
  }
  // 题目列表的数组
  @State listOfQuestions: row[] = []

  setLineLeft(area: Area) {
    const width = area.width as number
    const x = area.position.x as number
    this.left = x + (width - 16) / 2
  }

  aboutToAppear(): void {
    this.updateInterview()
  }

  async updateInterview() {
    // 清空列表, 触发骨架屏
    this.listOfQuestions = []
    const resDate = await HdHttp.get<questionDataStructure>("question/list", this.issue)
    this.listOfQuestions = resDate.data.rows as row[]
  }

  // 热门企业
  @Builder
  companyBuilder(com: Company) {
    Column({ space: 12 }) {
      Image(com.icon)
        .width(36)
        .aspectRatio(1)
        .margin({ top: 20 })
        .objectFit(ImageFit.Contain)
      Text() {
        Span('热门指数')
        Span(`${com.count}K`)
          .fontColor($r('app.color.common_green'))
      }
      .fontSize(13)
      .fontColor($r('app.color.common_gray_01'))

      Button({ type: ButtonType.Normal }) {
        Text('查看')
          .fontSize(14)
      }
      .backgroundColor($r('app.color.common_gray_bg'))
      .padding(0)
      .height(30)
      .width(80)
      .borderRadius(8)

    }
    .backgroundColor(Color.White)
    .borderRadius(8)
    .height(140)
    .width(100)
  }

  // 标签页
  @Builder
  tabBuilder(tab: TabItem) {
    Text(tab.name)
      .fontSize(14)
      .padding(10)
      .fontColor(this.issue.sort === tab.value ? '#000' : '#979797')
      .animation({
        duration: 300
      })
      .onClick((e) => {
        this.setLineLeft(e.target.area)
        this.issue.sort = tab.value
      })
      .onAreaChange((_o, n) => tab.onAreaChange && tab.onAreaChange(n))
  }

  build() {
    Column() {
      Row({ space: 16 }) {
        Image($r('app.media.ic_interview_text'))
          .width(54)
          .height(20)
          .objectFit(ImageFit.Contain)
          .layoutWeight(1)
        HdSearch()
          .layoutWeight(3)
      }
      .padding({ left: 16, right: 16 })
      .height(64)

      // 热门企业
      Scroll() {
        Row({ space: 10 }) {
          this.companyBuilder({ icon: $r('app.media.ic_company_hw'), count: 1.5 })
          this.companyBuilder({ icon: $r('app.media.ic_company_wr'), count: 2.9 })
          this.companyBuilder({ icon: $r('app.media.ic_company_gg'), count: 3.1 })
          this.companyBuilder({ icon: $r('app.media.ic_company_zj'), count: 5.3 })
          this.companyBuilder({ icon: $r('app.media.ic_company_wy'), count: 3.6 })
        }
      }
      .width('100%')
      .height(160)
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .padding(10)

      .edgeEffect(EdgeEffect.Spring)
      .backgroundColor($r('app.color.common_gray_bg'))

      // 标签页
      Row() {
        Row() {
          this.tabBuilder({
            name: '推荐',
            value: "30",
            onAreaChange: (area) => {
              this.setLineLeft(area)
            }
          })
          this.tabBuilder({ name: '最新', value: "20" })
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
        .height(40)
        .border({
          width: { bottom: $r('app.float.common_border_width') },
          color: $r('app.color.common_gray_border')
        })

        Text()
          .width(16)
          .height(2)
          .backgroundColor('#000000')
          .position({ x: this.left, y: 38 })
          .animation({
            duration: 300
          })
      }

      // 文章列表
      InterviewListComp({ questions: this.listOfQuestions, issue: this.issue })
        .padding({ left: 10, right: 10 })
    }
    .width('100%')
    .height('100%')
    .padding({ top: 30 })
  }
}