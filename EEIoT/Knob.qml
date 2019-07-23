import QtQuick 2.0

Item {
    id: knob
    transformOrigin: Item.Center

    property var metaData : ["from", "to", "value", "reverse", "fromAngle", "toAngle", "lineWidth", "fontSize", "knobBackgroundColor", "knobColor"]

    //value parameters
    property double from:0
    property double value: 1
    property double to: 100

    //progress from right to left
    property bool reverse: false

    //progress circle angle
    property double fromAngle: Math.PI - 1
    property double toAngle: Math.PI *2 + 1

    property int lineWidth: width / 10
    property int fontSize: width / 7

    property color knobBackgroundColor: Qt.rgba(0.1, 0.1, 0.1, 0.1)
    property color knobColor: Qt.rgba(1, 0, 0, 1)

    function update(value) {
        knob.value = value
        canvas.requestPaint()
        label.text = value.toFixed(2);
        label.anchors.horizontalCenter = knob.horizontalCenter
        label.anchors.verticalCenter = knob.verticalCenter
        label.transformOrigin = Item.Center
        label.anchors.centerIn = knob.anchors.centerIn
    }

    Text {
        id: label
        width: 40
        height: 12
        font.bold: true
        z: 1
        font.pointSize: knob.fontSize
        text: knob.value.toFixed(2)
        horizontalAlignment: Text.AlignHCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Canvas {
        id: background
        width: parent.width
        height: parent.height
        antialiasing: true

        property int radius: background.width/2

        onPaint: {
            var ctx = background.getContext('2d');
            ctx.strokeStyle = knob.knobBackgroundColor;
            ctx.lineWidth = knob.lineWidth;
            ctx.lineCap = "round"
            ctx.beginPath();
            ctx.clearRect(0, 0, background.width, background.height);
            ctx.arc(radius, radius, radius - knob.lineWidth, knob.fromAngle, knob.toAngle, false);
            ctx.stroke();
        }
    }

    Canvas {
        id:canvas
        width: parent.width
        height: parent.height
        antialiasing: true

        property double step: knob.value / (knob.to - knob.from) * (knob.toAngle - knob.fromAngle)
        property int radius: width/2

        onPaint: {
            var ctx = canvas.getContext('2d');
            ctx.strokeStyle = knob.knobColor;
            ctx.lineWidth = knob.lineWidth;
            ctx.lineCap = "round"
            ctx.beginPath();
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            if (knob.reverse) {
                ctx.arc(radius, radius, radius - knob.lineWidth, knob.toAngle, knob.toAngle - step, true);
            } else {
                ctx.arc(radius, radius, radius - knob.lineWidth, knob.fromAngle, knob.fromAngle + step, false);
            }
            ctx.stroke();
        }
    }
}
