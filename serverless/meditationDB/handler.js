/**
 * Describe the basic method of Cloud Functions
 */

const express = require('express');
const log4js = require("log4js");
const app = express();

// 云缓存
const Redis = require('ioredis');

let logConfig = {
    replaceConsole: true,
    appenders: {
        'out': {
            type: 'stdout',
            layout: {
                type: "colored"
            }
        },
        'files': {
            type: 'file',
            filename: '/opt/huawei/logs/logs.log'
        }
    },
    categories: {
        default: {
            appenders: ['out', 'files'],
            level: "INFO"
        }
    },
    disableClustering: true
}
log4js.configure(logConfig);
const logger = log4js.getLogger('CUSTOM-RUNTIME-NODEJS-MUDCrazyMinerMeditationDB-LOG');

const redisClient = new Redis({
    port: Number(16380),
    host: 'agcp-drcn.hispace.dbankcloud.cn',
    username: '388421841222320551',
    password: 'q1w2@E#R$',
    enableReadyCheck: false,});

app.post('/invoke', function (req, res) {

    logger.info("Test info log");
    logger.warn("Test warn log");
    logger.debug("Test debug log");
    logger.error("Test error log");
    //
    // const db = [
    // {
    //     msg: '突然好运缠身',
    //     effect: 'luck:1-2',
    //     probability: 5,
    //     quality: 4
    // },
    // {
    //     msg: '感觉变强壮了',
    //     effect: 'strong:1-3',
    //     probability: 10,
    //     quality: 3
    // },
    // {
    //     msg: '一瞬间头脑通明',
    //     effect: 'intellect:1-3',
    //     probability: 10,
    //     quality: 3
    // },
    // {
    //     msg: '打了鸡血',
    //     effect: 'strength:1-3',
    //     probability: 10,
    //     quality: 3
    // },
    // {
    //     msg: '吸收了矿洞中污秽的气息',
    //     effect: 'exp:3-5',
    //     probability: 20,
    //     quality: 3
    // }
    // ]

    let res = new context.HTTPResponse({}, {
        "res-type": "mud_crazy_miner meditation_db",
        "faas-content-type": "json"
    }, "application/json", "200");
    let ret = await redisClient.get('meditation_db');
    logger.info("redis get name result:" + ret);

    //send response
    callback(res);
  logger.info("--------End-------");
  // res.send(JSON.stringify(db));
});

app.listen(9000, function () {
    logger.info("---------server start now!-------");
});