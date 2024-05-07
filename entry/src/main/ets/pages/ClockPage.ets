import { HmCalendar, HmCalendarSelectedDay } from '@ohmos/calendar'
import { promptAction } from '@kit.ArkUI'
import { router } from '@kit.ArkUI'
import { HdHttp } from '../common/utils/request'
import { iResponseModel } from '../models/UserData'
import { clockInData } from '../models/DateData'
import { Logger } from '../common/utils/Logger'
import { LoadingDialog } from '../common/components/CustomDialog'


interface DayBuilderParams {
  day: number
  text: string
}

export interface dateStructure {
  /**
   * 月份，不传值，默认查询当月的信息
   */
  month?: string;

  /**
   * 年份，不传默认当前年份
   */
  year?: string;
}


@Entry
@Component
export struct ClockPage {
  @State createAtList: HmCalendarSelectedDay[] = []
  @State totalClockinNumber: number = 0 //累计打卡
  @State clockinNumbers: number = 0 //连续打卡
  @StorageProp("topHeight") topHeight: number = 0
  dialog: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({ message: '加载中...' }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  // 累计打卡、连续打卡公共布局
  @Builder
  dayBuilder(params: DayBuilderParams) {
    Column() {
      Row() {
        Text(params.day.toString())
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
        Text('天')
          .fontSize(10)
          .fontColor($r('app.color.common_gray_01'))
          .margin({ bottom: 8, left: 10 })
      }
      .alignItems(VerticalAlign.Bottom)

      Text(params.text)
        .fontSize(10)
        .fontColor($r('app.color.common_gray_01'))
    }.margin({ right: 36 })
  }

  // 当页面显示的时候,请求当月的打卡数据,并且拿到累计打卡数据和连续打卡数据
  async aboutToAppear(): Promise<void> {
    const initialClockInData = await HdHttp.get<clockInData>("clockinInfo")

    // 累计打卡
    this.totalClockinNumber = initialClockInData.data.totalClockinNumber
    // 连续打卡
    this.clockinNumbers = initialClockInData.data.clockinNumbers

    // 当月打卡数据
    this.createAtList = initialClockInData.data.clockins.map((data) => {
      return { date: data.createdAt } as HmCalendarSelectedDay
    })

  }

  build() {
    Stack() {
      Image($r('app.media.clocked_bg'))
        .width("100%")

      Column({ space: 15 }) {

        Row({ space: 15 }) {
          Image($r("app.media.icon_left"))
            .width(20)
            .fillColor("#121826")
            .onClick(() => {
              router.back()
            })
          Text("每日打卡")
            .fontSize(24)
            .fontWeight(500)
            .fontColor("#121826")
        }.width("100%").height(50).padding({ left: 16 })

        Row({ space: 8 }) {
          Text("今日已打卡")
            .fontSize(20)
            .fontWeight(500)
            .fontColor("#121826")
          Image($r("app.media.ic_qiandao"))
            .width(20)
        }.width("100%").padding({ left: 16 })

        Row() {
          this.dayBuilder({ day: this.totalClockinNumber, text: '累计打卡' })
          this.dayBuilder({ day: this.clockinNumbers, text: '连续打卡' })
        }
        .padding({ top: 10, bottom: 10, left: 16, right: 16 })
        .width('100%')
        .justifyContent(FlexAlign.Start)

        Row() {
          HmCalendar({
            // selectedDays: [{ date: new Date().toLocaleDateString() }],
            selectedDays: this.createAtList,
            // 切换月份更新当前月份打卡数据
            onChangeMonth: async (yearmonth: string) => {
              // 打开加载弹窗
              this.dialog.open()
              promptAction.showToast({ message: yearmonth })
              const yearAndMonth: string[] = yearmonth.split("-")
              const dateData: dateStructure = {
                month: yearAndMonth[1],
                year: yearAndMonth[0]
              }
              const clockData = await HdHttp.get<clockInData>("clockinInfo", dateData)

              Logger.info("打卡", JSON.stringify(clockData))
              if (clockData.code === 10000) {
                Logger.info("打卡", "拿到数据,业务码正常")
                this.createAtList = clockData.data.clockins.map((data) => {
                  return { date: data.createdAt } as HmCalendarSelectedDay
                })
                // 关闭加载弹窗
                this.dialog.close()
              } else {
                Logger.error("打卡", "网络请求出现问题")
              }
            },
            // 点击当前日期触发 2024-01-24
            onClickDate: (currentDate: string) => {
              promptAction.showToast({ message: currentDate })
            }
          })
            .borderRadius(8)
            .border({ width: 0.5, color: '#ededed' })
            .shadow({ color: '#ededed', radius: 16 })
            .linearGradient({
              angle: 210,
              colors: [["#88ffffff", 0], ["#ddffffff", 0.3], ["#ffffff", 1]]
            })
        }
        .padding({ left: 16, right: 16 })

      }
      .width('100%')
      .height('100%')
      .padding({ top: this.topHeight })

    }
    .alignContent(Alignment.Top)

  }
}