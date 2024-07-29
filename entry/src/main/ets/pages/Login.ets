import { loginComponentManager, LoginWithHuaweiIDButton, authentication } from '@kit.AccountKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { util } from '@kit.ArkTS';

@Entry
@Component
struct Login {
  logTag: string = 'QuickLoginButtonComponent';
  domainId: number = 0x0000;
  /**
   * AnonymousPhoneNumber associated with the HUAWEI ID.
   */
  quickLoginAnonymousPhone: string = '';
  /**
   * Define the privacy text on LoginPanel.
   */
  privacyText: loginComponentManager.PrivacyText[] = [{
    text: '已阅读并同意',
    type: loginComponentManager.TextType.PLAIN_TEXT
  }, {
    text: '《用户服务协议》 ',
    tag: '用户服务协议',
    type: loginComponentManager.TextType.RICH_TEXT
  }, {
    text: '《隐私协议》',
    tag: '隐私协议',
    type: loginComponentManager.TextType.RICH_TEXT
  }, {
    text: '和',
    type: loginComponentManager.TextType.PLAIN_TEXT
  }, {
    text: '《华为帐号用户认证协议》',
    tag: '华为帐号用户认证协议',
    type: loginComponentManager.TextType.RICH_TEXT
  }];
  /**
   * Define the attributes of the area where other sign-in options are provided.
   */
  loginIconArray: loginComponentManager.LoginIcon[] = [
    // {
    //   icon: $r('app.media.app_icon'),
    //   tag: '其他方式登录1'
    // }, {
    //   icon: $r('app.media.app_icon'),
    //   tag: '其他方式登录2'
    // }, {
    //   icon: $r('app.media.app_icon'),
    //   tag: '其他方式登录3'
    // }
  ];
  /**
   * Defines the controller to interact with the button for login with a HUAWEI ID.
   */
  controller: loginComponentManager.LoginWithHuaweiIDButtonController =
    new loginComponentManager.LoginWithHuaweiIDButtonController()
      /**
       * After the user agrees to the agreement,
       * the developer must set the status of the agreement to ACCEPTED before logging in to the HUAWEI ID.
       */
      .setAgreementStatus(loginComponentManager.AgreementStatus.ACCEPTED)
      .onClickLoginWithHuaweiIDButton((error: BusinessError, response: loginComponentManager.HuaweiIDCredential) => {
        if (error) {
          hilog.error(this.domainId, this.logTag, 'error: ', error.code);
          return;
        }

        if (response) {
          hilog.info(this.domainId, this.logTag, 'onClickLoginWithHuaweiIDButton response success.');
          let authCode = response.authorizationCode;
          let openID = response.openID;
          let unionID = response.unionID;
          let idToken = response.idToken;
          return;
        }
      });

