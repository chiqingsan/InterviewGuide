import { MyDialog } from '../common/components/CustomDialog'
import { HdHttp } from '../common/utils/Request'
import { windowManager } from '../common/utils/WindowManager'
import { learningData, learningLists } from '../models/LearningData'

interface ListItemStudy {
  id: string
  name: string
  total: number
  done: number
  undone: number
}

@Entry
@Component
struct StudyTimePage {
  // 知识点标题
  @State knowledgeTitle: string = ""
  // 项目标题
  @State projectTitle: string = ""
  @State knowledge: learningLists[] = []
  @State project: learningLists[] = []
  @State
  totalTime: number = 0
  @StorageProp('topHeight')
  topHeight: number = 0
  dialog: CustomDialogController = new CustomDialogController({
    builder: MyDialog({ message: '加载中...' }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  // 秒转换成分钟或者小时
  getTimeText(time: number = 0, hasUnit = true) {
    if (time < 3600) {
      return String(Math.floor(time / 60)) + (hasUnit ? ' 分钟' : '')
    } else {
      return String(Math.round(time / 3600 * 10) / 10) + (hasUnit ? ' 小时' : '')
    }
  }

  //  转换成百分比
  getPercentText(value: number, total: number) {
    return Math.round(value / total * 100) + '%'
  }

  async aboutToAppear(): Promise<void> {
    windowManager.settingStatusBar(true)

    // 进入页面打开加载组件
    this.dialog.open()
    const resData = await HdHttp.get<learningData>("studyInfo")

    animateTo({
      duration: 1000,
      curve: Curve.Ease
    }, () => {
      this.knowledge = resData.data.studyData[0].list
      this.project = resData.data.studyData[1].list
      this.knowledgeTitle = resData.data.studyData[0].type
      this.projectTitle = resData.data.studyData[1].type
      this.totalTime = resData.data.totalTime
    })
    // 数据请求完毕后关闭加载组件
    this.dialog.close()
  }

  aboutToDisappear(): void {
    windowManager.settingStatusBar()
  }

  build() {
    Navigation() {
      Scroll() {
        Column() {
          Row() {
            Text('累计学习时长').margin({ right: (4) })
            Image($r('app.media.icon_study_clock')).width((14)).height((14))
          }.width('100%').margin({ bottom: (10) })

          Row() {
            Text(this.getTimeText(this.totalTime, false)).fontSize((40)).fontWeight(FontWeight.Bold)
            Text(this.totalTime < 3600 ? '分钟' : '小时').margin({ bottom: (8), left: (8) })
          }.width('100%').alignItems(VerticalAlign.Bottom).margin({ bottom: (20) })

          Column() {
            Text(this.knowledgeTitle).margin({ bottom: (10) })
            GridRow({ columns: 2, gutter: 20 }) {
              ForEach(this.knowledge, (item: ListItemStudy) => {
                GridCol() {
                  Column() {
                    Row() {
                      Text(item.name).fontColor('#c3c4c5').fontSize((14))
                      Text(this.getPercentText(item.done, item.total)).fontColor('#c3c4c5').fontSize((14))
                    }.width('100%').justifyContent(FlexAlign.SpaceBetween)
                    .margin({ bottom: (5) })

                    Progress({ value: item.done, total: item.total }).color('#87E0CD')
                  }
                }
              })

              GridCol({ span: 2 }) {
                Row() {
                  Text()
                    .width((7))
                    .height((7))
                    .borderRadius((4))
                    .backgroundColor('#87E0CD')
                    .margin({ right: (4) })
                  Text('已学占比').fontSize((12)).margin({ right: (20) })
                  Text()
                    .width((7))
                    .height((7))
                    .borderRadius((4))
                    .backgroundColor('#c3c4c5')
                    .margin({ right: (4) })
                  Text('未学占比').fontSize((12))
                }.justifyContent(FlexAlign.Center)
              }
            }.backgroundColor('#fff').borderRadius(8).padding((15))

          }.width('100%').alignItems(HorizontalAlign.Start).margin({ bottom: (25) })

          Column() {
            Text(this.projectTitle).margin({ bottom: (10) })
            GridRow({ columns: 1 }) {
              ForEach(this.project, (item: ListItemStudy) => {
                GridCol() {
                  Column() {
                    Row() {
                      Text(item.name).fontColor('#c3c4c5').fontSize((14))
                      Text(this.getPercentText(item.done, item.total)).fontColor('#c3c4c5').fontSize((14))
                    }.width('100%').justifyContent(FlexAlign.SpaceBetween)
                    .margin({ bottom: (5) })

                    Progress({ value: item.done, total: item.total }).color('#c7b5ed').width('100%')
                  }.margin({ bottom: (25) })
                }
              })

              GridCol({ span: 2 }) {
                Row() {
                  Text()
                    .width((7))
                    .height((7))
                    .borderRadius((4))
                    .backgroundColor('#c7b5ed')
                    .margin({ right: (4) })
                  Text('已学占比').fontSize((12)).margin({ right: (20) })
                  Text()
                    .width((7))
                    .height((7))
                    .borderRadius((4))
                    .backgroundColor('#c3c4c5')
                    .margin({ right: (4) })
                  Text('未学占比').fontSize((12))
                }.justifyContent(FlexAlign.Center)
              }
            }.backgroundColor('#fff').borderRadius(8).padding((15))
          }.width('100%').alignItems(HorizontalAlign.Start)

        }.padding((15))
      }
    }
    .title('学习数据')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    // .margin({ top: this.topHeight })
    .linearGradient({
      angle: 163,
      colors: [['#defbee', 0], ['#dbf4f1', 0.2], ['#f6f7f9', 1]]
    })
    .padding({ top: this.topHeight })
  }
}