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
    onBackPressed: theMultiButton.close()
    Image
    {
        autoTransform: true
        source: parent.imageFilename
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: theMultiButton.top
        anchors.margins: ESAA.spacing
        fillMode: Image.PreserveAspectFit
    }
    CircleMultiButton
    {
        z: 11
        id: theMultiButton
        yMoveOnOpen: 0
        x: JW78Utils.screenWidth / 300 * 150 - width / 2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: JW78APP.spacing
        button1VisibleMaster: false
        button2VisibleMaster: false
        button4VisibleMaster: false
        button3.text: "Karte<br>löschen"
        button3.onClicked: {
            backPressed()
            JW78APP.deleteCustomerCardByIndex(index)
        }
    }
}
