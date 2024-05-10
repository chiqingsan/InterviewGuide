import { emitter } from '@kit.BasicServicesKit'

@CustomDialog
export struct MyDialog {
  @State
  message: string = ''
  controller: CustomDialogController

  aboutToAppear(): void {
    emitter.on({ eventId: 133 }, (res) => {
      this.message = res.data!["process"]
    })
  }

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      LoadingProgress().width(30).height(30).color('#fff')
      if (this.message) {
        Text(this.message).fontSize((14)).fontColor('#fff')
      }
    }
    .width(150)
    .height(50)
    .padding(10)
    .backgroundColor('rgba(0,0,0,0.5)')
    .borderRadius(8)
  }
}