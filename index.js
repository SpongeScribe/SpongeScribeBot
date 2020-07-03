/* Copyright 2020 Drewry Pope
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

var fs = require('fs');
var text2png = require('text2png');
fs.writeFileSync('out.png', text2png(process.env.IMAGE_TEXT == null || process.env.IMAGE_TEXT == '' ? 'Hello! Potato.' : process.env.IMAGE_TEXT, {color: 'blue'}));
async function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
sleep(2000);
