
'use strict';

import React, { Component } from 'react';
import PropTypes from 'prop-types';
import ReactNative, {
    requireNativeComponent,
    View,
    UIManager,
    DeviceEventEmitter
} from 'react-native';

export default class SignatureCapture extends Component {
    static propTypes = {
      ...View.propTypes,
        onDragEvent: PropTypes.func,
        strokeColor: PropTypes.string,
    }

    static defaultProps = {
        onDragEvent: () => {},
        strokeColor: 'black',
    }

    componentDidMount() {
        this.subscriptions = [];
        let sub = DeviceEventEmitter.addListener(
            'onDragEvent',
            this.props.onDragEvent
        );
        this.subscriptions.push(sub);
    }

    componentWillUnmount() {
        this.subscriptions.forEach(sub => sub.remove());
        this.subscriptions = [];
    }

    onChange = (event) => {
        if(event.nativeEvent.dragged){
            this.props.onDragEvent({
                dragged: event.nativeEvent.dragged
            });
        }
    }

    resetImage = () => {
        UIManager.dispatchViewManagerCommand(
            ReactNative.findNodeHandle(this),
            UIManager.RSSignatureView.Commands.resetImage,
            [],
        );
    }

    render() {
        return (
            <RSSignatureView
                {...this.props}
                onChange={this.onChange}
            />
        );
    }
}

var RSSignatureView = requireNativeComponent('RSSignatureView', SignatureCapture, {
    nativeOnly: { onChange: true }
});
