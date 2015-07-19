/**
 * @providesModule ActivityView
 * @flow
 */
'use strict';

var React = require('react-native');
var {
  NativeModules
} = React;

var NativeActivityView = NativeModules.ActivityView;
/* eslint-disable no-unused-vars */
var invariant = require('invariant');
/* eslint-enable no-unused-vars */

/**
 * High-level docs for the ActivityView iOS API can be written here.
 */

var ActivityView = {
  show: NativeActivityView.show
};

module.exports = ActivityView;
