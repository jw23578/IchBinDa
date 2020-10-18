import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."
import "../Comp"

ESAAPage {
    caption: "Kundenkarten"
    signal newCard;
    signal showCustomerCard(string name, string filename)
    ESAAFlickable
    {
        id: theFlick
        anchors.margins: ESAA.spacing
        anchors.bottom: newCard.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        contentHeight: theBigColumn.height
        Column
        {
            id: theBigColumn
            width: parent.width
            spacing: ESAA.spacing
            parent: theFlick.contentItem
            Repeater
            {
                id: theRepeater
                model: AllCustomerCards
                Item
                {
                    Component.onCompleted:
                    {
                        console.log("created " + height)
                    }
                    height: theColumn.height
                    width: parent.width
                    Column
                    {
                        id: theColumn
                        width: parent.width
                        height: cardName.height
                        ESAAText
                        {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            id: cardName
                            text: Card.name
                        }
                        Rectangle
                        {
                            height: 1
                            anchors.left: parent.left
                            anchors.right: parent.right
                            color: "black"
                        }
                    }
                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: showCustomerCard(Card.name, Card.filename)
                    }
                }
            }
        }

    }
    CentralActionButton
    {
        id: newCard
        text: "Neue<br>Karte"
        onClicked: parent.newCard()
    }

    BackButton
    {
        onClicked: backPressed()
    }
}
