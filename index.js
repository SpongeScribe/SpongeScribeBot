/* Copyright 2020 Drewry Pope
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

var fs = require('fs');
var text2png = require('./node_modules/text2png');
fs.writeFileSync('out.png', text2png('Hello! Potato.', {color: 'blue'}));
async function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
sleep(2000);
