import { webview } from '@kit.ArkWeb'

@Entry
@Component
struct UserAgreement {
  webViewController: webview.WebviewController = new webview.WebviewController
  @StorageProp("topHeight") topHeight:number = 0

  build() {
    Navigation() {
      Web({
        src: $rawfile("UserAgreement.html"),
        controller: this.webViewController
      })
    }
    .title("用户协议")
    .titleMode(NavigationTitleMode.Mini)
    .padding({top:this.topHeight})
  }
}