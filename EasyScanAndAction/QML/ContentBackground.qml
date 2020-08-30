import QtQuick 2.0

Rectangle {
    gradient: Gradient
    {
        GradientStop { position: 0.0; color: "#cccccc" }
        GradientStop { position: 1.0; color: "#cccccc" }
    }

//    MovingRectangle
//    {
//        id: r1
//        y: -1
//        x: parent.width * 4 / 5
//    }
//    MovingRectangle
//    {
//        anchors.top: r1.bottom
//        anchors.topMargin: -1
//        id: r2
//        x: parent.width / 5
//    }

    Rectangle
    {
        anchors.fill: parent
        anchors.margins: ESAA.spacing / 2
        radius: ESAA.radius
        color: "steelblue"
        opacity: 0.8
        border.width: 1
        border.color: "#aaaaee"
    }

    PauseAnimation
    {
        id: pauseAni
        duration: 20
        onStopped:
        {
//            r1.x = width / 5
//            r2.x = width / 5 * 4
        }
    }

    Component.onCompleted:
    {
        pauseAni.start();
    }
}
