import { iLoginDataModel } from '../../models/UserData'
import { http } from '@kit.NetworkKit'
import { HdHttp } from '../utils/request';

export interface returnToTheModel {
  /**
   * 请求成功10000标志
   */
  code: number;

  /**
   * 返回数据
   */
  data: userClockData;

  /**
   * 请求成功
   */
  message: string;

  /**
   * 请求成功标志
   */
  success: boolean;
}

/**
 * 返回数据
 */
export interface userClockData {
  /**
   * 连续签到天数
   */
  clockinNumbers: number;

  /**
   * 当天是否签到
   */
  flag: boolean;

  /**
   * 累计签到天数
   */
  totalClockinNumber: number;
}


@Component
export struct HdClockIn {
  @Prop clockCount: number = 0
  @StorageProp("user") user: iLoginDataModel = {} as iLoginDataModel

  aboutToAppear(): void {
    // 获取用户的打卡数据
    // this.getClockData()
    this.clockCount = this.user.clockinNumbers
  }

  async getClockData() {
    const userClock = await HdHttp.get<userClockData>("clockinInfo")

    this.clockCount = userClock.data.clockinNumbers
  }

  build() {
    Stack({ alignContent: Alignment.End }) {
      Image(this.clockCount > 0 ? $r('app.media.clocked') : $r('app.media.unclock'))
        .objectFit(ImageFit.Fill)
      if (this.clockCount > 0) {
        Column() {
          Text('已连续打卡')
            .fontSize(8)
          Text() {
            Span(this.clockCount.toString())
              .fontWeight(600)
              .fontSize(12)
            Span(' 天')
              .fontSize(10)
          }
        }
        .width('50')
      } else {
        Text('打卡')
          .width('50')
          .textAlign(TextAlign.Center)
          .fontSize((18))
          .fontWeight(500)
          .fontColor('#333C4F')
          .margin({ bottom: (4) })
      }
    }
    .width(74)
    .height(28)
  }
}