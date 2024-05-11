import { QuestionItemComp } from '../common/components/QuestionItemComp';
import { TopBar } from '../common/components/TopBar';
import { PreferencesManager } from '../common/utils/Preference';
import { collectionStructure, row } from '../models/TopicData';
import { router } from '@kit.ArkUI';
import { BasicConstant } from '../common/constants/BasicConstant';

interface TabItem {
  name: string
  value: number
  onAreaChange?: (area: Area) => void
}

@Entry
@Component
struct BrowsingHistory {
  @StorageProp("topHeight") topHeight: number = 0
  @State message: string = 'Hello World';
  @State left: number = 16
  @State favoriteTitles: number = 0
  @State listOfQuestions: collectionStructure[] = []
  @State @Watch("recordID") tabsIndex: number = 0
  @State isRefreshing: boolean = false

  setLineLeft(area: Area) {
    const width = area.width as number
    const x = area.position.x as number
    this.left = x + (width - 16) / 2
  }

  aboutToAppear(): void {
    this.loadTheList()
  }

  async loadTheList() {
    const resStr = await PreferencesManager.getData("store", this.tabsIndex ? "EXPERIENCE" : "QUESTIONS", "")
    if (resStr) {
      this.listOfQuestions = JSON.parse(resStr) as collectionStructure[]
    } else {
      this.listOfQuestions = []
    }
  }

  async recordID() {
    await this.loadTheList()
    if (!this.tabsIndex) {
      AppStorage.setOrCreate("ListOfQuestionsId", this.listOfQuestions.map(item => item.id))
    }
  }

  // 标签页
  @Builder
  tabBuilder(tab: TabItem) {
    Text(tab.name)
      .fontSize(14)
      .padding(10)
      .fontColor(this.tabsIndex === tab.value ? '#000' : '#979797')
      .animation({
        duration: 300
      })
      .onClick((e) => {
        this.setLineLeft(e.target.area)
        animateTo({
          duration: 300,
          curve: Curve.Ease
        }, () => {
          this.tabsIndex = tab.value
        })
      })
      .onAreaChange((_o, n) => tab.onAreaChange && tab.onAreaChange(n))
  }

  build() {

    Column() {
      TopBar({ barTitle: "历史记录" })
      // 标签页
      Row() {
        Row() {
          this.tabBuilder({
            name: '题目',
            value: 0,
            onAreaChange: (area) => {
              this.setLineLeft(area)
            }
          })
          this.tabBuilder({ name: '面经', value: 1 })
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
        .margin(5)
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


      if (this.listOfQuestions.length) {
        List() {
          ForEach(
            this.listOfQuestions,
            (item: row) => {
              ListItem() {
                QuestionItemComp({ item: item })
                  .onClick(() => {
                    router.pushUrl({
                      url: this.tabsIndex ? BasicConstant.PAGE_InterviewDetailPage : BasicConstant.PAGE_QuestionDetailPage,
                      params: {
                        id: item.id
                      }
                    })
                  })
              }
            }
          )
        }
        .layoutWeight(1)
        .padding({ left: 20, right: 20, bottom: 10 })
        .scrollBar(BarState.Off)
      } else {
        Column() {
          Image($r("app.media.Frame"))
            .width(64)
            .aspectRatio(1)
          Text("暂无题目浏览记录")
            .fontColor("#C3C3C5")
            .fontSize(12)
            .margin({ top: 5 })
        }.margin({ top: 80 })

      }

    }.padding({ top: this.topHeight })
  }
}