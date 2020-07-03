/* Any copyright is dedicated to the Public Domain.
 * https://creativecommons.org/publicdomain/zero/1.0/ */

module.exports = {
	sleep: async function(ms) {
		return new Promise(resolve => setTimeout(resolve, ms));
	}
}
