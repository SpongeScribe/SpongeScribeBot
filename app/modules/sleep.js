/* Author: Drewry Pope
 * Any copyright is dedicated to the Public Domain.
 * https://creativecommons.org/publicdomain/zero/1.0/ */
export default async function sleep (ms) {
    console.log('{ "sleep" : { "parameters: [ { "ms" : "' + ms + '" } ] } }' );
    return new Promise(resolve => setTimeout(resolve, ms));
}
