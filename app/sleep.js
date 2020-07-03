/* Any copyright is dedicated to the Public Domain.
 * https://creativecommons.org/publicdomain/zero/1.0/ */
const {sleep} = require('./modules/util');
const sleepSeconds = process.env.SLEEP_SECONDS || 10;
sleep(sleepSeconds * 1000);
