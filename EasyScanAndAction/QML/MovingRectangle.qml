import QtQuick 2.0

Rectangle {
    width: parent.width
    height: parent.height / 5
    radius: 7
    color: "transparent"
    border.width: 1
    border.color: "#909090"
    property int movingDuration: 5000
    Behavior on x {
        NumberAnimation {
            duration: movingDuration
        }
    }

}
