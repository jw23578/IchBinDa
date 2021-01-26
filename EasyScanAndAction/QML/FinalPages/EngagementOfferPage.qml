import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."
import "../Comp"
import "../BasePages"
import "qrc:/foundation"

PageWithBackButton
{
    id: offerHelpPage
    signal helpOfferSaved()
    caption: "Hilfe anbieten"

    function open()
    {
        IDPGlobals.openCovers(helpType)
    }
    function close()
    {
        IDPGlobals.closeCovers(helpType)
    }

    /*    ESAAFlickable
    {
        id: theFlick
        anchors.margins: ESAA.spacing
        anchors.bottom: addHelp.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        contentHeight: theColumn.height * 1.3
        Column
        {
            parent: theFlick.contentItem
            y: ESAA.spacing
            spacing: ESAA.spacing
            id: theColumn
            width: parent.width - 2 * ESAA.spacing
            anchors.horizontalCenter: parent.horizontalCenter
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: helpOfferCaption
                width: parent.width
                caption: qsTr("Wie möchtest du helfen? (Einkaufshilfe, Haustierausführen, Medikamente abholen, ...)")
                helpText: ""
                onHelpClicked: ESAA.showMessage(ht)
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: helpLocation
                width: parent.width
                caption: qsTr("Wo möchtest du helfen? (Stadt, Landkreis, ...)")
            }
            IDPText
            {
                text: "Deine Kontaktdaten"
            }
            IDPText
            {
                width: parent.width
                wrapMode: Text.WordWrap
                text: "Beschreibe hier genauer, wie du anderen eine Freude machen möchtest"
            }
            ESAALineInputWithCaption
            {
                color: createqrcodepage.textColor
                id: description
                width: parent.width
                caption: qsTr("Beschreibung deiner Hilfe")
            }
        }
    }
    property var elemToFocus: null

    function setFocusNow()
    {
        elemToFocus.forceActiveFocus()
    }
    function focusMessage(theMessage, elem)
    {
        elemToFocus = elem
        ESAA.showMessageWithCallback(theMessage, setFocusNow)
    }

    CentralActionButton
    {
        id: addHelp
        text: "Angebot<br>eintragen"
        onClicked:
        {
            if (helpOfferCaption.displayText == "")
            {
                focusMessage("Bitte gib noch eine Bezeichnung deiner Hilfe ein.", helpOfferCaption)
                return;
            }
            if (description.displayText == "")
            {
                focusMessage("Bitte gib noch eine Beschreibung deiner Hilfe ein.", description)
                return;
            }

            HelpOfferManager.saveHelpOffer(helpOfferCaption.displayText,
                                  description.displayText,
                                  0,
                                  0)
            theFlick.contentY = 0
            helpOfferCaption.text = ""
            description.text = ""
            JW78APP.showMessage("Dein Angebot wurde gespeichert, vielen Dank.")
            helpOfferSaved()
        }
    } */
    ListModel {
        property int selectedCount: 0
        function countSelected()
        {
            selectedCount = 0;
            for (var i = 0; i < count; ++i)
            {
                if (get(i).selected)
                {
                    selectedCount += 1
                }
            }
        }

        id: theHelpModel
        ListElement
        {
            caption: qsTr("Einkaufen\ngehen")
            selected: false
        }
        ListElement
        {
            caption: qsTr("Medikamente\nabholen")
            selected: false
        }
        ListElement
        {
            caption: qsTr("Post\nwegbringen")
            selected: false
        }
        ListElement
        {
            caption: qsTr("Müll\nentsorgen")
            selected: false
        }
        ListElement
        {
            caption: qsTr("Haustier\nausführen")
            selected: false
        }
        ListElement
        {
            caption: qsTr("Begleitdienst")
            selected: false
        }
        ListElement
        {
            caption: qsTr("Sonstige\nHilfe")
            selected: false
        }
        ListElement
        {
            caption: qsTr("Weiter")
            selected: false
        }
    }
    SwipeView
    {
        id: theSwipeView
        anchors.margins: IDPGlobals.spacing
        anchors.bottom: backButton.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        interactive: false

        Item
        {
            id: helpType
            Column
            {
                anchors.fill: parent
                spacing: IDPGlobals.spacing
                IDPText
                {
                    width: parent.width - 2 * IDPGlobals.spacing
                    text: qsTr("WIE MÖCHTEST DU HELFEN?")
                    font.bold: true
                    fontSizeFactor: 2
                    wrapMode: Text.WordWrap
                    id: caption
                }
                GridView
                {
                    id: gridView
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 2 * cellWidth
                    cellWidth: IDPGlobals.screenWidth / 4 + IDPGlobals.spacing / 2
                    cellHeight: IDPGlobals.screenWidth / 4 + IDPGlobals.spacing / 2
                    height: parent.height - caption.height
                    model: theHelpModel
                    delegate: Item
                    {
                        width: gridView.cellWidth
                        height: gridView.cellHeight
                        IDPButtonCircleOnOff
                        {
                            anchors.centerIn: parent
                            text: model.caption
                            visible: model.caption != qsTr("Weiter")
                            onClicked: model.selected = !model.selected
                            coverContainer: helpType
                        }
                        IDPButtonCircle
                        {
                            anchors.centerIn: parent
                            text: model.caption
                            visible: model.caption == qsTr("Weiter")
                            coverContainer: helpType
                            onClicked:
                            {
                                theHelpModel.countSelected()
                                if (theHelpModel.selectedCount == 0)
                                {
                                    JW78APP.showBadMessage("Bitte wähle mindestens eine Art zu Helfen aus.")
                                    return
                                }
                                theSwipeView.currentIndex = 1
                                IDPGlobals.closeCovers(helpType)
                                IDPGlobals.openCovers(helpOffer)
                            }
                        }
                    }
                }
            }
        }
        Item
        {
            id: helpOffer
            Column
            {
                anchors.fill: parent
                spacing: IDPGlobals.spacing
                IDPText
                {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("DEIN ANGEBOT")
                    font.bold: true
                    fontSizeFactor: 2
                    coverContainer: helpOffer
                }
                ListView
                {
                    id: selectedListView
                    model: theHelpModel
                    property int elemWidth: IDPGlobals.screenWidth / 6 + IDPGlobals.spacing / 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: Math.min(parent.width, theHelpModel.selectedCount * elemWidth)
                    height: elemWidth
                    orientation: ListView.Horizontal

                    delegate: Item
                    {
                        visible: model.selected
                        width: visible ? selectedListView.elemWidth : 0
                        height: selectedListView.elemWidth
                        IDPTextCircle {
                            width: IDPGlobals.screenWidth / 6
                            text: model.caption
                            fontSizeFactor: 0.6
                            coverContainer: helpOffer
                        }
                    }
                }
                IDPText
                {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("DEINE DATEN")
                    font.bold: true
                    fontSizeFactor: 2
                    coverContainer: helpOffer
                }
                IDPLineEditWithTopCaption
                {
                    containedCaption: true
                    id: name
                    width: parent.width
                    caption: qsTr("Vorname")
                    text: MainPerson.fstname
                    coverContainer: helpOffer
                }
                IDPLineEditWithTopCaption
                {
                    containedCaption: true
                    id: surname
                    width: parent.width
                    caption: qsTr("Nachname")
                    text: MainPerson.surname
                    coverContainer: helpOffer
                }
                IDPLineEditWithTopCaption
                {
                    containedCaption: true
                    id: phonenumber
                    width: parent.width
                    caption: qsTr("Telefonnummer")
                    text: JW78APP.mobile
                    coverContainer: helpOffer
                }
                IDPLineEditWithTopCaption
                {
                    containedCaption: true
                    id: email
                    width: parent.width
                    caption: qsTr("E-Mail-Adresse")
                    text: MainPerson.emailAdress
                    coverContainer: helpOffer
                }
                IDPText
                {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Wo möchtest du helfen:")
                    coverContainer: helpOffer
                    fontSizeFactor: 1.5
                }
                IDPLineEditWithTopCaption
                {
                    containedCaption: true
                    id: location
                    width: parent.width
                    caption: qsTr("Standort")
                    coverContainer: helpOffer
                }
            }
        }
    }
    BackButton
    {
        visible: theSwipeView.currentIndex > 0
        onClicked: {
            if (theSwipeView.currentIndex == 1)
            {
                IDPGlobals.closeCovers(helpOffer)
                IDPGlobals.openCovers(helpType)
            }
            theSwipeView.currentIndex = theSwipeView.currentIndex - 1
        }
    }
}
