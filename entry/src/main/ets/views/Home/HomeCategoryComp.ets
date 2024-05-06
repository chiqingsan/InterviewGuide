import { Logger } from '../../common/utils/Logger';
import { HdHttp } from '../../common/utils/request'
import { questionStructure } from '../../models/tabs'
import { questionDataStructure, row } from '../../models/TopicData';
import { QuestionListComp } from './QuestionListComp'


export interface TopicData {
  /**
   * 搜索关键词,(定位题目，传题号)
   */
  keyword?: string;

  /**
   * 当前页数，为空默认是1
   */
  page?: string;

  /**
   * 每页大小，为空默认是10
   */
  pageSize?: string;

  /**
   * 9面经10小程序面试题
   */
  questionBankType: string;

  /**
   * 排序，默认0,可以不传，难易-10从易到难11从难道易，浏览量：20从低到高21从高到底,30推荐数据（按照权重倒序）
   * 面经默认是按照更新时间
   */
  sort?: string;

  /**
   * 0或者不传，查询全部 或者类型id
   */
  type?: string;
}


@Entry
@Component
export struct HomeCategoryComp {
  // 需要请求题目的数据结构类型
  @State @Watch("loadQuestion") issue: TopicData = {
    page: "1",
    questionBankType: "10",
    sort: "0",
    type: "0"
  }
  @State tabsIndex: number = 0
  // 题目tabs的数组
  @State tabsTitleList: questionStructure[] = []
  // 题目列表的数组
  @State listOfQuestions: row[] = []


  async aboutToAppear(): Promise<void> {

    // 在页面开始加载的时候, 请求题目tabs栏的数据
    const res = await HdHttp.get<questionStructure[]>("question/type")
    this.tabsTitleList = res.data
    this.tabsTitleList.unshift({
      id: 0,
      name: "全部",
      displayNewestFlag: 0
    } as questionStructure)

    this.loadQuestion()
  }

  async loadQuestion() {
    try {
      console.log("321")
      const resData = await HdHttp.get<questionDataStructure>("question/list", this.issue)
      console.log("123", JSON.stringify(resData))
      this.listOfQuestions = resData.data.rows as row[]
      Logger.info("listOfQuestions", JSON.stringify(this.listOfQuestions).slice(0, 1000))
    } catch (err) {
      Logger.error("首页问题列表:", "网络请求出错")
    }
  }

  build() {
    Stack() {
      // Text(JSON.stringify(this.listOfQuestions))
      Tabs({ index: this.tabsIndex }) {
        ForEach(
          this.tabsTitleList,
          (item: questionStructure, index) => {
            TabContent() {
              // 题目的内容区
              QuestionListComp({ questions: this.listOfQuestions,issue:this.issue })

            }.tabBar(this.tabsItem(item, index))
          }
        )
      }
      .barHeight(50)
      .scrollable(false)
      .barMode(BarMode.Scrollable)
      .onTabBarClick((index) => {
        this.tabsIndex = index
        this.issue.type = this.tabsTitleList[index].id.toString()
      })

      if (this.tabsTitleList.length != 0) {
        Row() {
          // 过滤条件按钮
          Image($r('app.media.gengduo'))
            .height(20)
        }
        .translate({ x: "1%" })
        .height(50)
        .aspectRatio(.7)
        .justifyContent(FlexAlign.Center) // 图片居中对齐
        .backgroundColor(Color.White) // 设置背景色位白色，使过滤条件图标能遮盖住tabbar的文字
        .onClick(() => {
          Logger.info("试题列表", JSON.stringify(this.listOfQuestions))
          this.loadQuestion()
        })
      }
    }
    .width("100%")
    .alignContent(Alignment.TopEnd)
  }

  @Builder
  tabsItem(item: questionStructure, index: number) {
    Row() {
      Column() {
        Text(item.name)
          .fontSize(14)
          .fontWeight(this.tabsIndex === index ? 500 : 400)
          .fontColor(this.tabsIndex === index ? "#121826" : "#979797")
          .padding({ top: 15, bottom: 12 })
        Divider()
          .width(25)
          .strokeWidth(2)
          .color("#121826")
          .opacity(this.tabsIndex === index ? 1 : 0)
          .animation({
            duration: 100,
            curve: Curve.EaseInOut
          })
      }

      if (item.displayNewestFlag) {
        Image($r("app.media.ic_home_new"))
          .height(14)
          .margin({
            left: 4,
            right: index === this.tabsTitleList.length - 1 ? 28 : 0
          })
      }
    }
    .justifyContent(FlexAlign.Center)
    .padding({ left: index && 10, right: 10 })

  }
}