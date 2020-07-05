// Author: Drewry Pope
/* Any copyright is dedicated to the Public Domain.
 * https://creativecommons.org/publicdomain/zero/1.0/ */

export async function sleep (ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}
