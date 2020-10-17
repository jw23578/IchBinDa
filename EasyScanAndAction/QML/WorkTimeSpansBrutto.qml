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
            id: theItem
            width: view.width
            height: smallData.height + ESAA.spacing
            Behavior on height
            {
                NumberAnimation
                {
                    duration: 200
                }
            }

            Column
            {
                id: smallData
                visible: opacity > 0
                opacity: 1
                anchors.left: parent.left
                anchors.leftMargin: ESAA.spacing
                anchors.verticalCenter: parent.verticalCenter
                Behavior on opacity
                {
                    NumberAnimation
                    {
                        duration: 200
                    }
                }

                ESAAText
                {
                    text: "Dienst von " + JW78Utils.formatDate(timeSpan.workBegin) + " " + JW78Utils.formatTimeHHMM(timeSpan.workBegin)
                }
                ESAAText
                {
                    text: "Dienst bis " + JW78Utils.formatDate(timeSpan.workEnd) + " " + JW78Utils.formatTimeHHMM(timeSpan.workEnd)
                }
                ESAAText
                {
                    text: "Dauer Brutto: " + JW78Utils.formatMinutesHHMM(timeSpan.workMinutesBrutto);
                }
                ESAAText
                {
                    text: "Pause: " + JW78Utils.formatMinutesHHMM(timeSpan.pauseMinutesNetto);
                }
                ESAAText
                {
                    text: "Hinzugefügte Pause: " + JW78Utils.formatMinutesHHMM(timeSpan.addedPauseMinutes);
                }
                ESAAText
                {
                    text: "Dauer Netto: " + JW78Utils.formatMinutesHHMM(timeSpan.workMinutesNetto);
                }
            }
            Column
            {
                visible: opacity > 0
                opacity: 0
                Behavior on opacity
                {
                    NumberAnimation
                    {
                        duration: 200
                    }
                }
                id: extData
                anchors.left: parent.left
                anchors.leftMargin: ESAA.spacing
                anchors.verticalCenter: parent.verticalCenter
                ESAAText
                {
                    text: "Dienst von " + JW78Utils.formatDate(timeSpan.workBegin) + " " + JW78Utils.formatTimeHHMM(timeSpan.workBegin)
                }
                ESAAText
                {
                    text: "Dienst bis " + JW78Utils.formatDate(timeSpan.workEnd) + " " + JW78Utils.formatTimeHHMM(timeSpan.workEnd)
                }
                ESAAText
                {
                    text: "Dauer Brutto: " + JW78Utils.formatMinutesHHMM(timeSpan.workMinutesBrutto);
                }
                ESAAText
                {
                    text: "Pause Brutto: " + JW78Utils.formatMinutesHHMM(timeSpan.pauseMinutesBrutto)
                }
                ESAAText
                {
                    text: "Pause Netto: " + JW78Utils.formatMinutesHHMM(timeSpan.pauseMinutesNetto);
                }
                ESAAText
                {
                    text: "Hinzugefügte Pause: " + JW78Utils.formatMinutesHHMM(timeSpan.addedPauseMinutes);
                }
                ESAAText
                {
                    text: "Dauer Netto: " + JW78Utils.formatMinutesHHMM(timeSpan.workMinutesNetto);
                }
            }
            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    if (smallData.visible)
                    {
                        theItem.height = extData.height + ESAA.spacing
                        extData.z = 0
                        smallData.z = 0
                        smallData.opacity = 0
                        extData.opacity = 1
                    }
                    else
                    {
                        theItem.height = smallData.height + ESAA.spacing
                        extData.z = 1
                        smallData.z = 0
                        smallData.opacity = 1
                        extData.opacity = 0
                    }
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
