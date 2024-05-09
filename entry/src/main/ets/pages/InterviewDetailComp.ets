import { promptAction, router } from '@kit.ArkUI'
import { HdRichText } from '../common/components/HdRichText'
import { HdTag } from '../common/components/HdTag'
import { IvSkeleton } from '../common/components/IvSkeleton'
import { RelatedQuestions } from '../common/constants/RelatedQuestions'
import { opt } from '../common/function/LikeAndFavorite'
import { Logger } from '../common/utils/Logger'
import { HdHttp } from '../common/utils/request'
import { interviewTracking, trackingService } from '../common/function/TrackingService'

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
  @StorageProp('topHeight') topHeight: number = 0
  @State
  item: InterviewItem = {} as InterviewItem
  scroller: Scroller = new Scroller()
  @State
  show: boolean = false
  @State
  questionId: number = 0
  @State
  loading: boolean = false

  // @Builder
  // menuBuilder() {
  //   Menu() {
  //     MenuItem({ content: this.item.likeFlag === 1 ? '取消点赞' : '点赞' })
  //       .onClick(() => {
  //         this.opt(1, this.item.likeFlag).then(() => {
  //           this.item.likeFlag = this.item.likeFlag === 1 ? 0 : 1
  //           const likeCount =
  //             this.item.likeFlag === 1
  //               ? Number(this.item.likeCount) + 1
  //               : Number(this.item.likeCount) - 1
  //         })
  //       })
  //     MenuItem({ content: this.item.collectFlag === 1 ? '取消收藏' : '收藏' })
  //       .onClick(() => {
  //         this.opt(2, this.item.collectFlag).then(() => {
  //           this.item.collectFlag = this.item.collectFlag === 1 ? 0 : 1
  //         })
  //       })
  //   }
  //   .radius(12)
  //   .width(108)
  // }

  /**
   * type:1:点赞，2：收藏
   * flag: 1:已点赞/已收藏，0：未点赞/未收藏
   */
  // async opt(type: 1 | 2, flag: 0 | 1) {
  //   try {
  //     let data: OptData = {
  //       id: this.questionId.toString(),
  //       type: 0,
  //       optType: type
  //     }
  //
  //     await HdHttp.post<OptModel>(flag === 1 ? 'question/unOpt' : 'question/opt', data)
  //     return promptAction.showToast({ message: '操作成功' })
  //   } catch (err) {
  //     promptAction.showToast({ message: '操作失败' })
  //     return Promise.reject(err)
  //   }
  // }

  async getData() {
    const resData = await HdHttp.get<InterviewItem>(`question/${this.questionId}`)
    // .then(res => {
    //   promptAction.showToast({ message: '面经数据已更新' })
    //   Logger.debug('面经' + this.questionId, JSON.stringify(res.data))
    //   this.item = res.data
    // })
    // promptAction.showToast({ message: '面经数据已更新' })
    Logger.debug('面经' + this.questionId, JSON.stringify(resData.data))
    this.item = resData.data
  }

  aboutToAppear(): void {
    console.log("item", JSON.stringify(Object.entries(this.item)))
    // 获取路由参数id的值
    let params: ParamsType = router.getParams() as ParamsType
    this.questionId = params.id

    // 根据id获取数据详情
    this.getData()

    // 在进入页面时，设置要上报的题目id和当前时间
    interviewTracking.setStartTime()
    interviewTracking.setId(this.questionId.toString())
  }

  // 离开页面时
  async aboutToDisappear() {
    try {
      // 设置最后时间，并上报埋点数据
      interviewTracking.setEndTime()
      await interviewTracking.save()

    } catch (err) {
      console.log('mylog->InterviewDetailComp aboutToDisappear err', JSON.stringify(err))
      throw new Error(JSON.stringify(err))
    }
  }

  build() {
    Column() {
      Row({ space: 16 }) {
        Image($r('sys.media.ohos_ic_public_arrow_left'))
          .size({ width: 30, height: 30 })
          .onClick(() => router.back())
        Blank()
        Image($r('sys.media.ohos_ic_public_more'))
          .size({ width: 24, height: 20 })
          .objectFit(ImageFit.Contain)
          .bindMenu([{
            value: this.item.collectFlag === 1 ? '取消收藏' : '收藏',
            action: async () => {
              // 点赞和取消点赞业务逻辑代码
              // this.opt(1,0)
              // this.opt(this.question.collectFlag !== 1, "2")
              await opt(this.questionId.toString(), this.item.collectFlag !== 1, "2")
              this.getData()
            }
          },
            {
              value: this.item.likeFlag === 1 ? '取消点赞' : '点赞',
              action: async () => {
                // 点赞和取消点赞业务逻辑代码
                // this.opt(1,0)
                // this.opt(this.question.likeFlag !== 1, "1")
                await opt(this.questionId.toString(), this.item.likeFlag !== 1, "1")
                this.getData()
              }
            }])
      }
      .padding({ left: 16, right: 16 })
      .height(56)
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)


      Column({ space: 16 }) {
        if (Object.keys(this.item).length) {
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
              IvSkeleton({ widthValue: 50, heightValue: 16 })
              IvSkeleton({ widthValue: 180, heightValue: 14 })
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

        Column() {
          if (Object.keys(this.item).length) {
            HdRichText({ richTextContent: this.item.content })
          } else {
            LoadingProgress()
              .width(100)
            Text("Loading")
              .fontSize(30)
              .fontWeight(500)
          }
        }.layoutWeight(1).justifyContent(FlexAlign.Center)

        // ref
        Row({ space: 4 }) {
          Text('相关题目：')
            .fontSize(14)
          Column({ space: 10 }) {
            ForEach(Array.from({ length: 4 }), () => {
              Row() {
                Image($r('app.media.ic_interview_file'))
                  .size({ width: 14, height: 14 })
                  .fillColor($r('app.color.common_blue'))
                Text(RelatedQuestions[Math.floor(Math.random() * RelatedQuestions.length)].question)
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

        Row() {
          Text('© 著作权归作者所有')
            .fontSize(12)
            .fontColor($r('app.color.common_gray_01'))
        }.height(35).alignItems(VerticalAlign.Top)
      }.layoutWeight(1)
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
    .height('100%')
    .padding({ top: this.topHeight })
    .justifyContent(FlexAlign.Start)
  }
}