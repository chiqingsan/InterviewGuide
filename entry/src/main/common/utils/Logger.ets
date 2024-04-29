import { hilog } from '@kit.PerformanceAnalysisKit'

const DOMAIN = 0x0000
const TAG = 'chiqingsan'
const FORMAT = '%{public}s %{public}s'

export class Logger {

  // 1. debug
  static debug (...args:string[]) {
    hilog.debug(DOMAIN, TAG, FORMAT, args)
  }

  // 2. info
  static info (...args:string[]) {
    hilog.info(DOMAIN, TAG, FORMAT, args)
  }

  // 3. warn
  static warn (...args:string[]) {
    hilog.warn(DOMAIN, TAG, FORMAT, args)
  }

  // 4. error
  static error (...args:string[]) {
    hilog.error(DOMAIN, TAG, FORMAT, args)
  }

}