import web_webview from '@ohos.web.webview'
import router from '@ohos.router'
import http from '@ohos.net.http'

@Entry
@Component
struct WebPage_jing {
  private webController: web_webview.WebviewController = new web_webview.WebviewController();
  @State params: object = router.getParams()

  build() {
    Row() {
      Web({
        src:'https://search.jd.com/Search?keyword='+this.params?.['name']+'&enc=utf-8&wq='+this.params?.['name']+'&pvid=3c160687d0514693bdb6a0f47cf41b0f',
        controller: this.webController
      })
        .width("100%")
        .height("100%")
        .wideViewModeAccess(true)
        .textZoomRatio(150)
    }
    .height('100%')
  }
}