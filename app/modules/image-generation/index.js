/* Any copyright is dedicated to the Public Domain.
 * https://creativecommons.org/publicdomain/zero/1.0/ */

module.exports = {
    text2png: function (imageText, user, isoDateTime, uuidNSRootInput) {
        'use strict';
        const uuidNSRoot = uuidNSRootInput || '13381dc1-fc4e-4b97-9bee-f04ddcc7fea1';

        const fs = require('fs');
        const text2png = require('text2png');
        const {v1: uuidv1, v4: uuidv4, v5: uuidv5} = require('uuid');

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

    }
};
