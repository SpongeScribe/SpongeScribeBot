/* Copyright 2020 Drewry Pope
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */
import * as uuid from 'uuid/v4';
import { readdir } from 'fs';

export function text2png (imageText, user, isoDateTime, uuidNSRootInput) {
    'use strict';
    const uuidNSRoot = uuidNSRootInput || '13381dc1-fc4e-4b97-9bee-f04ddcc7fea1';

    const fs = require('fs');
    const text2pngOriginal = require('text2png');


    const userName = user || process.env.UUID_USER_NAME || 'default user';
    const uuidNSUser = uuidv5('user', uuidNSRoot);
    const uuidNSTime = uuidv5('time', uuidNSRoot);

    const uuidUser = uuidv5(userName, uuidNSUser);

    const uuidRunTime = uuidv5(isoDateTime, uuidNSTime);
    const uuidUserRunTime = uuidv5(uuidUser, uuidRunTime);

    const uuidIterationTimePlaintext = uuidv1();
    const uuidIterationTime = uuidv5(uuidIterationTimePlaintext, uuidNSTime);

    const uuidRandom = uuidv4();

    console.log(
        '{ "output" : "data/out/' +
                isoDateTime + '_' +
                uuidRunTime + '.' +
                uuidUserRunTime + '.' +
                uuidIterationTime + '.' +
                uuidIterationTimePlaintext + '.' +
                uuidRandom + '.png"' +
                ', "imageText" : "' + imageText + '"' +
                ', "isoDateTime : "' + isoDateTime + '"' +
                ', "uuidRunTime" : "' + uuidRunTime + '"' +
                ', "uuidUserRunTime" : "' + uuidUserRunTime + '"' +
                ', "uuidIterationTime" : "' + uuidIterationTime + '"' +
                ', "uuidIterationTimePlaintext" : "' + uuidIterationTimePlaintext + '"' +
                ', "uuidRandom" : "' + uuidRandom + '"' +
                ' }'
    );

    fs.writeFileSync(
        'data/out/' +
                isoDateTime + '_' +
                uuidRunTime + '.' +
                uuidUserRunTime + '.' +
                uuidIterationTime + '.' +
                uuidRandom + '.' +
                uuidIterationTimePlaintext + '.' +
                'png',
        text2png(
            imageText,
            {
                color: 'blue'
            }
        )
    );
};
export function readJson (path, cb) {
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
export function parseToImage (err, input) {
    'use strict';
    if (err) {
        console.error(err);
    } else {
        console.log(input);
        if (input.hasOwnProperty('items')) {
            if (Array.isArray(input.items)) {
                var results;
                try {
                    const isoDateTime = new Date().toISOString();
                    results = input.items.map(function (item) {
                        return text2png(item.imageText.toLowerCase(), item.user, isoDateTime);
                    });
                    console.log(results);
                } catch (error) {
                    console.error(error);
                    console.error(results);
                }
            }
        }
    }
};
export function appendForwardSlashToEndIfMissing (inputString) {
    let outputString = inputString;
    const lastChar = outputString.substr(-1); // Selects the last character
    if (lastChar != '/') {         // If the last character is not a slash
       outputString = outputString + '/';            // Append a slash to it.
    }
    return outputString;
};
export function json2PngMoveJson (fileName, inputDir, intermediateDir, outputDir) {
    console.log('{ "jsonDir2png.parameters" : [ { "fileName" : "' + fileName + '" }, { "intermediateFilePath" : "' + inputDir + '" }, { "intermediateDir" : "' + intermediateDir + '" }, { "outputDir" : "' + outputDir + '" } ] }' );

    if (fileName.match(/^.*\.[Jj][Ss][Oo][Nn]$/)) {
        try {
            const inputFilePath = appendForwardSlashToEndIfMissing(inputDir) + fileName;

            if (inputDir === intermediateDir && inputDir === outputDir) {
                console.log('inputFilePath, intermediateFilePath, outputFilePath all match, skipping move-file.');
                readJson(inputFilePath, parseToImage);
            } else {
                const moveFile = require('move-file');
                const intermediateFilePath = appendForwardSlashToEndIfMissing(intermediateDir) + fileName;
                const outputFilePath = appendForwardSlashToEndIfMissing(outputDir) + fileName;

                moveFile(inputFilePath, intermediateFilePath).then( function () {
                    console.info('Intermediate move complete, beginning read.');
                    readJson(intermediateFilePath, parseToImage);
                }).then ( function () {
                    console.info('Read complete, beginning final move.');
                    return moveFile(intermediateFilePath, outputFilePath);
                }).then ( function () {
                    console.info('Final move complete, job complete.');
                });
            }
        } catch (error) {
            console.error(error);
        }
    } else {
        console.info('{ "invalidFile" : "' + fileName + '" }');
    }
};
export function json2pngPathSplit(filename, fileDir) {
    json2PngMoveJson(filename, fileDir, fileDir, fileDir);
};
export function json2png (filePath) {
    const path = require('path');
    json2pngPathSplit(path.basename(filePath), path.dirname(filePath));
};
export function jsonDir2pngMoveJson (inputDir, intermediateDir, outputDir) {
    'use strict';
    readdir(inputDir, function (err, list) {
        'use strict';
        if (err) {
            console.error(err);
        }
        var i;
        for (i = 0; i < list.length; i += 1) {
            json2PngMoveJson(list[i], inputDir, intermediateDir, outputDir);
        }
    });
};
export function jsonDir2png (dir) {
    jsonDir2png(dir, dir, dir);
};
export { jsonDir2png as default }
