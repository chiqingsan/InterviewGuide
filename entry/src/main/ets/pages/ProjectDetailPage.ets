import { HdSearch } from '../common/components/HdSearch'
import { BasicConstant } from '../common/constants/BasicConstant'
import { router } from '@kit.ArkUI'
import { QuestionListComp } from '../views/Home/QuestionListComp'
import { TopicData } from '../views/Home/HomeCategoryComp'
import { HdHttp } from '../common/utils/request'
import { questionDataStructure, row } from '../models/TopicData'

export interface ProjectTag {
  tagName: string
}

export interface ProjectItem {
  id: number
  name: string
  icon: ResourceStr
  describeInfo: string | null
  tags: ProjectTag[]
}

export class ProjectItemModel implements ProjectItem {
  id: number
  name: string
  icon: ResourceStr
  describeInfo: string | null
  tags: ProjectTag[]

  constructor(model: ProjectItem) {
    this.id = model.id
    this.name = model.name
    this.icon = model.icon
    this.describeInfo = model.describeInfo
    this.tags = model.tags
  }
}

@Entry
@Component
export struct ProjectDetailComp {
  // 状态栏高度
  @StorageProp("topHeight") topHeight: number = 0
  // // 项目的ID
  // @State questionId: number = 0
  // 0 默认 21 降序 20 升序

  // 需要请求题目的数据结构类型
  @State issue: TopicData = {
    page: "1",
    questionBankType: "10",
    sort: "0",
    type: "0"
  }
  // 题目列表
  @State listOfQuestions: row[] = []
  // 题目的总数量
  @State total: number = 0
  @State
  sort: number = 0
  // 可选排序
  sortArr: string[] = ["0", "21", "20"]
  @State
  projectItem: ProjectItemModel = {} as ProjectItem

  async aboutToAppear(): Promise<void> {
    // 获取项目列表页传入的路由数据
    this.projectItem = router.getParams() as ProjectItemModel
    this.issue.type = this.projectItem.id.toString()

    const resData = await HdHttp.get<questionDataStructure>("question/list", this.issue)
    this.listOfQuestions = resData.data.rows as row[]
    this.total = resData.data.total as number

  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Top }) {
        Image($r('app.media.project_bg'))
          .width('100%')
          .height(236)
          .opacity(0.2)
          .offset({
            y: -this.topHeight
          })
        Column() {
          Row() {
            Image($r('sys.media.ohos_ic_public_arrow_left'))
              .size({ width: 35, height: 35 })
              .fillColor(Color.White)
              .onClick(() => router.back())
            Blank()
              .layoutWeight(1)
            HdSearch({ bg: 'rgba(246, 247, 249, 0.5)', color: '#333333' })
              .layoutWeight(3)
          }
          .height(56)
          .width('100%')

          Row({ space: BasicConstant.SPACE_LG }) {
            Image(this.projectItem.icon)
              .width(86)
              .height(114)
              .sharedTransition(this.projectItem.id.toString(), { duration: 300 })
            Column({ space: BasicConstant.SPACE_LG }) {
              Text(this.projectItem.name)
                .fontWeight(500)
                .fontColor(Color.White)
              Text(this.projectItem.describeInfo)
                .fontSize($r('app.float.common_font14'))
                .fontColor(Color.White)
              Blank()
              Text(`学习进度：10%`)
                .fontColor($r('app.color.common_gray_01'))
                .fontSize($r('app.float.common_font14'))
            }
            .layoutWeight(1)
            .height(114)
            .alignItems(HorizontalAlign.Start)
          }
          .alignItems(VerticalAlign.Top)
          .width('100%')
        }
        .padding({ left: $r('app.float.common_space16'), right: $r('app.float.common_space16') })
      }
      .height(210)

      Column() {
        Row({ space: BasicConstant.SPACE_MD }) {
          Text('问题列表')
            .fontWeight(500)
          Blank()
          Row() {
            Text('浏览量')
              .fontSize($r('app.float.common_font14'))
              .fontColor(this.issue.sort != "0" ? $r('app.color.common_main_color') : Color.Black)
            Column() {
              Image($r('sys.media.ohos_ic_public_arrow_up'))
                .size({ width: 16, height: 6 })
                .fillColor(this.issue.sort === "20" ? $r('app.color.common_main_color') : Color.Black)
              Image($r('sys.media.ohos_ic_public_arrow_down'))
                .size({ width: 16, height: 6 })
                .fillColor(this.issue.sort === "21" ? $r('app.color.common_main_color') : Color.Black)
            }
            .alignItems(HorizontalAlign.Start)
          }
          .onClick(() => {
            const index = this.sortArr.findIndex(i => i === this.issue.sort)
            this.issue.sort = this.sortArr[(index + 1) % this.sortArr.length]
          })
        }
        .height(44)
        .width('100%')
        .padding({ left: $r('app.float.common_space16'), right: $r('app.float.common_space16') })
        .border({
          width: { bottom: $r('app.float.common_border_width') },
          color: $r('app.color.common_gray_border')
        })

        Column() {
          // 项目题目列表
          // Text('使用题目列表组件QuestionListComp')
          QuestionListComp({ questions: this.listOfQuestions, issue: this.issue })

        }
        .width("100%")
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .padding({ bottom: 10, left: 20, right: 20 })
      }
      .layoutWeight(1)
      .backgroundColor(Color.White)
      .width('100%')
      .borderRadius({ topLeft: 16, topRight: 16 })
    }
    .width('100%')
    .height('100%')
    .padding({ top: this.topHeight })
    .backgroundColor('#5D2B05')
  }
}