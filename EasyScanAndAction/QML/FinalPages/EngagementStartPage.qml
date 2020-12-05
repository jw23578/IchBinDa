import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."
import "../Comp"
import "../BasePages"

PageWithBackButton
{
    caption: "Engagement"
    signal offerHelpClicked
    EmptySwipeView
    {
        anchors.margins: ESAA.spacing
        anchors.bottom: buttons.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        sources: ["qrc:/images/engagement_1.png",
        "qrc:/images/engagement_2.png"]
    }

    TwoCircleButtons
    {
        id: buttons
        leftText: "Ich möchte<br>helfen"
        onLeftClicked: offerHelpClicked()
        rightText: "Ich benötige<br>Hilfe"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: JW78APP.spacing * 3
    }
}
