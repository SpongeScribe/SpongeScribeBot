/* Author: Drewry Pope
 * Any copyright is dedicated to the Public Domain.
 * https://creativecommons.org/publicdomain/zero/1.0/ */
import { sleepWithLog as sleep } from './index.js';
const sleepSeconds = process.argv[2] || process.env.SLEEP_SECONDS || 2;
console.log("it (json log) _SHOULD NOT_ contain property:value ['directly-called' : true]");
sleep(sleepSeconds * 1000);
console.log("it (json log) _SHOULD_ contain property:value ['directly-called' : true]");
import childProcess from 'child_process';
childProcess.fork('index.js');
