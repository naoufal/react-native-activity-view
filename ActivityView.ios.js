/**
 * @providesModule ActivityView
 * @flow
 */
'use strict';

var NativeActivityView = require('NativeModules').ActivityView;
var invariant = require('invariant');

/**
 * High-level docs for the ActivityView iOS API can be written here.
 */

var ActivityView = {
  show: NativeActivityView.show
};

module.exports = ActivityView;
