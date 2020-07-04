/* Copyright 2020 Drewry Pope
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */
const parseToImage = function (err, input) {
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
};
const readJson = function (path, cb) {
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
const fs = require('fs');
fs.readdir('./data/in/', function (err, list) {
    'use strict';
    if (err) {
        console.error(err);
    }
    var i;
    for (i = 0; i < list.length; i += 1) {
        const filename = list[i];
        if (filename.match(/^.*\.json$/)) {
            try {
                const moveFile = require('move-file');
                const originalPath = './data/in/' + filename;
                const intermediatePath = './data/' + filename;
                const finalPath = './data/out/' + filename;
                console.log('{ "moveFile" : { "originalPath" : "' + originalPath + '", "intermediatePath" : "' + intermediatePath + '", "finalPath" : "' + finalPath + '" } }' );

                moveFile(originalPath, intermediatePath).then( function () {
                    console.log('intermediate move complete, beginning read.');
                    readJson(intermediatePath, parseToImage);
                }).then ( function () {
                    console.log('read complete, beginning final move.');
                    return moveFile(intermediatePath, finalPath);
                }).then ( function () {
                    console.log('final move complete, job complete.');
                });
            } catch (error) {
                console.error(error);
            }
        } else {
            console.log("Filename does not match regex. '/^.*\.json$/' ");
            console.log('{ "filename" : "' + filename + '" }');
        }
    }
});
