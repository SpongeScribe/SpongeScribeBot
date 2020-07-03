/* Any copyright is dedicated to the Public Domain.
 * https://creativecommons.org/publicdomain/zero/1.0/ */

let { sleep } = require('./modules/util');
let sleepSeconds = process.env.SLEEP_SECONDS || 10
sleep(sleepSeconds * 1000);
