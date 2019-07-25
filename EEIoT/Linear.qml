import QtQuick 2.0

Item {
    id: linear

    property var metaData : ["from", "to", "value",
        "labelFont",
        "scaleColor",
        "warningStart", "dangerStart",
        "okColor", "warningColor", "dengerColor",
    "okBackColor", "warningColor", "warningBackColor", "dangerBackColor",
    "fontSize", "labelFontSize", "labelFontColor",
    "barWidth", "barShift", "pointerSize",
    "scaleNum",
    "startX", "startY", "shift",
    "title", "titleFont", "titleFontSize", "titleFontColor"]

    property double from: 0
    property double value: 1
    property double to: 100

    property alias labelFont: label.font
    property alias labelFontSize: label.font.pointSize
    property alias labelFontColor: label.color

    property color scaleColor: "black"

    property double warningStart: 80
    property double dangerStart: 90

    property color okColor: "green"
    property color warningColor: "yellow"
    property color dengerColor: "red"

    property color okBackColor: Qt.rgba(0, 1, 0, 0.2);
    property color warningBackColor: Qt.rgba(0.5, 0.5, 0, 0.2);
    property color dangerBackColor: Qt.rgba(1, 0, 0, 0.2);

    property int fontSize: 10

    property double barWidth: 20
    property double barShift: 10
    property double pointerSize: 5

    property int scaleNum: 4

    readonly property int startX: width / 4
    readonly property int startY: 10
    readonly property double shift: 70

    property string title: ""
    property alias titleFont: labelTitle.font.family
    property alias titleFontSize: labelTitle.font.pointSize
    property alias titleFontColor: labelTitle.color

    function update(value) {
        linear.value = value
        canvas.requestPaint()
        background.requestPaint();
        label.text = value.toFixed(2);
        label.y = background.y + background.height + (value / (from - to) *background.height) - label.height/2;
        pointer.y = background.y + background.height + (value / (from - to) *background.height) - pointer.height/2;
    }

    Text {
        id: labelTitle
        y: 0
        text: linear.title
        color: Qt.rgba(0, 0, 0., 0.5)
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Repeater {
        id: rep
        y: labelTitle.height
        objectName:"level"
        model: scaleNum

        property double step: canvas.height / (linear.scaleNum - 1)

        delegate: Text{
            id: scaleLabel
            color: linear.scaleColor
            y: (canvas.height - index * rep.step) - height/2 + labelTitle.height*2
            x: linear.shift - width - 5
            text: ((linear.to - linear.from) / (scaleNum - 1) * index).toFixed(2);
        }
    }

    Text {
        id: label
        x: shift + barShift + barWidth + pointerSize
        y: canvas.height + (value / (from - to) *canvas.height) - label.height/2;
        width: 40
        height: 12
        color: Qt.rgba(0, 0, 0., 0.7)
        font.bold: true
        font.pointSize: linear.fontSize
        text: linear.value.toFixed(2)
        z: 1
    }

    Rectangle {
        id: pointer
        x: shift + barShift + barWidth
        y: canvas.height + (value / (from - to) *canvas.height) - pointer.height/2
        width: pointerSize
        height: pointerSize
        color: "transparent"

        Canvas {
            id: pointerCanvas
            width: pointer.width
            height: pointer.height
            antialiasing: true
            z:1

            onPaint: {
                var ctx = getContext('2d');
                ctx.fillStyle = "darkGray";
                ctx.lineWidth = linear.lineWidth;
                ctx.beginPath();
                ctx.moveTo(0, height/2);
                ctx.lineTo(width, height);
                ctx.lineTo(width, 0);
                ctx.lineTo(0, height/2);
                ctx.fill();
            }
        }
    }

    Canvas {
        id: canvas
        width: parent.width - linear.startX
        height: parent.height - linear.startY
        antialiasing: true
        z:1

        property double pX: shift + barShift + barWidth
        property double pY: 0

        property double warningStart: 0
        property double dangerStart: 0
        property double value: 0

        onPaint: {
            if (linear.title !== "") {
                canvas.y = labelTitle.height
                canvas.height = parent.height - linear.startY - labelTitle.height
                canvas.width = parent.width - linear.startX
            }

            canvas.pY = canvas.height + (linear.value / (linear.from - linear.to) *height)

            canvas.warningStart = canvas.height*((linear.warningStart - linear.from)/(linear.to - linear.from))
            canvas.dangerStart = canvas.height*((linear.dangerStart - linear.from)/(linear.to - linear.from))
            canvas.value = canvas.height*linear.value/(linear.to - linear.from)

            var ctx = getContext('2d');
            ctx.lineWidth = linear.lineWidth;
            ctx.clearRect(0, 0, width, height);

            if (value < warningStart) {
                ctx.fillStyle = linear.okColor;
            } else if (value < dangerStart) {
                ctx.fillStyle = linear.warningColor;
            } else {
                ctx.fillStyle = linear.dengerColor;
            }

            ctx.beginPath();
            ctx.fillRect(linear.shift + linear.barShift, height - value, linear.barWidth, value);
            ctx.fill();
        }
    }

    Canvas {
        id: background
        width: parent.width - linear.startX
        height: parent.height - linear.startY
        antialiasing: true

        property double warningStart: 0
        property double dangerStart: 0

        onPaint: {
            if (linear.title !== "") {
                background.y = labelTitle.height

                background.height = parent.height - linear.startY - labelTitle.height
                background.width = parent.width - linear.startX
            }

            background.warningStart = background.height*((linear.warningStart - linear.from)/(linear.to - linear.from))
            background.dangerStart = background.height*((linear.dangerStart - linear.from)/(linear.to - linear.from))

            var ctx = getContext('2d');
            ctx.strokeStyle = linear.scaleColor;
            ctx.lineWidth = linear.lineWidth;
            ctx.lineCap = "round"
            ctx.beginPath();
            ctx.clearRect(0, 0, background.width, background.height);
            ctx.moveTo(shift, 0);
            ctx.lineTo(shift, background.height);
            ctx.stroke();

            ctx.fillStyle = linear.okBackColor;
            ctx.beginPath();
            ctx.fillRect(linear.shift + linear.barShift, background.height - warningStart, linear.barWidth, background.height*warningStart);
            ctx.fill();

            ctx.fillStyle = linear.warningBackColor;
            ctx.beginPath();
            ctx.fillRect(linear.shift + linear.barShift, background.height - background.dangerStart, linear.barWidth, background.dangerStart - background.warningStart);
            ctx.fill();

            ctx.fillStyle = linear.dangerBackColor;
            ctx.beginPath();
            ctx.fillRect(linear.shift + linear.barShift, 0, linear.barWidth, background.height - background.dangerStart);
            ctx.fill();
        }
    }
}
