import { BasicConstant } from '../../common/constants/BasicConstant'
import { HdTag } from '../../common/components/HdTag'

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
  likeFlag: 0 | 1 | null
}

export class InterviewListParams {
  page: number = 1
  questionBankType: number = 9
  sort: number = 30
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
  likeFlag: 0 | 1 | null = null

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
  }
}

@Component
export struct InterviewItemComp {
  item: InterviewItemModel = new InterviewItemModel({} as InterviewItem)

  @Builder
  menuBuilder() {
    Menu() {
      MenuItem({ content: '屏蔽' }).width(64)
      MenuItem({ content: '举报' }).width(64)
    }
    .radius(12)
  }

  build() {
    Column({ space: 12 }) {
      Row({ space: BasicConstant.SPACE_MD }) {
        Image(this.item.creatorAvatar)
          .width(36)
          .aspectRatio(1)
        Column({ space: BasicConstant.SPACE_SM }) {
          Text(this.item.stem)
            .fontWeight(600)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text() {
            Span(this.item.creatorName)
            Span(' · ')
            Span(this.item.createdAt)
          }
          .fontSize($r('app.float.common_font10'))
          .fontColor('#bdbdbd')
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Image($r('app.media.ic_interview_more'))
          .width(20)
          .aspectRatio(1)
          .alignSelf(ItemAlign.Start)
          .bindMenu(this.menuBuilder())
      }

      Text(this.item.content)
        .fontSize($r('app.float.common_font14'))
        .fontColor($r('app.color.common_gray_03'))
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .lineHeight(20)
        .width('100%')

      Row({ space: BasicConstant.SPACE_SM }) {
        ForEach(['大厂', '面经'], (tag: string) => {
          HdTag({ substance: tag, tagNameColor: "#3BB46E" })
        })
      }
      .width('100%')

      Text() {
        Span('点赞 ' + this.item.likeCount)
        Span(' · ')
        Span('浏览 ' + this.item.views)
        if (this.item.likeFlag === 1) {
          Span(' · ')
          Span('已点赞')
        }
      }
      .width('100%')
      .fontSize($r('app.float.common_font12'))
      .fontColor('#bdbdbd')
    }
    .padding({ top: 16, bottom: 16 })
  }
}