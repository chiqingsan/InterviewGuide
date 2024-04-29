import { webview } from '@kit.ArkWeb'

@Entry
@Component
struct PreviewWebPage {
  webViewController: webview.WebviewController = new webview.WebviewController

  build() {
    Column() {
      Web({
        src: $rawfile("PrivacyPolicy.html"),
        controller: this.webViewController
      })
    }
  }
}