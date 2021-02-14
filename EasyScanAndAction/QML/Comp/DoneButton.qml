import QtQuick 2.15
import "qrc:/foundation"

IDPButtonCircle
{
    text: qsTr("Fertig")
    width: JW78Utils.screenWidth / 8
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.rightMargin: width / 3
    anchors.bottomMargin: anchors.rightMargin
}
