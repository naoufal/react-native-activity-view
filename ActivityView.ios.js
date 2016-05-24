/**
 * @providesModule ActivityView
 * @flow
 */
'use strict';

const NativeActivityView = require('react-native').NativeModules.ActivityView;
module.exports = {
  show: NativeActivityView.show,
};
