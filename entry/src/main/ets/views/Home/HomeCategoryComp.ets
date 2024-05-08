import { LoadingDialog } from '../../common/components/CustomDialog';
import { IvSkeleton } from '../../common/components/IvSkeleton';
import { Logger } from '../../common/utils/Logger';
import { HdHttp } from '../../common/utils/request'
import { questionStructure } from '../../models/tabs'
import { questionDataStructure, row } from '../../models/TopicData';
import { FilterParams, QuestionFilterComp } from './QuestionFilterComp';
import { QuestionListComp } from './QuestionListComp'


export interface TopicData {
  /**
   * 搜索关键词,(定位题目，传题号)
   */
  keyword?: string;

  /**
   * 当前页数，为空默认是1
   */
  page: string;

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
  sort: string;

  /**
   * 0或者不传，查询全部 或者类型id
   */
  type: string;
}


@Entry
@Component
export struct HomeCategoryComp {
  // 需要请求题目的数据结构类型
  @State issue: TopicData = {
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
  // 控制模态窗口
  @State isShow: boolean = false
  // 设置切换tabs时的防抖
  timer: number = -1
  // loading组件
  dialog: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({ message: '加载中...' }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  async aboutToAppear(): Promise<void> {

    this.dialog.open() //打开对话框
    // 在页面开始加载的时候, 请求题目tabs栏的数据
    const res = await HdHttp.get<questionStructure[]>("question/type")
    this.tabsTitleList = res.data
    AppStorage.setOrCreate("categoryTitle", this.tabsTitleList.map(val => val.name))
    this.tabsTitleList.unshift({
      id: 0,
      name: "全部",
      displayNewestFlag: 0
    } as questionStructure)
    this.dialog.close() //打开对话框
    // 开屏请求一次列表数据
    this.loadQuestion()
  }

  loadQuestion() {
    clearTimeout(this.timer)
    setTimeout(async () => {

      // 清空试题列表, 触发骨架屏的显示
      this.listOfQuestions = []

      try {
        const resData = await HdHttp.get<questionDataStructure>("question/list", this.issue)
        this.listOfQuestions = resData.data.rows as row[]
        Logger.info("listOfQuestions", JSON.stringify(this.listOfQuestions).slice(0, 1000))
      } catch (err) {
        Logger.error("首页问题列表:", "网络请求出错")
      }
    }, 100)
  }

  build() {
    Stack() {
      Tabs({ index: this.tabsIndex }) {
        ForEach(
          this.tabsTitleList,
          (item: questionStructure, index) => {
            TabContent() {
              Column() {
                // 题目的内容区
                QuestionListComp({ questions: this.listOfQuestions, issue: this.issue })
              }
              .padding({ bottom: 180 })
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
        this.loadQuestion()
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
        // .backgroundColor(Color.White) // 设置背景色位白色，使过滤条件图标能遮盖住tabbar的文字
        .linearGradient({
          angle: 90,
          colors: [["#20ffffff", 0], ["#ccffffff", .2], ["#ffffff", 1]]
        })
        .onClick(() => {
          this.isShow = true
        })
        .bindSheet($$this.isShow, this.filterBuilder(), {
          showClose: false, //关闭x
          height: 420,
        })
      }
    }
    .width("100%")
    .alignContent(Alignment.TopEnd)
  }

  // tabs组件
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

  // 模态组件
  @Builder
  filterBuilder() {
    // 一定要使用容器包裹住QuestionFilterComp组件，否则打不开
    Column() {
      QuestionFilterComp({
        questionTypeList: this.tabsTitleList,
        params: {
          // 排序：0 默认 难易 10 从易到难 11 从难道易  20 浏览量↑ 21 浏览量↓
          sort: parseInt(this.issue.sort),
          // 排列顺序：0
          introduction: this.issue.sort && parseInt(this.issue.sort.split("")[1]),
          // 排序的类型
          sortType: this.issue.sort && parseInt(this.issue.sort.split("")[0]),
          // 阶段ID
          index: this.tabsIndex
        } as FilterParams,
        onSubmit: (params) => {
          this.isShow = false
          this.tabsIndex = params.index
          this.issue.sort = params.sort.toString()
          this.issue.type = this.tabsTitleList[params.index].id.toString()
          this.loadQuestion()
        }
      })
    }
  }
}