import { HdTag } from '../common/components/HdTag'
import { row } from '../models/TopicData'

export interface QuestionItem {
  id: string
  stem: string
  difficulty: number
  likeCount: number
  views: number
  readFlag: 0 | 1
}

export interface QuestionDetail {
  id: string
  stem: string
  difficulty: number
  likeCount: number
  views: number
  readFlag: 0 | 1
  answer: string
  collectFlag: 0 | 1
  likeFlag: 0 | 1
  stage: Array<string>
}

@Preview
@Component
export struct QuestionItemComp {
  item: row = {} as row


  @Builder
  SplitBuilder() {
    Text('|')
      .width(30)
      .textAlign(TextAlign.Center)
      .fontColor('#C3C3C5')
      .fontSize(13)
  }

  @Builder
  TextBuilder(text: string) {
    Text(text)
      .fontColor('#C3C3C5')
      .fontSize(13)
  }

  build() {
    Column() {
      Row({ space: 5 }) {
        HdTag({ difficulty: this.item.difficulty })
        Text(this.item.stem)
          .fontSize(15)
          .layoutWeight(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontWeight(500)
      }.width('100%')

      Row() {
        this.TextBuilder(`点赞 ${this.item.likeCount}`)
        this.SplitBuilder()
        this.TextBuilder(`浏览 ${this.item.views}`)
        if (this.item.readFlag === 1) {
          this.SplitBuilder()
          this.TextBuilder(`已看过`)
        }
      }
      .width('100%')
      .margin({ top: 10 })
    }
    .height(80)
    .justifyContent(FlexAlign.Center)
    .width('100%')
  }
}