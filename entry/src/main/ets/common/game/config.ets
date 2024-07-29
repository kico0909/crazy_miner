export const UserDataPath = '__userdata__'
export const GameStatePath = '__gamedata__'
export const PersistentStoragePath = '__miner_storage__'

// 自动保存步长
export const AutoSaveStep = 5

// player Meditation(打坐) 配置
interface TMeditationConf {
  basePer: number // 基础触发率
  maxPer: number // 最高触发率
  onceTimeLen: number // 两次打坐间隔
}
export const Meditation: TMeditationConf = {
  basePer: 100,
  maxPer: 1000,
  onceTimeLen: 500
}

export const AttrToText: Map<string, string> = new Map([
  ["deep", "挖掘深度"],
  ["complatePer", "完成度"],
  ["strength", "精力"],
  ["intellect", "智力"],
  ["strong", "力量"],
  ["luck", "幸运"],
  ["exp", "经验"],
  ["level", "等级"],
  ["meditationPoint", "修炼值"]
])

export const Quality: Map<string, string> = new Map([
  ['1', '#FFB3B3B3'], // 灰色
  ['2', '#FFFFFFFF'], // 白色
  ['3', '#FF08E500'], // 绿色
  ['4', '#FF7DA5FF'], // 蓝色
  ['5', '#FFB453FF'], // 紫色
  ['6', '#FFFF921F'], // 橙色
])


