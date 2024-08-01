// handler.js is a demo for handler function.

// 修炼事件DB
const meditations = require('./db/meditation.js');
// 挖矿事件DB
const minerEvents = require('./db/minerEvents.js');
// 地图DB
const maps = require('./db/maps.js');
// 品质
const quality = require('./db/quality.js');
// 游戏系统配置
const config = require('./db/config.js');

// 云缓存
// let Redis = require('ioredis');
// let redisClient = new Redis({
//   port: Number(16380),
//   host: 'agcp-drcn.hispace.dbankcloud.cn',
//   username: '388421841222320551',
//   password: 'q1w2@E#R$',
//   enableReadyCheck: false,});

function getDB(event, context, callback, logger) {
   
  // send debug log
  logger.info("get mud crazy miner db");

  const db = {
    config: config.DB, // 游戏配置
    meditations: meditations.DB, // 修炼事件
    minerEvents: minerEvents.DB, // 挖矿事件
    maps: maps.DB, // 地图
    quality: quality.DB, // 品质颜色
  }
  callback(JSON.stringify(db));
};

module.exports.myHandler = getDB;