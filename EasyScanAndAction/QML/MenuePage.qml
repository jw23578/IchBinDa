import QtQuick 2.15
import QtQuick.Controls 2.15
import "Comp"
import "qrc:/foundation"

ESAAPage
{
    signal editContactData
    signal close
    signal editQRCode
    signal help
    signal myVisitsClicked
    signal showKontaktTagebuchQRCode;
    caption: "Menü"
    color: JW78APP.mainColor
    onShowing: {
        theFlickable.contentY = 0
    }
    Flickable
    {
        id: theFlickable
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: IDPGlobals.spacing
        anchors.bottomMargin: IDPGlobals.spacing
        width: parent.width - IDPGlobals.spacing * 2
        anchors.bottom: backbutton.top
        clip: true
        contentHeight: theGrid.height
        Grid
        {
            width: parent.width
            columns: 2
            spacing: IDPGlobals.spacing
            id: theGrid
            property int elemWidth: (width - spacing) / columns
            IDPCircleImage
            {
                source: "qrc:/images/mobileImage3.svg"
                width: theGrid.elemWidth
                imagesize: width * 0.7
                layerEnabled: false
                IDPText
                {
                    fontSizeFactor: 0.7
                    color: JW78APP.circleImageTextColor
                    anchors.top: parent.top
                    anchors.topMargin: parent.width / 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Als Besucher<br>Kontakten bearbeiten"
                }
                onClicked: editContactData()
            }
            IDPCircleImage
            {
                source: "qrc:/images/mobileImage4.svg"
                width: theGrid.elemWidth
                imagesize: width * 0.7
                layerEnabled: false
                IDPText
                {
                    fontSizeFactor: 0.7
                    color: JW78APP.circleImageTextColor
                    anchors.top: parent.top
                    anchors.topMargin: parent.width / 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Als Betreiber<br>QR-Code anlegen"
                }
                onClicked: editQRCode()
            }
            IDPCircleImage
            {
                source: "qrc:/images/mobileImage5.svg"
                width: theGrid.elemWidth
                imagesize: width * 0.7
                layerEnabled: false
                IDPText
                {
                    fontSizeFactor: 0.7
                    color: JW78APP.circleImageTextColor
                    anchors.top: parent.top
                    anchors.topMargin: parent.width / 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Kontakttagebuch"
                }
                onClicked: showKontaktTagebuchQRCode()
            }
            IDPCircleImage
            {
                source: "qrc:/images/mobileImage6.svg"
                width: theGrid.elemWidth
                imagesize: width * 0.7
                layerEnabled: false
                IDPText
                {
                    fontSizeFactor: 0.7
                    color: JW78APP.circleImageTextColor
                    anchors.top: parent.top
                    anchors.topMargin: parent.width / 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Spenden"
                }
                onClicked: Qt.openUrlExternally("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=M29Q4NYS8DXYJ&source=url")
            }
            IDPCircleImage
            {
                source: "qrc:/images/mobileImage7.svg"
                width: theGrid.elemWidth
                imagesize: width * 0.7
                layerEnabled: false
                IDPText
                {
                    fontSizeFactor: 0.7
                    color: JW78APP.circleImageTextColor
                    anchors.top: parent.top
                    anchors.topMargin: parent.width / 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Hilfe"
                }
                onClicked: help()
            }
            IDPCircleImage
            {
                source: "qrc:/images/mobileImage8.svg"
                width: theGrid.elemWidth
                imagesize: width * 0.7
                layerEnabled: false
                IDPText
                {
                    fontSizeFactor: 0.7
                    color: JW78APP.circleImageTextColor
                    anchors.top: parent.top
                    anchors.topMargin: parent.width / 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "IchBinDa im<br>Internet"
                }
                onClicked: Qt.openUrlExternally("https://www.app-ichbinda.de")
            }
            IDPCircleImage
            {
                source: "qrc:/images/mobileImage8.svg"
                width: theGrid.elemWidth
                imagesize: width * 0.7
                layerEnabled: false
                IDPText
                {
                    fontSizeFactor: 0.7
                    color: JW78APP.circleImageTextColor
                    anchors.top: parent.top
                    anchors.topMargin: parent.width / 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Meine Besuche"
                }
                onClicked: myVisitsClicked()
            }
            IDPCircleImage
            {
                source: "qrc:/images/mobileImage8.svg"
                width: theGrid.elemWidth
                imagesize: width * 0.7
                layerEnabled: false
                IDPText
                {
                    fontSizeFactor: 0.7
                    color: JW78APP.circleImageTextColor
                    anchors.top: parent.top
                    anchors.topMargin: parent.width / 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Im Falle<br>des Falles"
                }
                onClicked: Qt.openUrlExternally("https://www.app-ichbinda.de/index.html#for-operator-in-case")
            }
        }
    }
    BackButton
    {
        onClicked: close()
        id: backbutton
    }
    onBackPressed:
    {
        console.log("menuepage back")
        close()
    }
}