  build() {
    Scroll() {
      Column() {
        Column() {
          Column() {
            Image($r('app.media.app_icon'))
              .width(48)
              .height(48)
              .draggable(false)
              .copyOption(CopyOptions.None)
              .onComplete(() => {
                hilog.info(this.domainId, this.logTag, 'appIcon loading success');
              })
              .onError(() => {
                hilog.error(this.domainId, this.logTag, 'appIcon loading fail');
              })

            Text($r('app.string.app_name'))
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              .fontWeight(FontWeight.Medium)
              .fontWeight(FontWeight.Bold)
              .maxFontSize($r('sys.float.ohos_id_text_size_headline8'))
              .minFontSize($r('sys.float.ohos_id_text_size_body1'))
              .maxLines(1)
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .constraintSize({ maxWidth: '100%' })
              .margin({
                top: 12,
              })

            Text('应用描述')
              .fontSize($r('sys.float.ohos_id_text_size_body2'))
              .fontColor($r('sys.color.ohos_id_color_text_secondary'))
              .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
              .fontWeight(FontWeight.Regular)
              .constraintSize({ maxWidth: '100%' })
              .margin({
                top: 8,
              })
          }.margin({
            top: 100
          })

          Column() {
            Text(this.quickLoginAnonymousPhone)
              .fontSize(36)
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
              .fontWeight(FontWeight.Bold)
              .lineHeight(48)
              .textAlign(TextAlign.Center)
              .maxLines(1)
              .constraintSize({ maxWidth: '100%', minHeight: 48 })

            // Text('华为帐号绑定号码')
            //   .fontSize($r('sys.float.ohos_id_text_size_body2'))
            //   .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            //   .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
            //   .fontWeight(FontWeight.Regular)
            //   .lineHeight(19)
            //   .textAlign(TextAlign.Center)
            //   .maxLines(1)
            //   .constraintSize({ maxWidth: '100%' })
            //   .margin({
            //     top: 8
            //   })
          }.margin({
            top: 64
          })

          Column() {
            LoginWithHuaweiIDButton({
              params: {
                style: loginComponentManager.Style.BUTTON_RED,
                loginType: loginComponentManager.LoginType.QUICK_LOGIN,
                supportDarkMode: true,
              },
              controller: this.controller
            })
          }
          .height(40)
          .width('100%')
          .margin({
            top: 56
          })

          Column() {
            // Text('其他方式登录')
            //   .fontSize($r('sys.float.ohos_id_text_size_body3'))
            //   .fontColor($r('sys.color.ohos_id_color_text_tertiary'))
            //   .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
            //   .fontWeight(FontWeight.Regular)
            //   .textAlign(TextAlign.Center)
            //   .maxLines(1)
            //   .constraintSize({ maxWidth: '100%' })

            Row() {
              ForEach(this.loginIconArray, (item: loginComponentManager.LoginIcon, index: number) => {
                if (item.icon) {
                  Image(item.icon)
                    .draggable(false)
                    .focusable(true)
                    .focusOnTouch(true)
                    .copyOption(CopyOptions.None)
                    .width(36)
                    .height(36)
                    .borderRadius(18)
                    .clip(true)
                    .objectFit(ImageFit.Cover)
                    .margin({ left: (index == 0 ? 0 : 28) })
                    .onComplete(() => {
                      hilog.info(this.domainId, this.logTag, 'onComplete login icon ' + index);
                    })
                    .onError(() => {
                      hilog.info(this.domainId, this.logTag, 'onError login icon ' + index);
                    })
                    .onClick(() => {
                      hilog.info(this.domainId, this.logTag, "click icon tag " + item.tag);
                    })
                }
              })
            }.margin({ top: 12, left: 18, right: 18 })
          }.margin({
            top: 24
          })
        }

        Row() {
          Row() {
            Checkbox({ name: 'privacyCheckbox', group: 'privacyCheckboxGroup' })
              .width(24)
              .height(24)
              .focusable(true)
              .focusOnTouch(true)
              .margin({ top: 0 })
              .onChange((value: boolean) => {
                hilog.info(this.domainId, this.logTag, "agreementChecked " + value);
              })
          }

          Row() {
            Text() {
              ForEach(this.privacyText, (item: loginComponentManager.PrivacyText, index: number) => {
                if (item?.type == loginComponentManager.TextType.PLAIN_TEXT && item?.text) {
                  Span(item?.text)
                    .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                    .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
                    .fontWeight(FontWeight.Regular)
                    .fontSize($r('sys.float.ohos_id_text_size_body3'))
                } else if (item?.type == loginComponentManager.TextType.RICH_TEXT && item?.text) {
                  Span(item?.text)
                    .fontColor($r('sys.color.ohos_id_color_text_primary_activated'))
                    .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
                    .fontWeight(FontWeight.Medium)
                    .fontSize($r('sys.float.ohos_id_text_size_body3'))
                    .focusable(true)
                    .focusOnTouch(true)
                    .onClick(() => {
                      hilog.info(this.domainId, this.logTag, 'click privacy text tag:' + item.tag);
                    })
                }
              })
            }
            .width('100%')
          }
          .margin({ left: 12 })
          .layoutWeight(1)
          .constraintSize({ minHeight: 24 })
        }
        .alignItems(VerticalAlign.Top)
        .margin({
          bottom: 16
        })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .constraintSize({ minHeight: '100%' })
      .margin({
        left: 16,
        right: 16
      })
    }
    .width('100%')
    .height('100%')
  }

  aboutToAppear(): void {
    /**
     * Obtain the anonymous mobile phone number associated the HUAWEI ID.
     */
    this.getQuickLoginAnonymousPhone();
  }

  getQuickLoginAnonymousPhone() {
    /**
     * Creates an authorization request.
     */
    let authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest();
    /**
     * User information requested by the application.
     */
    authRequest.scopes = ['quickLoginAnonymousPhone'];
    authRequest.forceAuthorization = false;
    let controller = new authentication.AuthenticationController(getContext(this));
    try {
      controller.executeRequest(authRequest).then((response: authentication.AuthorizationWithHuaweiIDResponse) => {
        let anonymousPhone = response.data?.extraInfo?.quickLoginAnonymousPhone;
        if (anonymousPhone) {
          this.quickLoginAnonymousPhone = anonymousPhone as string;
          hilog.info(this.domainId, this.logTag, 'authorization success');
          return;
        }

        hilog.info(this.domainId, this.logTag, 'authorization success anonymousPhone is empty');
      }).catch((err: BusinessError) => {
        hilog.error(this.domainId, this.logTag, 'authorization fail: ' + err.code);
      })
    } catch (err) {
      hilog.error(this.domainId, this.logTag, 'authorization fail: ' + err.code);
    }
  }
}