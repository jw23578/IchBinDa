import QtQuick 2.15
import "Comp"

ESAAPage
{
    id: timemainpage
    caption: "Zeiterfassung"
    onShowing: ESAA.setWorkTimeScheme()

    Column
    {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -ESAA.spacing * 3
        width: parent.width
        spacing: ESAA.spacing
        property int buttonWidth: JW78Utils.screenWidth / 3.3
        TwoCircleButtons
        {
            leftText: "Dienst<br>beginn"
            disabledLeftText: "Dienst seit:<br>" + JW78Utils.formatTimeHHMM(TimeMaster.currentWorkStart)
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
            disabledLeftText: JW78Utils.formatTimeHHMM(TimeMaster.currentPauseStart) == "" ? "" : "Pause seit:<br>" + JW78Utils.formatTimeHHMM(TimeMaster.currentPauseStart)
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
            disabledLeftText: JW78Utils.formatTimeHHMM(TimeMaster.currentWorkTravelStart) == "" ? "" : "Dienstgang seit:<br>" + JW78Utils.formatTimeHHMM(TimeMaster.currentWorkTravelStart)
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
