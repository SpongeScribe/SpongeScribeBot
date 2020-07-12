```
/* Author: Drewry Pope
 * Any copyright is dedicated to the Public Domain.
 * https://creativecommons.org/publicdomain/zero/1.0/ */
export default async function sleep (ms) {
    return new Promise(resolve => Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, ms));
}
export default async function sleepWithLog (ms) {
    console.log('{ "sleep" : { "parameters: [ { "ms" : "' + ms + '" } ] } }' );
    return new Promise(resolve => Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, ms));
}
```
