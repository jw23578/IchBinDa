import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."
import "../BasePages"
import "../Comp"

PageWithBackButton {
    property string imageFilename: ""
    Image
    {
        source: parent.imageFilename
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: backButton.top
        anchors.margins: ESAA.spacing
        fillMode: Image.PreserveAspectFit
    }
}
