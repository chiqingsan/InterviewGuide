import { promptAction, router } from '@kit.ArkUI'
import { preferences } from '@kit.ArkData'
import { Logger } from '../common/utils/Logger'

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

  aboutToAppear(): void {

    try {
      this.keyword = (router.getParams() as object)["title"]

    } catch (err) {
      Logger.error("搜索页面:", "路由出错")
    }


    this.getData()
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
    Row({ space: 20 }) {
      Text(text)
      if (this.isDel) {
        Text('x')
          .height(30)
          .onClick(async () => {
            // AlertDialog.show({ message: '删除' + text })
            await this.delData(text)
            await this.getData()
          })
      }
    }
    .margin({ right: 10, top: 10 })
    .padding({ left: 15, right: 15, top: 5, bottom: 5 })
    .backgroundColor('rgba(0,0,0,0.05)')
    .borderRadius(20)
  }

  build() {
    Navigation() {
      Column({ space: 15 }) {
        // 1. 搜索关键字
        Row() {
          TextInput({ placeholder: '输入回车保存数据', text: $$this.keyword })
            .onSubmit(async () => {
              // AlertDialog.show({ message: this.keyword })
              await this.saveData(this.keyword)
              await this.getData()
            })
            .layoutWeight(4)
            .height(45)

          Text('取消')
            .width(50)
            .padding({ right: 15, left: 15 })
            .fontWeight(500)
            .onClick(() => {
              // 打开查询数据组件
            })
            .layoutWeight(1)
        }

        // 2. 关键字列表
        Row() {
          Text('搜索记录').fontSize(20).fontWeight(800)

          Row() {
            if (this.isDel) {
              Text('全部删除')
                .onClick(async () => {
                  await this.delData()
                  await this.getData()
                })
              Text(' | ')
              Text('取消删除')
                .onClick(() => {
                  this.isDel = false
                })
            }

            Image($r('app.media.ic_common_delete'))
              .height(28)
              .onClick(() => {
                this.isDel = true
              })
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        //   3. 关键字列表
        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(this.list, (item: string) => {
            this.itemBuilder(item)
          })
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