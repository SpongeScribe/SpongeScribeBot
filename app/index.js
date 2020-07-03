/* Copyright 2020 Drewry Pope
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */
var readJson = function (path, cb) {
    'use strict';
    const fs = require('fs');
    fs.readFile(require.resolve(path), function (err, data) {
        if (err) {
            cb(err);
        } else {
            cb(null, JSON.parse(data));
        }
    });
};
readJson('./in/input.json', function (err, input) {
    'use strict';
    if (err) {
        console.error(err);
    } else {
        console.log(input);
        if (input.hasOwnProperty('items')) {
            if (Array.isArray(input.items)) {
                var results;
                try {
                    const {text2png: text2png} = require('./modules/image-generation');
                    const isoDateTime = new Date().toISOString();
                    // const unescapeJs = require('unescape-js');
                    // const imageText = unescapeJs(process.env.IMAGE_TEXT || 'Hello!\nPotato.');
                    results = input.items.map(function (item) {
                        return text2png(item.imageText.toLowerCase(), item.user, isoDateTime);
                    });
                    console.log(results);
                } catch (error) {
                    console.error(error);
                    console.error(results);
                }
            } else {
                console.error("ERROR. Invalid JSON.");
                console.error(input);
            }
        }
    }
});
