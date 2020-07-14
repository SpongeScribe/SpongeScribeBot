#!/usr/bin/env node
/* Author: Drewry Pope
 * Any copyright is dedicated to the Public Domain.
 * https://creativecommons.org/publicdomain/zero/1.0/ */
import process from 'process';
import path from 'path';
import { fileURLToPath } from 'url'; // only needed for direct call check, can skip if copying code
export default async function sleep (ms) {
    return new Promise(resolve => Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, ms));
}
async function logSignatureDetails (ms) {
    console.log('{ "app" : "' + path.basename(path.dirname(process.argv[1])) + '" } , "details" : { "sleep_milliseconds" : "' + ms + '" , "parameters": ' + JSON.stringify(process.argv) + ' } }' );
}
export async function sleepWithLog (ms) {
    logSignatureDetails(ms);
    return new Promise(resolve => Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, ms));
}
async function logDirectCalls () {
	console.log('{ "app" : "' + path.basename(path.dirname(process.argv[1])) + '" } , "details" : { "directly-called": true } }');
}
const directCall = path.basename(process.argv[1], ".js") === path.basename(fileURLToPath(import.meta.url), ".js")
if (directCall) {
    logDirectCalls();
	const sleepSeconds = process.argv[2] || process.env.SLEEP_SECONDS || 10;
	sleepWithLog(sleepSeconds * 1000);
}
