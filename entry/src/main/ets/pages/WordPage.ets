import { promptAction } from '@kit.ArkUI'
import { util } from '@kit.ArkTS'
import { webview } from '@kit.ArkWeb'
import { Logger } from '../common/utils/Logger'
import { WordSoundDialog } from '../views/Mine/WordSoundDialog'

export interface WordItem {
  zh: string
  en: string
  code: string
}


@Entry
@Component
export struct WordPage {
  @StorageProp('topHeight') topHeight: number = 0
  @State
  showTypeSheet: boolean = false // 控制当前阶段分类弹框
  @State
  showCodeSheet: boolean = false // 控制当前单词详细代码弹框
  @State
  activeIndex: number = 0 // 当前阶段索引
  @State
  loading: boolean = false
  // word
  words: Record<string, WordItem[]> = {}
  // 实例化web控制器实例
  webview: webview.WebviewController = new webview.WebviewController
  currentCode: string = ''
  currentWordEn: string = ''
  currentWordZh: string = ''
  scroller = new Scroller()
  wordDialog = new CustomDialogController({
    builder: WordSoundDialog({
      wordEn: this.currentWordEn,
      wordZh: this.currentWordZh
    }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  aboutToAppear(): void {
    this.loadWord()
  }

  // 读取当前项目中的rawfile文件夹中的word.json文件中的内容赋值给this.words
  async loadWord() {
    //  1. 定义上下文Resource操作对象
    let mgr = getContext().resourceManager
    let arr = mgr.getRawFileContentSync('word.json')

    //   2. 将arr这个数组转成字符串
    let textDecoder = new util.TextDecoder()
    let wordJsonStr = textDecoder.decodeWithStream(arr)

    //   3. 将字符串转成对象后赋值给当前页面的状态属性words
    this.words = JSON.parse(wordJsonStr)
  }

  // 单词分类弹窗
  @Builder
  typeSheetBuilder() {
    Column() {
      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
        ForEach(Object.keys(this.words), (key: string, index) => {
          Button() {
            Text(key)
              .fontSize(14)
              .fontColor(index === this.activeIndex ? $r('app.color.common_green') : $r('app.color.common_gray_01'))
          }
          .backgroundColor($r('app.color.common_gray_bg'))
          .border({
            width: .5,
            color: "#ffc0b7a9"
          })
          .padding({ top: 6, right: 12, bottom: 6, left: 12 })
          .margin({ right: 12, bottom: 12 })
          .onClick(() => {
            this.activeIndex = index
            this.showTypeSheet = false
            this.scroller.scrollTo({ yOffset: 0, xOffset: 0 })
          })
        })
      }
    }
    .padding({ left: 16, right: 16, top: 8, bottom: 34 })
  }

  // 弹出单词用法弹窗
  @Builder
  codeSheetBuilder() {
    Stack() {
      // Text("使用WebView动态高亮显示单词用法")
      Web({ src: $rawfile('word.html'), controller: this.webview })
        .width('100%')
        .height(250)
        .backgroundColor($r('app.color.common_gray_bg'))
        .javaScriptAccess(true)
        .onPageBegin(() => {
          this.loading = true
        })
        .onPageEnd(() => {
          this.loading = false
          //当word.html加载完毕后将数据高亮化以后呈现出来
          this.webview.runJavaScript(`writeCode(\`${this.currentCode}\`)`)
        })
        .onErrorReceive(event => {
          Logger.error(event!.error.getErrorInfo())
        })
        .borderRadius(8)
      if (this.loading) {
        LoadingProgress()
          .width(50)
          .aspectRatio(1)
      }
    }
    .padding({ left: 16, right: 16, top: 8, bottom: 34 })
  }

  build() {
    Navigation() {
      Column() {
        Row() {
          Column({ space: 4 }) {
            Text('开发常用词汇')
            Text(`共 ${this.words[Object.keys(this.words)[this.activeIndex]]?.length} 个单词`)
              .fontSize(12)
              .fontColor($r('app.color.common_gray_03'))
          }
          .alignItems(HorizontalAlign.Start)

          Row() {
            Text(Object.keys(this.words)[this.activeIndex])
              .fontSize(12)
              .fontColor($r('app.color.common_gray_01'))
            Image($r('sys.media.ohos_ic_public_arrow_down'))
              .width(16)
              .aspectRatio(1)
              .fillColor($r('app.color.common_gray_01'))
          }
          .onClick(() => this.showTypeSheet = true)
          .bindSheet($$this.showTypeSheet, this.typeSheetBuilder(), {
            height: 250,
            title: { title: '选择分类' }
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding(16)
        .border({ width: { top: $r('app.float.common_border_width') }, color: $r('app.color.common_gray_bg') })

        Divider()
          .strokeWidth(8)
          .color($r('app.color.common_gray_bg'))

        List({ scroller: this.scroller }) {
          ForEach(this.words[Object.keys(this.words)[this.activeIndex]], (wordItem: WordItem) => {

            ListItem() {
              Row({ space: 6 }) {
                Image($r('sys.media.ohos_ic_public_sound'))
                  .width(20)
                  .aspectRatio(1)
                  .alignSelf(ItemAlign.Start)
                  .fillColor($r('app.color.common_gray_03'))
                  .onClick(() => {
                    // 开启弹框读单词
                    this.currentWordEn = wordItem.en
                    this.currentWordZh = wordItem.zh

                    // 打开单词朗读页
                    this.wordDialog.open()
                  })
                Column({ space: 10 }) {
                  Text(wordItem.en)
                    .fontWeight(FontWeight.Bold)
                  Text(wordItem.zh)
                    .fontSize(14)
                    .fontColor($r('app.color.common_gray_03'))
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                Column({ space: 10 }) {
                  Row() {
                    Text('详细代码')
                      .fontSize(12)
                      .fontColor(wordItem.code ? $r('app.color.common_gray_01') : '#dddddd')
                    Image($r('sys.media.ohos_ic_public_arrow_right'))
                      .width(16)
                      .aspectRatio(1)
                      .fillColor(wordItem.code ? $r('app.color.common_gray_01') : '#dddddd')
                  }
                  // .alignSelf(ItemAlign.End)
                  .onClick(() => {
                    this.currentCode = wordItem.code
                    if (this.currentCode) {
                      this.showCodeSheet = true
                    } else {
                      promptAction.showToast({ message: '暂无代码' })
                    }
                  })
                }
              }
              .padding(16)
            }
          })
        }
        .divider({
          strokeWidth: $r('app.float.common_border_width'),
          color: $r('app.color.common_gray_bg')
        })
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .bindSheet($$this.showCodeSheet, this.codeSheetBuilder, {
        height: SheetSize.FIT_CONTENT,
        title: { title: '详细代码' }
      })
    }
    .title('常用单词')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
  }
}