import { webview } from '@kit.ArkWeb'

@Entry
@Component
struct PreviewWebPage {
  webViewController: webview.WebviewController = new webview.WebviewController
  @StorageProp("topHeight") topHeight: number = 0

  build() {
    Navigation() {
      Web({
        src: $rawfile("PrivacyPolicy.html"),
        controller: this.webViewController
      })
    }
    .title("隐私政策")
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
  }
}