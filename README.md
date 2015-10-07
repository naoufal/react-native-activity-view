# React Native Activity View

[![npm version](https://img.shields.io/npm/v/react-native-activity-view.svg?style=flat-square)](https://www.npmjs.com/package/react-native-activity-view)
[![npm downloads](https://img.shields.io/npm/dm/react-native-activity-view.svg?style=flat-square)](https://www.npmjs.com/package/react-native-activity-view)
[![Code Climate](https://img.shields.io/codeclimate/github/naoufal/react-native-activity-view.svg?style=flat-square)](https://codeclimate.com/github/naoufal/react-native-activity-view)

React Native Activity View is a [React Native](https://facebook.github.io/react-native) library for displaying iOS share and action sheets.

![react-native-activity-view](https://cloud.githubusercontent.com/assets/1627824/8025905/795fc15c-0d33-11e5-8746-622417deccc3.gif)

## Documentation
- [Install](https://github.com/naoufal/react-native-activity-view#install)
- [Usage](https://github.com/naoufal/react-native-activity-view#usage)
- [Example](https://github.com/naoufal/react-native-activity-view#example)
- [Methods](https://github.com/naoufal/react-native-activity-view#methods)
- [License](https://github.com/naoufal/react-native-activity-view#license)

## Install
```shell
npm i --save react-native-activity-view
```

## Usage
### Linking the Library
In order to use Activity View, you must first link the library to your project.  There's excellent documentation on how to do this in the [React Native Docs](http://facebook.github.io/react-native/docs/linking-libraries-ios.html#content).

### Show the Activity View
Once you've linked the library, you'll want to make it available to your app by requiring it:

```js
var ActivityView = require('react-native-activity-view');
```

Showing the ActivityView is as simple as calling:
```js
ActivityView.show({
  text: "Text you want to share",
  url: "URL you want to share",
  imageUrl: "Url of the image you want to share/action",
  image: "Name of the image in the app bundle",
  exclude: ['postToFlickr'],
  anchor: React.findNodeHandle(this.refs.share), // Where you want the share popup to point to on iPad
});
```
#### Note: 
- Only provide one image type to the options argument.  If multiple image types are provided, `image` will be used.
- `anchor` is optional and only applicable for iPad. Popup will be centered by default if `anchor` is not provided.
- `exclude` is an array with activities you want to exclude from activity view. See [Apple's Documentation](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIActivity_Class/index.html#//apple_ref/doc/constant_group/Built_in_Activity_Types) on Built-in Activity Types for a full list of available values. **Note:** pass only camelcased activity name, e.g. in order to exclude `UIActivityTypePostToFlickr`, pass `postToFlickr` etc.

## Example
Using Activity View in your app will usually look like this:
```js
var ActivityView = require('react-native-activity-view');

var YourComponent = React.createClass({
  _pressHandler() {
    ActivityView.show({
      text: 'ActivityView for React Native',
      url: 'https://github.com/naoufal/react-native-activity-view',
      imageUrl: 'https://facebook.github.io/react/img/logo_og.png',
      anchor: React.findNodeHandle(this.refs.share),
    });
  },

  render() {
    return (
      <View>
        ...
        <TouchableHighlight
          onPress={this._pressHandler}
        />
          <Text ref="share">
            Share with Activity View
          </Text>
        </TouchableHighlight>
      </View>
    );
  }
});
```

## Methods
### show(shareObject)
Displays the Activity View with actions relevant to the `shareObject` passed.

__Arguments__
- `shareObject` - An _Object_ containing one or more of the following keys `text`, `url`, `anchor`, `exclude`, `imageUrl` or `image`.

__Examples__
```js
ActivityView.show({
  text: 'ActivityView for React Native',
  url: 'https://github.com/naoufal/react-native-activity-view',
  imageUrl: 'https://facebook.github.io/react/img/logo_og.png',
  exclude: ['postToFlickr', 'airDrop'],
  anchor: React.findNodeHandle(this.refs.share),
});
```

## License
Copyright (c) 2015, [Naoufal Kadhom](http://naoufal.com/)

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
