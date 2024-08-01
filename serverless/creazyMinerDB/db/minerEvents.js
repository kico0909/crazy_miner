const DB = [

// 基础默认事件
  {
    type: 'default',
    textTemplate: '你向下挖了一搞',
    quality: 1,
    probability: 300,
  },
  {
    type: 'default',
    textTemplate: '你不情愿的向下挖了一镐',
    quality: 1,
    probability: 50,
  },
  {
    type: 'default',
    textTemplate: '你费劲的向下挖了一镐',
    quality: 1,
    probability: 50,
  },

  // 普通事件
  {
    type: 'normal',
    textTemplate: '你使劲向下挖了一铲子土',
    quality: 2,
    probability: 200,
    effect: 'exp:3'
  },
  {
    type: 'normal',
    textTemplate: '你疯狂的向下挖了一铲子土',
    quality: 2,
    probability: 100,
    effect: 'exp:5'
  },
  {
    type: 'normal',
    textTemplate: '你经过不断挖掘,感觉浑身充满力量',
    quality: 2,
    probability: 100,
    effect: 'strong:1'
  },
  {
    type: 'normal',
    textTemplate: '你挖掘时不小心撞到了洞壁,脑袋一痛',
    quality: 2,
    probability: 100,
    effect: 'intellect:1'
  },
  {
    type: 'normal',
    textTemplate: '你不小心挖到了空洞,掉下去了',
    quality: 3,
    probability: 100,
    effect: 'deep:1'
  }
]
module.exports.DB = DB;