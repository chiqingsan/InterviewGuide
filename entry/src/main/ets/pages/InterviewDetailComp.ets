import { promptAction, router } from '@kit.ArkUI'
import { HdTag } from '../common/components/HdTag'
import { IvSkeleton } from '../common/components/IvSkeleton'
import { Logger } from '../common/utils/Logger'
import { HdHttp } from '../common/utils/request'
import { trackingService } from '../common/utils/TrackingService'

// import { DetailRichText } from '../home/DetailRichText'

export interface InterviewItem {
  id: string
  stem: string
  content: string
  likeCount: number
  views: number
  creatorName: string
  creatorAvatar: ResourceStr
  createdAt: string
  tags: string[]
  likeFlag: 0 | 1
  collectFlag: 0 | 1
}

export class InterviewItemModel implements InterviewItem {
  id: string = ''
  stem: string = ''
  content: string = ''
  likeCount: number = 0
  views: number = 0
  creatorName: string = ''
  creatorAvatar: ResourceStr = ''
  createdAt: string = ''
  tags: string[] = []
  likeFlag: 0 | 1 = 0
  collectFlag: 0 | 1 = 0

  constructor(model: InterviewItem) {
    this.id = model.id
    this.stem = model.stem
    this.content = model.content
    this.likeCount = model.likeCount
    this.views = model.views
    this.creatorName = model.creatorName
    this.creatorAvatar = model.creatorAvatar
    this.createdAt = model.createdAt
    this.tags = model.tags
    this.likeFlag = model.likeFlag
    this.collectFlag = model.collectFlag
  }
}

// 接收路由参数实体
export interface ParamsType {
  id: number
}

interface OptData {
  id: string,
  type: number,
  optType: 1 | 2
}

interface OptDataModel {
  id: number
}

interface OptModel {
  /**
   * 请求成功code
   */
  code?: number;
  data?: OptDataModel
  /**
   * 请求成功message
   */
  message?: string;

  /**
   * 请求成功标志
   */
  success?: boolean;
}


@Entry
@Component
export struct InterviewDetailComp {
  @State
  item: InterviewItemModel = {} as InterviewItem
  // stem:'标题',
  // views:100,
  // likeCount:100,
  // createdAt:'2024-01-22',
  // creatorAvatar:$r('app.media.ic_interview_logo'),
  // creatorName:'hajimi',
  // content:'面经详情内容',
  // tags:['vue','前端']
  scroller: Scroller = new Scroller()
  @State
  show: boolean = false
  @State
  questionId: number = 0
  @State
  loading: boolean = false

  @Builder
  menuBuilder() {
    Menu() {
      MenuItem({ content: this.item.likeFlag === 1 ? '取消点赞' : '点赞' })
        .onClick(() => {
          this.opt(1, this.item.likeFlag).then(() => {
            this.item.likeFlag = this.item.likeFlag === 1 ? 0 : 1
            const likeCount =
              this.item.likeFlag === 1
                ? Number(this.item.likeCount) + 1
                : Number(this.item.likeCount) - 1
          })
        })
      MenuItem({ content: this.item.collectFlag === 1 ? '取消收藏' : '收藏' })
        .onClick(() => {
          this.opt(2, this.item.collectFlag).then(() => {
            this.item.collectFlag = this.item.collectFlag === 1 ? 0 : 1
          })
        })
    }
    .radius(12)
    .width(108)
  }

  /**
   * type:1:点赞，2：收藏
   * flag: 1:已点赞/已收藏，0：未点赞/未收藏
   */
  async opt(type: 1 | 2, flag: 0 | 1) {
    try {
      let data: OptData = {
        id: this.questionId.toString(),
        type: 0,
        optType: type
      }

      await HdHttp.post<OptModel>(flag === 1 ? 'question/unOpt' : 'question/opt', data)
      return promptAction.showToast({ message: '操作成功' })
    } catch (err) {
      promptAction.showToast({ message: '操作失败' })
      return Promise.reject(err)
    }
  }

  getData() {
    HdHttp.get<InterviewItemModel>(`question/${this.questionId}`)
      .then(res => {
        promptAction.showToast({ message: '面经数据已更新' })
        Logger.debug('面经' + this.questionId, JSON.stringify(res.data))
        this.item = res.data
      })
  }

