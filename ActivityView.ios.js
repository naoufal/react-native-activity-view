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

/**
 * High-level docs for the ActivityView iOS API can be written here.
 */

var ActivityView = {
  show: NativeActivityView.show
};

module.exports = ActivityView;
