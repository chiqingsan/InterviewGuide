import { webview } from '@kit.ArkWeb'

@Entry
@Component
struct UserAgreement {
  webViewController: webview.WebviewController = new webview.WebviewController

  build() {
    Column() {
      Web({
        src: $rawfile("UserAgreement.html"),
        controller: this.webViewController
      })
    }
  }
}