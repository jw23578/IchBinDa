import QtQuick 2.15
import QtCharts 2.15
import "Comp"

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
                    text: "Pause: " + JW78Utils.formatMinutesHHMM(timeSpan.pauseMinutesNetto) + " Anzahl Pausen: " + timeSpan.pauseCount
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
                id: extData
                visible: opacity > 0
                opacity: 0
                Behavior on opacity
                {
                    NumberAnimation
                    {
                        duration: 200
                    }
                }
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
                    text: "Pause Brutto: " + JW78Utils.formatMinutesHHMM(timeSpan.pauseMinutesBrutto) + " Anzahl Pausen: " + timeSpan.pauseCount
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
            Column
            {
                id: fullData
                visible: opacity > 0
                opacity: 0
                Behavior on opacity
                {
                    NumberAnimation
                    {
                        duration: 200
                    }
                }
                anchors.left: parent.left
                anchors.leftMargin: ESAA.spacing
                anchors.right: parent.right
                anchors.rightMargin: ESAA.spacing
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
                Repeater
                {
                    model: timeSpan.pauseCount
                    Item
                    {
                        width: parent.width
                        height: pauseColumn.height + ESAA.spacing
                        Column
                        {
                            id: pauseColumn
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: ESAA.spacing
                            property var pause: timeSpan.getPause(index)
                            spacing: 0
                            ESAAText
                            {
                                text: "Pause von " + JW78Utils.formatDate(parent.pause.pauseBegin) + " " + JW78Utils.formatTimeHHMM(parent.pause.pauseBegin)
                            }
                            ESAAText
                            {
                                text: "Pause bis " + JW78Utils.formatDate(parent.pause.pauseEnd) + " " + JW78Utils.formatTimeHHMM(parent.pause.pauseEnd)
                            }
                            ESAAText
                            {
                                text: "Dauer: " + JW78Utils.formatMinutesHHMM(parent.pause.minutes);
                            }
                        }
                    }
                }

                ESAAText
                {
                    text: "Pause Brutto: " + JW78Utils.formatMinutesHHMM(timeSpan.pauseMinutesBrutto) + " Anzahl Pausen: " + timeSpan.pauseCount
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
                        fullData.z = 0
                        fullData.opacity = 0
                        smallData.opacity = 0
                        extData.opacity = 1
                    }
                    else
                    {
                        if (extData.visible)
                        {
                            theItem.height = fullData.height + ESAA.spacing
                            extData.z = 0
                            fullData.z = 1
                            smallData.z = 0
                            smallData.opacity = 0
                            extData.opacity = 0
                            fullData.opacity = 1
                        }
                        else
                        {
                            theItem.height = smallData.height + ESAA.spacing
                            extData.z = 1
                            fullData.z = 0
                            smallData.z = 0
                            smallData.opacity = 1
                            extData.opacity = 0
                            fullData.opacity = 0
                        }
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
