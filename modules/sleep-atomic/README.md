    Author: Drewry Pope
    Any copyright is dedicated to the Public Domain.
    https://creativecommons.org/publicdomain/zero/1.0/

Issues & PRs welcome!!

----

"usage" : "integers only, warning: NaN === 0"

    import sleep from 'sleep-atomic';
    const sleepSeconds = process.env.SLEEP_SECONDS || 10;
    sleep(sleepSeconds * 1000);

    import { sleep: sleepWithLog } from 'sleep-atomic';
    const sleepSeconds = process.env.SLEEP_SECONDS || 10;
    sleep(sleepSeconds * 1000);

`./server.js` is executable. Raise an issue if you'd like, I can enable global install & set logs behind a flag so no output for plain calls.

----

"functions" : "in case you'd like to copy paste, avoid the import."

    async function sleep (ms) {
        return new Promise(resolve => Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, ms));
    }

    async function sleepWithLog (ms) {
        console.log('{ "sleep" : { "parameters: [ { "ms" : "' + ms + '" } ] } }' );
        return new Promise(resolve => Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, ms));
    }

----

"import" : "index.js"

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

----

"run start" : "server.js"

    import { sleepWithLog } from 'sleep-atomic'
    import path from 'path';
    console.log('{ "app" : "' + path.basename(path.dirname(process.argv[1])) + '" } , "details" : { "directly-called": true } }');
    sleepWithLog((process.argv[2] || process.env.SLEEP_SECONDS || 10) * 1000);

----
