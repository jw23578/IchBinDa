import QtQuick 2.13
import QtQuick.Window 2.13
import "QML"

Window {
    id: mainWindow
    visible: true
    width: 300
    height: 480
    title: qsTr("EasyScanAndAction")
    Column
    {
        anchors.centerIn: parent
        height: t1.height * 15
        width: parent.width
        spacing: mainWindow.height / 40
        Text {
            id: t1
            wrapMode: Text.WordWrap
            width: parent.width
            height: contentHeight
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Hello Hackathon Oldenburg")
        }
        Text {
            width: parent.width
            wrapMode: Text.WordWrap
            height: contentHeight
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("#2030")
        }
        Text {
            width: parent.width
            wrapMode: Text.WordWrap
            height: contentHeight
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("hackathon.kreativitaet-trifft-technik.de/")
            MouseArea
            {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("https://hackathon.kreativitaet-trifft-technik.de/");
            }
        }
        Item
        {
            height: mainWindow.height / 10
            width: parent.width
        }
        Text {
            width: parent.width
            wrapMode: Text.WordWrap
            height: contentHeight
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Dies hier wird die")
        }
        Text {
            width: parent.width
            wrapMode: Text.WordWrap
            height: contentHeight
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("EasyScanAndAction App")
        }
        Text {
            width: parent.width
            wrapMode: Text.WordWrap
            height: contentHeight
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("github.com/jw23578/EasyScanAndAction")
            MouseArea
            {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally("https://github.com/jw23578/EasyScanAndAction");
            }
        }
    }
    QuestionPage
    {

    }
    ScannerPage
    {
        id: scannerpage
    }
    Message
    {
        id: message
    }

    Connections
    {
        target: ESAA
        onShowMessageSignal: message.show(mt)
        onScanSignal: scannerpage.show()
    }
}
