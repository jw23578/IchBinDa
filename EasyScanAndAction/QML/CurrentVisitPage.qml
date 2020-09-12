import QtQuick 2.0

ESAAPage
{
    caption: "Du bist hier:"
    signal questionVisitEnd;
    CircleButton
    {
        id: finishVisit
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -width / 1.5
        text: qsTr("Besuch<br>beenden")
        onClicked: questionVisitEnd()
    }
    CircleButton
    {
        id: lastTransmissionbutton
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: width / 1.5
        text: qsTr("Letzte<br>Übertragung")
        onClicked: ESAA.showLastTransmission()
    }
    CircleButton
    {
        id: websiteButton
        anchors.centerIn: parent
        text: qsTr("Webseite<br>öffnen")
        onClicked: Qt.openUrlExternally(LastVisit.websiteURL)
        visible: LastVisit.websiteURL != ""
    }
    ShareButton
    {
    }
    BackButton
    {
        onClicked: questionVisitEnd()
    }
}
