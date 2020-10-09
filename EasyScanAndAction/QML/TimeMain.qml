import QtQuick 2.15

ESAAPage
{
    caption: "Zeiterfassung"
    Column
    {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -ESAA.spacing * 3
        width: parent.width
        spacing: ESAA.spacing
        property int buttonWidth: ESAA.screenWidth / 3.3
        TwoCircleButtons
        {
            leftText: "Dienst<br>beginn"
            rightText: "Dienst<br>ende"
            buttonSize: parent.buttonWidth
            leftEnabled: !TimeMaster.currentWorkStart
            onLeftClicked: TimeMaster.currentWorkStart = Date.now()
            rightEnabled: TimeMaster.currentWorkStart && !TimeMaster.currentPauseStart && !TimeMaster.currentWorkTravelStart
            onRightClicked: TimeMaster.currentWorkStart = null
        }
        TwoCircleButtons
        {
            leftText: "Pause<br>beginn"
            rightText: "Pause<br>ende"
            buttonSize: parent.buttonWidth
            leftEnabled: TimeMaster.currentWorkStart && !TimeMaster.currentPauseStart
            onLeftClicked: TimeMaster.currentPauseStart = Date.now()
            rightEnabled: TimeMaster.currentWorkStart && TimeMaster.currentPauseStart
            onRightClicked: TimeMaster.currentPauseStart = null
        }
        TwoCircleButtons
        {
            leftText: "Dienstgang<br>beginn"
            rightText: "Dienstgang<br>ende"
            buttonSize: parent.buttonWidth
            leftEnabled: TimeMaster.currentWorkStart && !TimeMaster.currentPauseStart && !TimeMaster.currentWorkTravelStart
            onLeftClicked: TimeMaster.currentWorkTravelStart = Date.now()
            rightEnabled: TimeMaster.currentWorkStart && !TimeMaster.currentPauseStart && TimeMaster.currentWorkTravelStart
            onRightClicked: TimeMaster.currentWorkTravelStart = null
        }
    }
    BackButton
    {
        onClicked: backPressed()
    }
}
