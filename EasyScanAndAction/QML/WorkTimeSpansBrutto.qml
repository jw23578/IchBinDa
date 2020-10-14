import QtQuick 2.15
import QtCharts 2.15

ESAAPage
{
    caption: "Arbeitszeiten brutto"
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
        model: WorkTimeSpans
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
                    text: ESAA.formatDate(timeSpan.workBegin)
                    id: datetext
                }
                ESAAText
                {
                    text: ESAA.formatTime(timeSpan.workBegin)
                    id: timetext
                }
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
