import QtQuick 2.15
import QtQuick.Controls 2.15
import ".."
import "../Comp"

ESAAPage {
    caption: "Kundenkarten"
    signal newCard;
    signal showCustomerCard(string name, string filename)
    CircleButton
    {
        anchors.right: parent.right
        anchors.top: parent.top
        text: "alle karten<br>löschen"
        visible: JW78APP.isDevelop
        onClicked: JW78APP.deleteAllCustomerCards()
        z: 2
    }
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
                        Item
                        {
                            height: ESAA.spacing
                            width: parent.width
                        }
                        ESAAText
                        {
                            text: Card.name
                            width: parent.width
                            font.pixelSize: ESAA.headerFontPixelsize
                            color: JW78APP.headerFontColor
                            id: cardName
                        }

                        Item
                        {
                            height: ESAA.spacing
                            width: parent.width
                        }

                        Rectangle
                        {
                            visible: index < theRepeater.count - 1
                            width: parent.width / 6
                            height: 1
                            color: "lightgrey"
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
    Item
    {
        id: noCardsItem
        visible: theRepeater.count == 0
        anchors.fill: theFlick

        SwipeView
        {
            id: theSwipeView
            anchors.top: parent.top
            anchors.bottom: indicator.top
            anchors.left: parent.left
            anchors.right: parent.right
            Rectangle
            {
                id: itemA
                color: "red"
                opacity: 1 - theSwipeView.contentItem.contentX / width
            }
            Rectangle
            {
                id: itemB
                opacity: 1 - itemA.opacity
                color: "blue"
            }
        }
        PageIndicator
        {
            id: indicator
            height: JW78APP.spacing
            currentIndex: theSwipeView.currentIndex
            anchors.bottom: parent.bottom
            count: theSwipeView.count
            anchors.horizontalCenter: parent.horizontalCenter
            delegate: Rectangle
            {
                radius: width/ 2
                width: JW78APP.spacing
                height: width
                color: index == indicator.currentIndex ? JW78APP.buttonFromColor : JW78APP.buttonToColor
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
