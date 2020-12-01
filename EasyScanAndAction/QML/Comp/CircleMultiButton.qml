import QtQuick 2.0

Item
{
    id: circlemultibutton
    width: JW78Utils.screenWidth / 4
    height: width
    signal openClicked
    function open()
    {
        openani1.start()
        optionsRepeater.openAll()
        isOpen = true
        text = "-"
        openClicked()
    }

    signal closeClicked
    function close()
    {
        isOpen = false
        text = "+"
        closeani1.start()
        optionsRepeater.closeAll()
        closeClicked()
    }
    property bool isOpen: false
    property int smallWidth: JW78Utils.screenWidth / 6
    property int largeWidth: JW78Utils.screenWidth / 4
    property alias text: mainbutton.text
    property var texts: null
    property var clickEvents: null
    property var visibleMasters: null
    property var sources: null
    property var downSources: null

    visible: opacity > 0
    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    property int stepAngle: 60
    property double horizontalMoveFaktor: 2.2
    property int optionCount: texts != null && sources != null ? Math.max(texts.length, sources.length) : texts != null ? texts.length : source != null ? source.length : 0
    property int yMoveOnOpen: smallWidth

    Item
    {
        id: allButtons
        anchors.centerIn: parent
        CircleButton
        {
            id: mainbutton
            anchors.centerIn: parent
            text: "+"
            onClicked:
            {
                if (circlemultibutton.isOpen)
                {
                    close()
                }
                else
                {
                    open()
                }
            }
        }
        Repeater
        {
            id: optionsRepeater
            model: optionCount
            delegate: Item
            {
                id: optionItem
                anchors.centerIn: parent
                width: 0
                height: 0
                function startOpenAni()
                {
                    openOption.start()
                }
                function startCloseAni()
                {
                    closeOption.start()
                }
                CircleButton
                {
                    id: theOption
                    property bool visibleMaster: circlemultibutton.visibleMasters == null ? true : circlemultibutton.visibleMasters.length > index ? circlemultibutton.visibleMasters[index] : true
                    visible: opacity > 0 && visibleMaster
                    width: smallWidth
                    opacity: 0
                    anchors.horizontalCenter: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    rotation: -parent.rotation
                    text: circlemultibutton.texts[index]
                    onClicked: circlemultibutton.clickEvents[index]()
                    source: circlemultibutton.sources == null ? "" : circlemultibutton.sources.length > index ? circlemultibutton.sources[index] : ""
                    downSource: circlemultibutton.downSources == null ? "" : circlemultibutton.downSources.length > index ? circlemultibutton.downSources[index] : ""

                }
                SequentialAnimation
                {
                    id: openOption
                    ParallelAnimation
                    {
                        NumberAnimation {
                            target: optionItem
                            property: "width"
                            duration: 200
                            to: -horizontalMoveFaktor * largeWidth
                        }
                        NumberAnimation {
                            target: theOption
                            property: "width"
                            duration: 200
                            to: largeWidth
                        }
                        NumberAnimation {
                            target: theOption
                            property: "opacity"
                            duration: 200
                            to: 1
                        }

                    }
                    NumberAnimation
                    {
                        target: optionItem
                        property: "rotation"
                        to: stepAngle * index
                        duration: 200
                    }
                }
                SequentialAnimation
                {
                    id: closeOption
                    NumberAnimation
                    {
                        target: optionItem
                        property: "rotation"
                        to: 0
                        duration: 200
                    }
                    ParallelAnimation
                    {
                        NumberAnimation {
                            target: optionItem
                            property: "width"
                            duration: 200
                            to: 0
                        }
                        NumberAnimation {
                            target: theOption
                            property: "width"
                            duration: 200
                            to: smallWidth
                        }
                        NumberAnimation {
                            target: theOption
                            property: "opacity"
                            duration: 200
                            to: 0
                        }
                    }
                }
            }
            function openAll()
            {
                for (var i = 0; i < count; ++i)
                {
                    var item = optionsRepeater.itemAt(i)
                    item.startOpenAni()
                }
            }
            function closeAll()
            {
                for (var i = 0; i < count; ++i)
                {
                    var item = optionsRepeater.itemAt(i)
                    item.startCloseAni()
                }
            }
        }
    }

    SequentialAnimation
    {
        id: openani1
        NumberAnimation
        {
            target: mainbutton
            property: "width"
            to: smallWidth
            duration: 200
        }
        NumberAnimation
        {
            target: allButtons
            property: "anchors.verticalCenterOffset"
            to: yMoveOnOpen
            duration: 200
        }
    }
    SequentialAnimation
    {
        id: closeani1
        NumberAnimation
        {
            target: allButtons
            property: "anchors.verticalCenterOffset"
            to: 0
            duration: 200
        }
        NumberAnimation
        {
            target: mainbutton
            property: "width"
            to: largeWidth
            duration: 200
        }
    }
}
