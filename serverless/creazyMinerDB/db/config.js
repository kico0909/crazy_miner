/**
 * 游戏基础配置
 */
const DB = {
  meditation: { // 修炼配置
    basePer: 100, // 基础修炼成功值
    maxPer: 1000, // 最大修炼成功值
    onceTimeLen: 300, // 修炼间隔时间(毫秒)
  }
}

module.exports.DB = DB;