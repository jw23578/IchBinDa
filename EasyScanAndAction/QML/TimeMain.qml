import QtQuick 2.15

ESAAPage
{
    id: timemainpage
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
            leftEnabled: TimeMaster.isNull(TimeMaster.currentWorkStart)
            onLeftClicked: TimeMaster.currentWorkStart = TimeMaster.now()
            rightEnabled: TimeMaster.isValid(TimeMaster.currentWorkStart)
                          && TimeMaster.isNull(TimeMaster.currentPauseStart)
                          && TimeMaster.isNull(TimeMaster.currentWorkTravelStart)
            onRightClicked: TimeMaster.currentWorkStart = TimeMaster.nullDate()
        }
        TwoCircleButtons
        {
            leftText: "Pause<br>beginn"
            rightText: "Pause<br>ende"
            buttonSize: parent.buttonWidth
            leftEnabled: TimeMaster.isValid(TimeMaster.currentWorkStart)
                         && TimeMaster.isNull(TimeMaster.currentPauseStart)
            onLeftClicked: TimeMaster.currentPauseStart = TimeMaster.now()
            rightEnabled: TimeMaster.isValid(TimeMaster.currentWorkStart)
                          && TimeMaster.isValid(TimeMaster.currentPauseStart)
            onRightClicked: TimeMaster.currentPauseStart = TimeMaster.nullDate()
        }
        TwoCircleButtons
        {
            leftText: "Dienstgang<br>beginn"
            rightText: "Dienstgang<br>ende"
            buttonSize: parent.buttonWidth
            leftEnabled: TimeMaster.isValid(TimeMaster.currentWorkStart)
                         && TimeMaster.isNull(TimeMaster.currentPauseStart)
                         && TimeMaster.isNull(TimeMaster.currentWorkTravelStart)
            onLeftClicked: TimeMaster.currentWorkTravelStart = TimeMaster.now()
            rightEnabled: TimeMaster.isValid(TimeMaster.currentWorkStart)
                          && TimeMaster.isNull(TimeMaster.currentPauseStart)
                          && TimeMaster.isValid(TimeMaster.currentWorkTravelStart)
            onRightClicked: TimeMaster.currentWorkTravelStart = TimeMaster.nullDate()
        }
    }
    BackButton
    {
        onClicked: backPressed()
    }
}
