/* Copyright 2020 Drewry Pope
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

let fs = require('fs');
let text2png = require('text2png');
let imageText = process.env.IMAGE_TEXT || 'Hello!\nPotato.'
fs.writeFileSync('out.png', text2png(imageText, {color: 'blue'}));
