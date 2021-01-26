import QtQuick 2.15
import QtQuick.Controls 2.15
import "qrc:/foundation"

Item
{
    id: fewCardsItem
    anchors.fill: parent
    SwipeView
    {
        id: theSwipeView2
        anchors.top: parent.top
        anchors.bottom: fewCardsindicator.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: JW78APP.spacing
        clip: true
        Repeater
        {
            id: fewCardsRepeater
            model: AllCustomerCards
            delegate: Item {
                opacity: 1 - Math.abs((index * width - theSwipeView2.contentItem.contentX) / width)
                id: card1Item
                IDPText
                {
                    id: cardCaption
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: cardImage.paintedWidth
                    text: Card.name
                    elide: Text.ElideRight
                }

                Rectangle
                {
                    color: JW78APP.buttonFromColor
                    anchors.centerIn: cardImage
                    width: cardImage.paintedWidth + 2 * JW78APP.spacing
                    height: cardImage.paintedHeight + 2 * JW78APP.spacing // + cardCaption.height
                    radius: JW78APP.radius
                    id: theRect
                }


                Image
                {
                    autoTransform: true
                    anchors.leftMargin: JW78APP.spacing
                    anchors.rightMargin: JW78APP.spacing
                    anchors.bottomMargin: JW78APP.spacing
                    anchors.topMargin: JW78APP.spacing * 2
                    anchors.top: cardCaption.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    id: cardImage
                    source: "file:" + Card.filename
                    fillMode: Image.PreserveAspectFit
                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: showCustomerCard(Card.name, Card.filename, index)
                    }
                }
            }
        }
    }
    PageIndicator
    {
        id: fewCardsindicator
        height: JW78APP.spacing
        currentIndex: theSwipeView2.currentIndex
        anchors.bottom: parent.bottom
        count: theSwipeView2.count
        anchors.horizontalCenter: parent.horizontalCenter
        delegate: Item {
            width: JW78APP.spacing
            height: width
            Rectangle
            {
                anchors.centerIn: parent
                radius: width/ 2
                width: index == fewCardsindicator.currentIndex ? JW78APP.spacing : JW78APP.spacing / 2
                Behavior on width {
                    NumberAnimation {
                        duration: JW78Utils.shortAniDuration
                    }
                }

                height: width
                color: index == fewCardsindicator.currentIndex ? JW78APP.buttonFromColor : JW78APP.buttonToColor
            }
        }
    }
}
