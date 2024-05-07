import { promptAction, router } from '@kit.ArkUI'
import { preferences } from '@kit.ArkData'
import { Logger } from '../common/utils/Logger'
import { QuestionListComp } from '../views/Home/QuestionListComp'
import { questionDataStructure, row } from '../models/TopicData'
import { HdHttp } from '../common/utils/request'
import { TopicData } from '../views/Home/HomeCategoryComp'

interface iSearchItemParams {
  text: string
  isShowDel: boolean
  delCallBack: () => void
}

@Entry
@Component
export struct SearchPage {
  @State keyword: string = ''
  @State isDel: boolean = false
  @StorageProp('topHeight') topHeight: number = 0
  @State list: string[] = []
  // 控制是否暂时搜索结果的列表
  @State isListShow: boolean = false
  // 请求回来的搜索试题列表
  @State questions: row[] = []
  // 需要请求题目的数据结构类型
  @State issue: TopicData = {
    page: "1",
    questionBankType: "10",
    sort: "0",
    type: "0",
    keyword: ""
  }
  // 节流
  isLoad: boolean = false

  aboutToAppear(): void {

    // 获取保存的list
    this.getData()
    try {
      const text: string = (router.getParams() as object)["title"]
      this.keyword = text
      if (this.keyword) {
        this.getKeyword()
        if (!this.list.includes(this.keyword)) {
          this.saveData(text)
          this.getData()
        }
      }
    } catch (err) {
      Logger.error("搜索页面:", "路由出错")
    }


  }

  async getKeyword() {
    try {
      // 更新关键字
      this.issue.keyword = this.keyword
      const resData = await HdHttp.get<questionDataStructure>("question/list", this.issue)
      this.questions = resData.data.rows as row[]
      Logger.info("keyword:", JSON.stringify(this.questions).slice(0, 1000))
      this.isLoad = false
      this.isListShow = true

      // 保存题目id数组
      AppStorage.setOrCreate("ListOfQuestionsId", this.questions.map(item => item.id))
    } catch (err) {
      Logger.error("搜索列表:", "网络请求出错")
      this.isLoad = false
    }
  }

  async saveData(text: string) {
    const pre = preferences.getPreferencesSync(getContext(), { name: 'store' })

    let kwList = pre.getSync('keyword', []) as string[]
    kwList.push(text)
    pre.putSync('keyword', kwList)

    await pre.flush()
  }

  async getData() {
    const pre = preferences.getPreferencesSync(getContext(), { name: 'store' })
    this.list = pre.getSync('keyword', []) as string[]
    // AlertDialog.show({ message: JSON.stringify(res, null, 2) })
  }

  async delData(text?: string) {
    const pre = preferences.getPreferencesSync(getContext(), { name: 'store' })
    let list = pre.getSync('keyword', []) as string[]
    if (text) {
      list.splice(list.findIndex(item => item === text), 1)
      pre.putSync('keyword', list)
    } else {
      pre.deleteSync('keyword')
    }
    await pre.flush()
  }

  @Builder
  itemBuilder(text: string) {
    Row({ space: 10 }) {
      Text(text)
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
        .maxLines(1)
      if (this.isDel) {
        Image($r("app.media.ic_common_delete"))
          .fillColor("#121212")
          .height(20)
          .onClick(async () => {
            // AlertDialog.show({ message: '删除' + text })
            await this.delData(text)
            await this.getData()
          })
      }
    }
    .onClick(() => {
      this.keyword = text
      this.getKeyword()
    })
    .margin({ right: 10, top: 10 })
    .padding({ left: 15, right: 15, top: 8, bottom: 8 })
    .backgroundColor('rgba(0,0,0,0.05)')
    .borderRadius(20)
  }

  build() {
    Navigation() {
      Column({ space: 15 }) {
        // 1. 搜索关键字
        Row({ space: 10 }) {
          TextInput({ placeholder: '输入回车搜索题目', text: $$this.keyword })
            .onSubmit(async () => {
              // AlertDialog.show({ message: this.keyword })
              this.getKeyword()
              if (!this.list.includes(this.keyword)) {
                this.saveData(this.keyword)
                this.getData()
              }
            })
            .layoutWeight(4)
            .height(45)

          Button(this.isListShow ? '取消' : '搜索')
            .width(50)
            .padding({ right: 15, left: 15 })
            .backgroundColor(this.isListShow ? "#ffff3c3c" : "#cc0A59F7")
            .fontWeight(500)
            .onClick(() => {
              // 打开查询数据组件
              if (this.isListShow) {
                this.isListShow = false
              } else {
                this.getKeyword()
                if (!this.list.includes(this.keyword)) {
                  this.saveData(this.keyword)
                  this.getData()
                }
              }
            })
            .layoutWeight(1)
        }


        if (!this.isListShow) {
          // 2. 关键字列表
          Row() {
            Text('搜索记录').fontSize(20).fontWeight(800)

            Row({ space: 8 }) {
              if (this.isDel) {
                Text('全部删除')
                  .fontSize(14)
                  .padding(3)
                  .border({
                    width: 1,
                    color: "#ffed3d3d",
                    radius: 10
                  })
                  .fontColor("#ffed3d3d")
                  .onClick(async () => {
                    await this.delData()
                    await this.getData()
                  })
                Text(' | ')
                Text('取消删除')
                  .fontSize(14)
                  .onClick(() => {
                    animateTo({
                      duration: 1000,
                      curve: Curve.Friction
                    }, () => {
                      this.isDel = false
                    })
                  })
              }

              Image($r('app.media.ic_common_delete'))
                .fillColor("#121212")
                .height(28)
                .onClick(() => {
                  animateTo({
                    duration: 1000,
                    curve: Curve.Friction
                  }, () => {
                    this.isDel = true
                  })
                })
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          //   3. 关键字列表
          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach([...this.list].reverse(), (item: string) => {
              this.itemBuilder(item)
            })
          }
        } else {
          Column() {
            QuestionListComp({ questions: this.questions, issue: this.issue })
          }.padding({ bottom: 50 })
        }
      }
      .padding(15)
    }
    .title('刷个面试题')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .padding({ top: this.topHeight })
  }
}