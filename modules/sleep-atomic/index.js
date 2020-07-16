/* Author: Drewry Pope
 * Any copyright is dedicated to the Public Domain.
 * https://creativecommons.org/publicdomain/zero/1.0/ */
import path from 'path' ;
import process from 'process' ;
function coerceToInt(input) {
	const potentialNumber = Number.parseInt(input) ;
	return Number.isNaN(potentialNumber) ? 0 : potentialNumber ;
}
export default async function sleep (ms) {
    return new Promise(resolve => Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, coerceToInt(ms))) ;
}
export async function sleepWithLog (ms) {
	const finalMs = coerceToInt(ms) ;
    console.log('{ "app" : "' + path.basename(path.dirname(process.argv[1])) + '" } , "details" : { "sleep_milliseconds" : "' + finalMs + '" , "parameters": ' + JSON.stringify(process.argv) + ' } }' ) ;
    return sleep(finalMs) ;
}
