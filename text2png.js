/* Copyright 2020 Drewry Pope
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

var fs = require('fs');
var text2png = require('text2png');
fs.writeFileSync('out.png', text2png('Hello! Potato.', {color: 'blue'}));