import web_webview from '@ohos.web.webview'
import router from '@ohos.router'
import http from '@ohos.net.http'

@Entry
@Component
struct WebPage {
  private webController: web_webview.WebviewController = new web_webview.WebviewController();
  @State params: object = router.getParams()

  build() {
    Row() {
      Web({
        src: 'https://uland.taobao.com/sem/tbsearch?refpid=mm_26632360_8858797_29866178&keyword='+this.params?.['name']+'&clk1=6591503a1768d309110bd82b4edcc9ef&upsId=6591503a1768d309110bd82b4edcc9ef&spm=a2e0b.20350158.search.1&pid=mm_26632360_8858797_29866178&union_lens=recoveryid%3A201_33.61.21.33_1527369_1700308969426%3Bprepvid%3A201_33.63.246.42_1534872_1700309014442', // 默认加载 www.arkui.club 网址
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