import QtQuick 2.15
import QtQuick.Controls 2.15
import "../Comp"
import "../BasePages"
import "qrc:/foundation"

PageWithBackButton
{
    caption: "Hilfe anbieten"
    signal showMyHelpOffersClicked()
    signal createNewHelpOfferClicked()
    signal searchNeededHelpClicked()
    id: wantToHelpPage
    onShowed: IDPGlobals.openCovers(wantToHelpPage)
    onHided: IDPGlobals.closeCovers(wantToHelpPage)
    Item
    {
        anchors.margins: IDPGlobals.spacing
        anchors.bottom: backButton.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        Column
        {
            anchors.centerIn: parent
            width: parent.width
            height: parent.height / 3
            spacing: IDPGlobals.spacing
            IDPText
            {
                width: parent.width - 2 * IDPGlobals.spacing
                text: qsTr("ICH MÖCHTE HELFEN")
                font.bold: true
                fontSizeFactor: 2
                wrapMode: Text.WordWrap
                coverContainer: wantToHelpPage
            }
            IDPText
            {
                width: parent.width - 2 * IDPGlobals.spacing
                text: qsTr("Erstelle ein eigenes Hilfsangebot oder schau dir die Hilfsgesuche anderer Community-Teilnehmer an")
                wrapMode: Text.WordWrap
                coverContainer: wantToHelpPage
            }
        }
        TwoCircleButtons
        {
            coverContainer: wantToHelpPage
            anchors.bottom: parent.bottom
            leftText: MyHelpOffers.count ? qsTr("Meine Angebote") : qsTr("Hilfsangebot\nerstellen")
            onLeftClicked: MyHelpOffers.count ? showMyHelpOffersClicked() : createNewHelpOfferClicked()
            rightText: qsTr("Hilfsgesuche\nanschauen")
            onRightClicked: searchNeededHelpClicked()
        }
    }
}
