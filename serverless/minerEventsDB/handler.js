// handler.js is a demo for handler function.

const db = require('./db/db.js');

let getMinerEventsDB = function(event, context, callback, logger) {
   
  // send debug log
  logger.info("get mud crazy miner db: miner events");

  callback(db.minerEvents);
};

module.exports.getMinerEventsDB = getMinerEventsDB;