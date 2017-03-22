'use strict';
import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  TouchableHighlight,
  View
} from 'react-native';

import ActivityView from './node_modules/react-native-activity-view';

class ActivityViewExample extends Component {
  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          react-native-activity-view
        </Text>

        <Text style={styles.instructions}>
          github.com/naoufal/react-native-activity-view
        </Text>
        <TouchableHighlight
          style={styles.btn}
          onPress={this._clickHandler}
          underlayColor="#0380BE"
          activeOpacity={1}
        >
          <Text style={{
            color: '#fff',
            fontWeight: '600'
          }}>
            Display Activity View
          </Text>
        </TouchableHighlight>
      </View>
    );
  }

  _clickHandler() {
    ActivityView.show({
      text: 'ActivityView for React Native',
      url: 'https://github.com/naoufal/react-native-activity-view',
      imageUrl: 'https://facebook.github.io/react/img/logo_og.png'
    });
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF'
  },
  welcome: {
    margin: 10,
    fontSize: 20,
    fontWeight: '600',
    textAlign: 'center'
  },
  instructions: {
    marginBottom: 5,
    color: '#333333',
    fontSize: 13,
    textAlign: 'center'
  },
  btn: {
    borderRadius: 3,
    marginTop: 200,
    paddingTop: 15,
    paddingBottom: 15,
    paddingLeft: 15,
    paddingRight: 15,
    backgroundColor: '#0391D7'
  }
});

AppRegistry.registerComponent('ActivityViewExample', () => ActivityViewExample);
