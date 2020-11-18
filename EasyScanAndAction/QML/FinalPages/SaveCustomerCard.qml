import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."
import "../BasePages"
import "../Comp"

PageWithBackButton {
    caption: "Kundenkarte speichern"
    property string imageFilename: ""
    signal cardSaved;
    onShowing:
    {
        cardName.text = ""
    }
    onHiding: imageFilename = ""
    Image
    {
        id: theImage
        autoTransform: true
        cache: false
        source: parent.imageFilename
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: cardName.top
        anchors.margins: ESAA.spacing
        fillMode: Image.PreserveAspectFit
    }

    ESAALineInputWithCaption
    {
        caption: "Bezeichnung"
        id: cardName
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: saveButton.top
        anchors.margins: ESAA.spacing
        font.pixelSize: JW78APP.fontMessageTextPixelsize
    }

    CentralActionButton
    {
        id: saveButton
        text: "Speichern"
        onClicked:
        {
            if (cardName.text == "")
            {
                ESAA.showMessage("Bitte gib noch eine Bezeichnung ein.")
                return
            }
            ESAA.saveCustomerCard(cardName.text, parent.imageFilename)
            parent.cardSaved()
        }
    }
}
