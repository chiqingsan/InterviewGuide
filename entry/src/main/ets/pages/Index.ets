import { hilog } from '@kit.PerformanceAnalysisKit';
import { Logger } from '../../common/utils/Logger';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column({space:10}) {
        Button("hilog debug").onClick(() => {
          Logger.debug("index","debug")
        })
        Button("hilog info").onClick(() => {
          hilog.info(0x0001, "chiqingsan", "%{public}s %{public}s", "info")
        })
        Button("hilog warn").onClick(() => {
          hilog.warn(0x0001, "chiqingsan", "%{public}s %{public}s", "warn")
        })
        Button("hilog error").onClick(() => {
          hilog.error(0x0001, "chiqingsan", "%{public}s %{public}s", "error")
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}