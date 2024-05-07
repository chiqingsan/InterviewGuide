import { questionStructure } from '../../models/tabs'

export interface QuestionType {
  id: number
  name: string
  displayNewestFlag: 0 | 1
}

export class QuestionTypeModel implements QuestionType {
  id: number = 0
  name: string = ''
  displayNewestFlag: 0 | 1 = 0

  constructor(model: QuestionType) {
    this.id = model.id
    this.name = model.name
    this.displayNewestFlag = model.displayNewestFlag
  }
}

@Preview
@Component
struct FilterButton {
  @Prop
  isActive: boolean = false
  @Prop
  sortValue: number = 0
  @State
  positionX: number = 0
  text: string = ''
  isNew: boolean = false
  isSort: boolean = false

  build() {
    Button({ type: ButtonType.Normal }) {
      Row({ space: 6 }) {
        Text(this.text)
          .fontSize(12)
          .fontColor(this.isActive ? $r('app.color.common_main_color') : Color.Black)
        if (this.isNew) {
          Image($r('app.media.ic_home_new'))
            .width(32)
            .height(14)
            .alignSelf(ItemAlign.Start)
            .position({ x: this.positionX, y: -5 })
        }
        if (this.isSort) {
          Column() {
            Image($r('sys.media.ohos_ic_public_arrow_up'))
              .size({ width: 12, height: 6 })
              .fillColor(this.sortValue === 0 && this.isActive ? $r('app.color.common_main_color') : Color.Black)
            Image($r('sys.media.ohos_ic_public_arrow_down'))
              .size({ width: 12, height: 6 })
              .fillColor(this.sortValue === 1 && this.isActive ? $r('app.color.common_main_color') : Color.Black)
          }
        }
      }
      .height(30)
      .padding({ left: 10, right: 10 })
      .onAreaChange((_old, now) => {
        this.positionX = Number(now.width) - 24
      })
    }
    .borderRadius(4)
    .padding(0)
    .margin({ right: this.isNew ? 23 : 10, bottom: 10 })
    .backgroundColor($r('app.color.common_gray_bg'))
  }
}

export class FilterParams {
  // 排序：0 默认 难易 10 从易到难 11 从难道易  20 浏览量↑ 21 浏览量↓
  sort: number = 0
  // 排列顺序：0
  introduction: number = 0
  // 排序的类型
  sortType: number = 0
  // 阶段ID
  index: number = 0
}


@Component
export struct QuestionFilterComp {
  // controller: CustomDialogController
  @Prop
  questionTypeList: questionStructure[] = []
  @Prop
  params: FilterParams = new FilterParams()
  // onSubmit
  onSubmit: (params: FilterParams) => void = () => {
  }

  @Builder
  TitleBuilder(title: string) {
    Text(title)
      .padding({ top: 10, bottom: 10 })
      .fontSize(14)
      .fontWeight(500)
  }

  build() {
    Column() {
      Row() {
        Text('重置')
          .fontSize(16)
          .onClick(() => {
            this.params = new FilterParams()
          })
        Text('筛选题目')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Text('完成')
          .fontSize(16)
          .fontColor($r('app.color.common_main_color'))
          .onClick(() => {
            this.onSubmit(this.params)
            // this.controller.close()
          })
      }
      .width('100%')
      .height(50)

      this.TitleBuilder('题目排序')
      Flex() {
        FilterButton({ text: '默认', isActive: this.params.sortType === 0 })
          .onClick(() => {
            this.params.sort = 0
            this.params.sortType = 0
          })
        FilterButton({
          text: '难易度',
          isSort: true,
          isActive: this.params.sortType === 1,
          sortValue: this.params.introduction
        })
          .onClick(() => {
            if (this.params.sortType != 1) {
              this.params.sortType = 1
              this.params.introduction = 1
            }
            this.params.introduction = this.params.introduction === 1 ? 0 : 1
            this.params.sort = parseInt(`${this.params.sortType}${this.params.introduction}`)
            console.log("sort", this.params.sort)
          })
        FilterButton({
          text: '浏览量',
          isSort: true,
          isActive: this.params.sortType === 2,
          sortValue: this.params.introduction
        })
          .onClick(() => {
            if (this.params.sortType != 2) {
              this.params.sortType = 2
              this.params.introduction = 1
            }
            this.params.introduction = this.params.introduction === 0 ? 1 : 0
            this.params.sort = parseInt(`${this.params.sortType}${this.params.introduction}`)
            console.log("sort", this.params.sort)

          })
      }


      this.TitleBuilder('选择阶段')
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.questionTypeList, (item: QuestionTypeModel, index: number) => {
          FilterButton({ text: item.name, isNew: item.displayNewestFlag === 1, isActive: this.params.index === index })
            .onClick(() => this.params.index = index)
        })
      }

    }
    .backgroundColor(Color.White)
    .padding({ left: $r('app.float.common_space16'), right: $r('app.float.common_space16'), top: 10 })
    .width('100%')
    .height(420)
    .borderRadius({ topLeft: 16, topRight: 16 })
    .alignItems(HorizontalAlign.Start)
  }
}