  aboutToAppear(): void {
    console.log("item", JSON.stringify(Object.entries(this.item)))
    // 获取路由参数id的值
    let params: ParamsType = router.getParams() as ParamsType
    this.questionId = params.id


    //在进入页面时，设置要上报的题目id和当前时间
    trackingService.setQuestionId(this.item.id)
    trackingService.setStartTime()

    // 根据id获取数据详情
    this.getData()
  }

  // 离开页面时
  async aboutToDisappear() {
    try {
      // 设置最后时间，并上报埋点数据
      trackingService.setEndTime()
      await trackingService.save()

    } catch (err) {
      console.log('mylog->InterviewDetailComp aboutToDisappear err', JSON.stringify(err))
      throw new Error(JSON.stringify(err))
    }
  }

  build() {
    Column() {
      // nav
      Row({ space: 16 }) {
        Image($r('sys.media.ohos_ic_public_arrow_left'))
          .size({ width: 24, height: 24 })
          .onClick(() => router.back())
        if (Object.keys(this.item).length != 0) {
          Text(this.item.stem)
            .fontWeight(600)
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
            .fontSize(18)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .opacity(this.show ? 1 : 0)
            .animation({ duration: 300 })
        }
        Image($r('sys.media.ohos_ic_public_more'))
          .size({ width: 24, height: 20 })
          .objectFit(ImageFit.Contain)
          .bindMenu(this.menuBuilder())
      }
      .padding({ left: 16, right: 16 })
      .height(56)
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)


      Scroll(this.scroller) {
        Column({ space: 16 }) {
          if (Object.keys(this.item).length != 0) {
            Text(this.item.stem)
              .fontWeight(600)
              .fontSize(18)

            Row({ space: 4 }) {
              Image(this.item.creatorAvatar)
                .width(36)
                .aspectRatio(1)
              Column({ space: 4 }) {
                Text(this.item.creatorName)
                  .fontSize(14)
                Text() {
                  Span('浏览 ' + this.item.views)
                  Span(' · ')
                  Span('点赞 ' + this.item.likeCount)
                  Span(' · ')
                  Span(this.item.createdAt)
                }
                .width('100%')
                .fontSize($r('app.float.common_font12'))
                .fontColor('#bdbdbd')
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
            }

            Row({ space: 4 }) {
              ForEach(this.item.tags, (tag: string) => {
                HdTag({ substance: tag })
              })
            }
            .width('100%')
          } else {
            IvSkeleton({ widthValue: 160 })
            Row({ space: 4 }) {
              Image($r("app.media.startIcon"))
                .width(36)
                .aspectRatio(1)
              Column({ space: 4 }) {
                IvSkeleton({ widthValue: 50, heightValue: 18 })
                IvSkeleton({ widthValue: 180, heightValue: 18 })
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
            }

            Row({ space: 4 }) {
              IvSkeleton({ widthValue: 28, heightValue: 15 })
              IvSkeleton({ widthValue: 28, heightValue: 15 })
            }
            .width('100%')
          }

          // con
          // DetailRichText({ content: this.item.content })

          // ref
          Row({ space: 4 }) {
            Text('相关题目：')
              .fontSize(14)
            Column({ space: 10 }) {
              ForEach([1, 2, 3, 4], () => {
                Row() {
                  Image($r('app.media.ic_interview_file'))
                    .size({ width: 14, height: 14 })
                    .fillColor($r('app.color.common_blue'))
                  Text(' Vue 生命周期总共分为几个阶段？')
                    .fontSize(12)
                    .fontColor($r('app.color.common_blue'))
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .width('100%')
              })
            }
            .layoutWeight(1)
          }
          .alignItems(VerticalAlign.Top)
          .padding(16)
          .backgroundColor($r('app.color.common_gray_bg'))
          .borderRadius(8)

          Text('© 著作权归作者所有')
            .fontSize(12)
            .fontColor($r('app.color.common_gray_01'))
            .height(60)
        }
        .padding({ left: 16, right: 16 })
      }
      .onScroll(() => {
        this.show = this.scroller.currentOffset().yOffset > 30
      })
    }
    .width('100%')
    .height('100%')
    .padding({ top: 30 })
    .justifyContent(FlexAlign.Start)
  }
}