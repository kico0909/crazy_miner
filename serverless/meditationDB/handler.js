// handler.js is a demo for handler function.

const db = require('./db/db.js');

// 云缓存
// let Redis = require('ioredis');
// let redisClient = new Redis({
//   port: Number(16380),
//   host: 'agcp-drcn.hispace.dbankcloud.cn',
//   username: '388421841222320551',
//   password: 'q1w2@E#R$',
//   enableReadyCheck: false,});

let getMeditationDB = function(event, context, callback, logger) {
   
  // send debug log
  logger.info("get mud crazy miner db: meditation");

  callback(db.meditation);
  
  // redisClient.get('meditation_db').then(ret => {
  //   callback(ret);
  // });
  
};

module.exports.getMeditationDB = getMeditationDB;