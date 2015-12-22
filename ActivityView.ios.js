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
 * ActivityView has two function calls - `show`, and `showWithCallback`
 * Both require a shareObject
 *
 * The shareObject has the following properties:
 *
 * text: "Text you want to share" (string),
 * url: "URL you want to share" (string),
 * imageUrl: "Url of the image you want to share/action" (string),
 * image: "Name of the image in the app bundle" (string),
 * exclude: ["array", "of", "activities", "to", "exclude"] (array of strings)
 * anchor: React.findNodeHandle(this.refs.share) (number),
 *
 * The callback is of the form
 * function(activityType (string),
 *          completed (boolean),
 *          returnedItems (array),
 *          activityError (string)
 *         )
 *
 */

var ActivityView = {
  show: NativeActivityView.show,
  showWithCallback: NativeActivityView.showWithCallback
};

module.exports = ActivityView;
