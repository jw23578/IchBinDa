import QtQuick 2.15
import QtCharts 2.15
import ".."
import "../BasePages"
import "../Comp"

ESAAPage
{
    caption: "Arbeitszeiten"
    CircleButton
    {
        anchors.right: parent.right
        anchors.top: parent.top
        text: "Develop<br>Daten<br>erzeugen"
        visible: ESAA.isDevelop
        onClicked:
        {
            TimeMaster.developPrepare()
            TimeMaster.load(2020, 10)
        }
        z: 2
    }
    ListView
    {
        id: view
        anchors.top: parent.top
        anchors.margins: ESAA.spacing
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: navigateRow.top
        spacing: 1
        model: WorkTimeSpansModel
        clip: true
        delegate: Item {
            clip: true
            id: theItem
            width: view.width
            height: (smallData.myVisible ? smallData.height : extData.myVisible ? extData.height : fullData.height) + ESAA.spacing
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
                property bool myVisible: true;
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
                    id: dienstBeginnEndeAmSelbenTag
                    visible: JW78Utils.formatDate(timeSpan.workBegin) == JW78Utils.formatDate(timeSpan.workEnd)
                    text: "Dienst " + JW78Utils.formatDate(timeSpan.workBegin) + " " + JW78Utils.formatTimeHHMM(timeSpan.workBegin) + " - " + JW78Utils.formatTimeHHMM(timeSpan.workEnd)
                }
                ESAAText
                {
                    visible: !dienstBeginnEndeAmSelbenTag.visible
                    text: "Dienst von " + JW78Utils.formatDate(timeSpan.workBegin) + " " + JW78Utils.formatTimeHHMM(timeSpan.workBegin)
                }
                ESAAText
                {
                    visible: !dienstBeginnEndeAmSelbenTag.visible
                    text: "Dienst bis " + JW78Utils.formatDate(timeSpan.workEnd) + " " + JW78Utils.formatTimeHHMM(timeSpan.workEnd)
                }
                ESAAText
                {
                    text: "Pause: " + JW78Utils.formatMinutesHHMM(timeSpan.pauseMinutesNetto + timeSpan.addedPauseMinutes) + " (" + timeSpan.pauseCount + ")"
                    visible: timeSpan.pauseCount > 0
                }
                ESAAText
                {
                    text: "Dauer: " + JW78Utils.formatMinutesHHMM(timeSpan.workMinutesNetto);
                }
            }
            Column
            {
                id: extData
                property bool myVisible: false
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
                property bool myVisible: false
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
                        smallData.myVisible = false
                        extData.myVisible = true
                        fullData.myVisible = false
                        extData.z = 0
                        smallData.z = 0
                        fullData.z = 0
                        fullData.opacity = 0
                        smallData.opacity = 0
                        extData.opacity = 1
                    }
                    else
                    {
                        if (extData.visible && timeSpan.pauseCount > 0)
                        {
                            smallData.myVisible = false
                            extData.myVisible = false
                            fullData.myVisible = true
                            extData.z = 0
                            fullData.z = 1
                            smallData.z = 0
                            smallData.opacity = 0
                            extData.opacity = 0
                            fullData.opacity = 1
                        }
                        else
                        {
                            smallData.myVisible = true
                            extData.myVisible = false
                            fullData.myVisible = false
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
    Item
    {
        id: navigateRow
        anchors.bottom: backbutton.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: ESAA.spacing
        height: toLeft.height

        ArrowButton
        {
            id: toLeft
            rightArrow: false
            onClicked:
            {
                TimeMaster.currentYearMonth = JW78Utils.incMonths(TimeMaster.currentYearMonth, -1)
                TimeMaster.load(JW78Utils.year(TimeMaster.currentYearMonth), JW78Utils.month(TimeMaster.currentYearMonth))
            }
        }
        ESAAText
        {
            text: JW78Utils.formatDateMonthYear(TimeMaster.currentYearMonth)
            anchors.centerIn: parent
        }
        ArrowButton
        {
            anchors.right: parent.right
            onClicked:
            {
                TimeMaster.currentYearMonth = JW78Utils.incMonths(TimeMaster.currentYearMonth, 1)
                TimeMaster.load(JW78Utils.year(TimeMaster.currentYearMonth), JW78Utils.month(TimeMaster.currentYearMonth))
            }
        }
    }

    BackButton
    {
        id: backbutton
        onClicked: backPressed()
    }
}
