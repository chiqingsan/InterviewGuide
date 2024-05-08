import { media } from '@kit.MediaKit'
import { request } from '@kit.BasicServicesKit'
import fs from '@ohos.file.fs'
import { Logger } from '../../common/utils/Logger'


@CustomDialog
export struct WordSoundDialog {
  controller: CustomDialogController
  wordEn: string = ''
  wordZh: string = ''
  @State
  loading: boolean = true
  @State
  isGreen: boolean = false
  timer: number = -1
  res: media.AVPlayer = Object()
  streamId: number = -1

  aboutToAppear() {
    // 当前单词在磁盘中如果存在，则直接播放，否则先下载再播放
    this.beforePlaySound()
  }

  // 播放mp3文件
  async play(fp: string) {
    const file = await fs.open(fp, fs.OpenMode.READ_ONLY)
    const uri = `fd://${file.fd}`
    media.createAVPlayer().then(res => {
      this.res = res
      res.url = uri
      res.on('stateChange', (state) => {
        if (state === 'idle') { // 成功调用reset接口后触发该状态机上报
          res.release()
        }
        if (state === 'initialized') { // avplayer 设置播放源后触发该状态上报
          res.prepare()
        }
        if (state === 'prepared') { // prepare()调用成功后上报该状态机,可以播放了
          res.loop = true
          res.play()
        }

        if (state === 'completed') { // 播放结束后触发该状态机上报，停止播放语音
          res.stop()
        }
        if (state === 'stopped') { // stop接口成功调用后触发该状态机上报，调用reset接口初始化avplayer状态
          res.reset()
        }
      })
    })
  }

  // 当前单词在磁盘中如果存在，则直接播放，否则先下载再播放
  async beforePlaySound() {
    try {
      const ctx = getContext()
      const dir = `${ctx.cacheDir}/word`
      const filePath = `${dir}/${this.wordEn}.mp3`
      // 如果没有word目录则创建word目录
      try {
        fs.statSync(dir)
      } catch (err) {
        Logger.error(JSON.stringify(err))
        fs.mkdirSync(dir)
      }
      // 如果word目录下没有当前要播放的单词mp3文件则下载后再播放
      try {
        fs.statSync(filePath)
        this.loading = false
        this.play(filePath)
      } catch (err) {
        Logger.error(JSON.stringify(err))
        const down = await request.downloadFile(ctx, {
          url: `https://dict.youdao.com/dictvoice?type=1&audio=${this.wordEn}`,
          filePath
        })
        down.on('complete', () => {
          this.loading = false
          // 播放
          this.play(filePath)
        })
      }
    } catch (err) {
      Logger.error(JSON.stringify(err))
    }
  }

  build() {
    Column({ space: 10 }) {
      if (!this.loading) {
        Row({ space: 10 }) {
          Text(this.wordEn)
            .fontSize(20)
            .fontColor(Color.White)
            .fontWeight(500)
          Image($r('sys.media.ohos_ic_public_sound'))
            .width(20)
            .aspectRatio(1)
            .fillColor(this.isGreen ? $r('app.color.common_green') : Color.White)
            .onAppear(() => {
              clearInterval(this.timer)
              this.timer = setInterval(() => {
                this.isGreen = !this.isGreen
              }, 500)
            })
            .onDisAppear(() => {
              clearInterval(this.timer)
              this.res.stop().then(() => {
                this.res.release()
              })
            })
            .animation({ duration: 300 })
        }

        Text(this.wordZh)
          .fontColor(Color.White)
      } else {
        LoadingProgress()
          .width(50)
          .aspectRatio(1)
          .color(Color.White)
      }
    }
    .constraintSize({ minWidth: 175 })
    .padding({ left: 25, right: 25, top: 30, bottom: 30 })
    // .height(90)
    .borderRadius(32)
    .backgroundColor('#82212121')
    .justifyContent(FlexAlign.Center)
  }
}