import QtQuick 2.15
import QtCharts 2.15
import "Comp"

ESAAPage
{
    caption: "Zeiterfassung Ereignisse"
    ListView
    {
        id: view
        anchors.top: parent.top
        anchors.topMargin: ESAA.spacing
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: backbutton.top
        anchors.bottomMargin: ESAA.spacing
        spacing: 1
        model: AllTimeEvents
        clip: true
        delegate: Item {
            width: view.width
            height: view.height / 8
            Column
            {
                anchors.left: parent.left
                anchors.leftMargin: ESAA.spacing
                anchors.verticalCenter: parent.verticalCenter
                ESAAText
                {
                    text: JW78Utils.formatDate(event.timeStamp)
                    id: datetext
                }
                ESAAText
                {
                    text: JW78Utils.formatTimeHHMM(event.timeStamp)
                    id: timetext
                }
            }
            ESAAText
            {
                anchors.centerIn: parent
                text: event.type2String()
            }

            Rectangle
            {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: "black"
            }
        }
    }

    BackButton
    {
        id: backbutton
        onClicked: backPressed()
    }
}
