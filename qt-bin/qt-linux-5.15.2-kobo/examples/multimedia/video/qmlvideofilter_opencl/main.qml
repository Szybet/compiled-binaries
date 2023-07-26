/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Multimedia module.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtMultimedia 5.5
import qmlvideofilter.cl.test 1.0

Item {
    width: 1024
    height: 768

    Camera {
        id: camera
    }

    MediaPlayer {
        id: player
        autoPlay: true
        source: videoFilename
    }

    VideoOutput {
        id: output
        source: videoFilename !== "" ? player : camera
        filters: [ infofilter, clfilter ]
        anchors.fill: parent
    }

    CLFilter {
        id: clfilter
        // Animate a property which is passed to the OpenCL kernel.
        SequentialAnimation on factor {
            loops: Animation.Infinite
            NumberAnimation {
                from: 1
                to: 20
                duration: 6000
            }
            NumberAnimation {
                from: 20
                to: 1
                duration: 3000
            }
        }
    }

    InfoFilter {
        // This filter does not change the image. Instead, it provides some results calculated from the frame.
        id: infofilter
        onFinished: {
            info.res = result.frameResolution.width + "x" + result.frameResolution.height;
            info.type = result.handleType;
            info.fmt = result.pixelFormat;
        }
    }

    Column {
        Text {
            font.pointSize: 20
            color: "green"
            text: "Transformed with OpenCL on GPU\nClick to disable and enable the emboss filter"
        }
        Text {
            font.pointSize: 12
            color: "green"
            text: "Emboss factor " + Math.round(clfilter.factor)
            visible: clfilter.active
        }
        Text {
            id: info
            font.pointSize: 12
            color: "green"
            property string res
            property string type
            property int fmt
            text: "Input resolution: " + res + " Input frame type: " + type + (fmt ? " Pixel format: " + fmt : "")
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: clfilter.active = !clfilter.active
    }
}
