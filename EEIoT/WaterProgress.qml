import QtQuick 2.0

Item {
    id: waterProgress

    property double from:0
    property double value: 1
    property double to: 100

    property int lineWidth: width / 50

    property int fontSize: width / 6

    property color color: Qt.rgba(0.2, 0.62, 0.93, 0.7)
    property color textColor: Qt.rgba(0.03, 0.3, 0.5, 1)

    function update(value) {
        waterProgress.value = value
        canvas.requestPaint()
        label.text = value.toFixed(2)
        label.anchors.horizontalCenter = waterProgress.horizontalCenter
        label.anchors.verticalCenter = waterProgress.verticalCenter
        label.transformOrigin = Item.Center
        label.anchors.centerIn = waterProgress.anchors.centerIn
    }

    Text {
        id: label
        width: 40
        height: 12
        color: waterProgress.textColor
        font.bold: true
        font.pointSize: waterProgress.fontSize
        text: waterProgress.value.toFixed(2)
        z: 1
        horizontalAlignment: Text.AlignHCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Canvas {
        id: canvas
        width: parent.width
        height: parent.height
        antialiasing: true

        property double radius: width/2.0
        property int border: 5
        readonly property double start: Math.PI*2.5
        readonly property double coef: waterProgress.value / (waterProgress.to - waterProgress.from)
        property double step: coef * Math.PI

        onPaint: {
            var ctx = canvas.getContext("2d");
            ctx.reset();

            var centreX = width / 2.0;
            var centreY = height / 2.0;

            ctx.beginPath();
            ctx.fillStyle = waterProgress.color;
            ctx.arc(centreX, centreY, radius - border, start + step, start - step, true);
            ctx.moveTo(centreX, height-centreY * coef * 2.0);
            ctx.fill();

            ctx.beginPath();
            ctx.strokeStyle = waterProgress.color;
            ctx.lineWidth = waterProgress.lineWidth;
            ctx.arc(radius, radius, radius - waterProgress.lineWidth, 0, 2*Math.PI, false);
            ctx.stroke();
        }
    }
}
