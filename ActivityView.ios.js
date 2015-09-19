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
  show: (args) => {
    if (args.popoverSource) {
      args.popoverSource.measure((x, y, width, height, pageX, pageY) => {
        delete args.popoverSource;
        args.sourceFrame = {x: pageX, y: pageY, width, height};
        NativeActivityView.show(args);
      });
    } else {
      NativeActivityView.show(args);
    }
  }
};

module.exports = ActivityView;
