/* Copyright 2020 Drewry Pope
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */
import fs from 'fs';
import path from 'path';

import moveFile from 'move-file';
import text2png from 'text2png';
import { v1 as uuidv1, v4 as uuidv4, v5 as uuidv5 } from 'uuid'

export function text2pngFile (text, user, isoDateTime, uuidNSRootInput) {
    console.log('{ "text2pngFile" : { "parameters: [ { "text" : "' + text + '" }, { "user" : "' + user?user:'ERROR=UNDEFINED' + '" }, { "isoDateTime" : "' + isoDateTime + '" }, { "uuidNSRootInput" : "' + ((uuidNSRootInput && uuidNSRootInput.length >= 13) ? uuidNSRootInput.substring(9,13) : uuidNSRootInput ? uuidNSRootInput : 'ERROR=UNDEFINED') + '" } ] } }' );
    const uuidNSRoot = uuidNSRootInput || '13381dc1-fc4e-4b97-9bee-f04ddcc7fea1';
    user = user?user:process.env.USER?process.env.USER:'default user';
    text = text?text:process.env.TEXT?process.env.TEXT:'Hello!\nPotato';
    console.log('{ "text2pngFile" : { "parameters: [ { "text" : "' + text + '" }, { "user" : "' + user?user:'ERROR=UNDEFINED' + '" }, { "isoDateTime" : "' + isoDateTime + '" }, { "uuidNSRootInput" : "' + ((uuidNSRoot && uuidNSRoot.length >= 13) ? uuidNSRoot.substring(9,13) : uuidNSRoot ? uuidNSRoot : 'ERROR=UNDEFINED') + '" } ] } }' );

    const uuidNSUser = uuidv5('user', uuidNSRoot);
    const uuidNSTime = uuidv5('time', uuidNSRoot);
    console.log(user?user:"ERROR=UNDEFINED"+' '+uuidNSUser);
    const uuidUser = uuidv5(user, uuidNSUser);

    const uuidRunTime = uuidv5(isoDateTime, uuidNSTime);
    const uuidUserRunTime = uuidv5(uuidUser, uuidRunTime);

    const uuidIterationTimePlaintext = uuidv1();
    const uuidIterationTime = uuidv5(uuidIterationTimePlaintext, uuidNSTime);

    const uuidRandom = uuidv4();
    const output = 'data/out/'
    console.log(
        '{ "text2pngFile" : { "generated" : [ {"output" : "data/out/" ]' +
                isoDateTime + '_' +
                uuidRunTime + '.' +
                uuidUserRunTime + '.' +
                uuidIterationTime + '.' +
                uuidIterationTimePlaintext + '.' +
                uuidRandom + '.png"' +
                ', "text" : "' + text + '"' +
                ', "isoDateTime : "' + isoDateTime + '"' +
                ', "uuidRunTime" : "' + uuidRunTime + '"' +
                ', "uuidUserRunTime" : "' + uuidUserRunTime + '"' +
                ', "uuidIterationTime" : "' + uuidIterationTime + '"' +
                ', "uuidIterationTimePlaintext" : "' + uuidIterationTimePlaintext + '"' +
                ', "uuidRandom" : "' + uuidRandom + '"' +
                ' ] } }'
    );

    fs.writeFileSync(
        output +
                isoDateTime + '_' +
                uuidRunTime + '.' +
                uuidUserRunTime + '.' +
                uuidIterationTime + '.' +
                uuidRandom + '.' +
                uuidIterationTimePlaintext + '.' +
                'png',
        text2png(
            text,
            {
                color: 'blue'
            }
        )
    );
    // .then ( function () {
    //                 console.info('Create png complete.');
    //             });
};
export function parseToImage (err, input) {

    if (err) {
        console.log('{ "parseToImage" : { "parameters: [ { "err" : "' + err + '" } ] } }' );
        console.error(err);
    } else {
        console.log('{ "parseToImage" : { "parameters: [ { "input" : "' + input + '" } ] } }' );
        console.log(input);
        if (input.hasOwnProperty('items')) {
            if (Array.isArray(input.items)) {
                let results;
                try {
                    const isoDateTime = new Date().toISOString();
                        console.log(results);
                    results = input.items.map(function (item) {
                        console.log(item);
                        return text2pngFile(item.text.toLowerCase(), item.user, isoDateTime);
                    });
                    console.log(results);
                } catch (error) {
                    console.error(error);
                    console.error(results);
                    throw error;
                }
            }
        }
    }
};
export async function readJson (readPath, cb) {
    console.log('{ "readJson" : { "parameters: [ { "readPath" : "' + readPath + '" }, { "cb" : "' + cb + '" } ] } }' );
    fs.readFile(path.resolve(readPath), function (err, data) {
        if (err) {
            cb(err);
        } else {
            cb(null, JSON.parse(data));
        }
    });
};
export function appendForwardSlashToEndIfMissing (inputString) {
    console.log('{ "appendForwardSlashToEndIfMissing" : { "parameters: [ { "inputString" : "' + inputString + '" } ] } }' );
    let outputString = inputString;
    const lastChar = outputString.substr(-1); // Selects the last character
    if (lastChar != '/') {         // If the last character is not a slash
       outputString = outputString + '/';            // Append a slash to it.
    }
    return outputString;
};
export function json2pngMoveJson (fileName, inputDir, intermediateDir, outputDir) {
    console.log('{ "json2pngMoveJson" : { "parameters: [ { "fileName" : "' + fileName + '" }, { "inputDir" : "' + inputDir + '" }, { "intermediateDir" : "' + intermediateDir + '" }, { "outputDir" : "' + outputDir + '" } ] } }' );

    if (fileName.match(/^.*\.[Jj][Ss][Oo][Nn]$/)) {
        try
        {
            const inputFilePath = appendForwardSlashToEndIfMissing(inputDir) + fileName;

            if (inputDir === intermediateDir && inputDir === outputDir) {
                console.log('inputFilePath, intermediateFilePath, outputFilePath all match, skipping move-file.');
                readJson(inputFilePath, function (err, input) {

                    if (err) {
                        console.log('{ "readJsonCallback" : { "parameters: [ { "err" : "' + err + '" } ] } }' );
                        console.error(err);
                    } else {
                        console.log('{ "readJsonCallback" : { "parameters: [ { "input" : "' + input + '" } ] } }' );
                        if (input.hasOwnProperty('items')) {
                            if (Array.isArray(input.items)) {
                                let results;
                                try {
                                    const isoDateTime = new Date().toISOString();
                                    input.items.map(function (item) {
                                        item["output"]["filepath"] = outputDir;
                                        return item;
                                    });
                                    parseToImage(null, input);
                                    console.log(results);
                                } catch (error) {
                                    console.error(error);
                                    console.error(results);
                                    throw error;
                                }
                            }
                        }
                    }
                })
            } else {
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
            throw error;
        }
    } else {
        console.info('{ "invalidFile" : "' + fileName + '" }');
    }
};
export function json2pngPathSplit(filename, fileDir) {
    console.log('{ "json2pngPathSplit" : { "parameters: [ { "fileName" : "' + fileName + '" }, { "fileDir" : "' + fileDir + '" } ] } }' );
    json2pngMoveJson(filename, fileDir, fileDir, fileDir);
};
export function json2png (filePath) {
    console.log('{ "json2png" : { "parameters: [ { "filePath" : "' + filePath + '" } ] } }' );
    json2pngPathSplit(path.basename(filePath), path.dirname(filePath));
};
export function json2pngDirMoveJson (inputDir, intermediateDir, outputDir) {
    console.log('{ "json2pngMoveJson" : { "parameters: [ { "inputDir" : "' + inputDir + '" }, { "intermediateDir" : "' + intermediateDir + '" }, { "outputDir" : "' + outputDir + '" } ] } }' );
    fs.readdir(inputDir, function (err, list) {
        if (err) {
            console.error(err);
        }
        for (let i = 0; i < list.length; i += 1) {
            json2pngMoveJson(list[i], inputDir, intermediateDir, outputDir);
        }
    });
};
export function json2pngDir (dir) {
    json2pngDir(dir, dir, dir);
};
export { json2pngDir as default }
