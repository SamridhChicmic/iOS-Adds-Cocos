import { _decorator, Component, native, Node } from "cc";
const { ccclass, property } = _decorator;

@ccclass("Clicks")
export class Clicks extends Component {
  start() {}
  onClickButtonInterstitial() {
    console.log("Interstitial BUTTON CLICKED");
    native.reflection.callStaticMethod(
      "AppDelegate",
      "callInterstitialNativeUIWithTitle:andContent:",
      "cocos2d-js",
      "Yes! you call a Native UI from Reflection"
    );
  }
  onClickButtonBanner() {
    console.log("Banner BUTTON CLICKED");
    native.reflection.callStaticMethod(
      "AppDelegate",
      "callBannerNativeUIWithTitle:andContent:",
      "cocos2d-js",
      "Yes! you call a Native UI from Reflection"
    );
  }
  onClickButtonReward() {
    console.log("Reward BUTTON CLICKED");
    native.reflection.callStaticMethod(
      "AppDelegate",
      "callRewardNativeUIWithTitle:andContent:",
      "cocos2d-js",
      "Yes! you call a Native UI from Reflection"
    );
  }
  update(deltaTime: number) {}
}
