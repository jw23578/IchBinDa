import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."
import "../BasePages"
import "../Comp"

PageWithBackButton
{
    id: showCardPage
    property int index: 0
    property string imageFilename: ""
    Image
    {
        autoTransform: true
        source: parent.imageFilename
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: backButton.top
        anchors.margins: ESAA.spacing
        fillMode: Image.PreserveAspectFit
    }
    CircleMultiButton
    {
        z: 11
        id: theMultiButton
        x: JW78Utils.screenWidth / 300 * 150 - width / 2
        y: JW78Utils.screenHeight / 480 * 360 - height / 2
        button1VisibleMaster: false
        button2VisibleMaster: false
        button3.text: "Karte<br>löschen"
        button3.onClicked: {
            backPressed()
            JW78APP.deleteCustomerCardByIndex(index)
        }
    }
}
