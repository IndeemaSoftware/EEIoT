import QtQuick 2.0
import QtCharts 2.0

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

    
    function getWave(x, w, a)
    {
       return a* Math.sin(w*x)
    }

    function drawWawe(ctx, centreX, centreY, radius, border,heightT)
    {
        var leftX = 0
        var rightX = 100

        var distance = rightX - leftX
        var w = distance/Math.PI/5
        var a = 3.5
        var x1 = centreX - Math.sqrt(Math.pow(radius - border, 2) - Math.pow(radius - border - value, 2))
        var x2 = centreX + Math.sqrt(Math.pow(radius - border, 2) - Math.pow(radius - border - value, 2))

        ctx.beginPath()
        ctx.fillStyle = waterProgress.color;
        ctx.strokeStyle = waterProgress.color;
        ctx.moveTo(x1, (centreY + radius - border) - value);
        ctx.moveTo(centreX, (centreY + radius - border));

        var iter = 0;
        while(iter<=heightT) {
           var y22 =  (centreY + radius - border) - iter
           var x22 = centreX  - Math.sqrt(Math.pow(radius - border, 2) - Math.pow(radius - border - iter, 2))
           ctx.lineTo(x22, y22);
           iter+=0.1
        }

        for(var i = x1; i < x2; i++)
        {
           var y = getWave(i,w,a)
           ctx.lineTo(i,y + (centreY + radius - border) - value);
        }
        iter = heightT

        while(iter>=0) {
            var y11 = (centreY + radius - border) - iter
            var x11 = centreX + Math.sqrt(Math.pow(radius - border, 2) - Math.pow(radius - border - iter, 2))
            ctx.lineTo(x11 , y11);
            iter-=0.1
        }
        ctx.fill()
        ctx.stroke()
    }

    function drawLine(ctx, centreX, centreY, radius, border,start, step )
    {
        ctx.beginPath();
        ctx.fillStyle = waterProgress.color;
        ctx.arc(centreX, centreY, radius - border, start + step, start - step, true);
        ctx.fill();
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

            var heightT = (radius - border)*2*coef
   
            ctx.lineWidth = 1;
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 1)

//          drawLine(ctx,centreY, centreX,radius, border,start, step)

            drawWawe(ctx,centreY, centreX,radius, border,heightT)


            ctx.beginPath();
            ctx.strokeStyle = waterProgress.color;
            ctx.lineWidth = waterProgress.lineWidth;
            ctx.arc(radius, radius, radius - waterProgress.lineWidth, 0, 2*Math.PI, false);
            ctx.stroke();
        }
    }
}
