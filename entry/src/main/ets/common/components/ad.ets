import { advertising, AutoAdComponent } from '@kit.AdsKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
export struct AD {
  @State adParam: advertising.AdRequestParams = {
    // 广告类型：Banner广告
    adType: 8,
    // 'testw6vs28auh3'为测试专用的广告位ID，应用正式发布时需要改为正式的广告位ID
    adId: "testw6vs28auh3",
    // 广告位宽
    adWidth: 360,
    // 广告位高
    adHeight: 114
  };
  private adOptions: advertising.AdOptions = {
    // 是否允许流量下载0：不允许，1：允许，不设置以广告主设置为准
    allowMobileTraffic: 1,
    // 是否希望根据 COPPA 的规定将您的内容视为面向儿童的内容: -1默认值，不确定 0不希望 1希望
    tagForChildProtection: -1,
    // 是否希望按适合未达到法定承诺年龄的欧洲经济区 (EEA) 用户的方式处理该广告请求： -1默认值，不确定 0不希望 1希望
    tagForUnderAgeOfPromise: -1,
    // 设置广告内容分级上限: W: 3+,所有受众 PI: 7+,家长指导 J:12+,青少年 A: 16+/18+，成人受众
    adContentClassification: 'W'
  };
  private displayOptions: advertising.AdDisplayOptions = {
    // 广告轮播的时间间隔，单位ms，取值范围[30000, 120000]
    refreshTime: 30000
  }
  private ratio: number = 1;
  private adWidth: number = -1;
  private adHeight: number = -1;
  @State visibilityState: Visibility = Visibility.Visible;

  aboutToAppear() {
    if (this.adParam?.adWidth && typeof (this.adParam?.adWidth) == 'number' && this.adParam?.adWidth > 0) {
      this.adWidth = this.adParam?.adWidth;
    }
    if (this.adParam?.adHeight && typeof (this.adParam?.adHeight) == 'number' && this.adParam?.adHeight > 0) {
      this.adHeight = this.adParam?.adHeight;
    }
    if (this.adWidth > 0 && this.adHeight > 0) {
      this.ratio = this.adWidth / this.adHeight;
    }
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Row() {
        AutoAdComponent({
          adParam: this.adParam,
          adOptions: this.adOptions,
          displayOptions: this.displayOptions,
          interactionListener: {
            onStatusChanged: (status: string, ad: advertising.Advertisement, data: string) => {
              hilog.info(0x0000, 'testTag', '%{public}s', `status is ${status}`);
              console.warn('status - ad', status)
              switch (status) {
                case AdStatus.AD_OPEN:
                  hilog.info(0x0000, 'testTag', '%{public}s', `onAdOpen`);
                  break;
                case AdStatus.AD_CLICKED:
                  hilog.info(0x0000, 'testTag', '%{public}s', `onAdClick`);
                  break;
                case AdStatus.AD_CLOSED:
                  hilog.info(0x0000, 'testTag', '%{public}s', `onAdClose`);
                  this.visibilityState = Visibility.None;
                  break;
                case AdStatus.AD_LOAD:
                  hilog.info(0x0000, 'testTag', '%{public}s', `onAdLoad`);
                  break;
                case AdStatus.AD_FAIL:
                  hilog.error(0x0000, 'testTag', '%{public}s', `onAdFail`);
                  this.visibilityState = Visibility.None;
                  break;
              }
            }
          }
        })
      }
      .width('100%')
      .aspectRatio(this.ratio)
      .visibility(this.visibilityState)
      .backgroundColor('#000')
    }
  }
}

enum AdStatus {
  AD_LOAD = "onAdLoad",
  AD_FAIL = "onAdFail",
  AD_OPEN = "onAdOpen",
  AD_CLICKED = "onAdClick",
  AD_CLOSED = "onAdClose",
  AD_REWARDED = "onAdReward",
  AD_VIDEO_START = "onVideoPlayBegin",
  AD_COMPLETED = "onVideoPlayEnd"
}
