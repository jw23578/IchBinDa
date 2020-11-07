import QtQuick 2.15

Flickable
{
    id: theMenue
    signal clicked(string buttonText)
    property variant buttonTexts: null
    property variant buttonSmallTopTexts: null
    property variant alertAniRunnings: null
    property variant repeatAlertAnis: null
    property variant visibles: null
    property int menueCount: 0
    function countVisibles()
    {
        menueCount = 0
        for (var i = 0; i < visibles.length; ++i)
        {
            if (visibles[i])
            {
                menueCount += 1
            }
        }
    }
    function show()
    {
        for (var i = 0; i < theRepeater.count; ++i)
        {
            theRepeater.itemAt(i).show()
        }
    }

    contentHeight: height
    contentWidth: theGrid.width
    Grid
    {
        id: theGrid
        property int buttonSize: JW78Utils.screenWidth / 3
        property int buttonFontPixelSize: ESAA.fontButtonPixelsize
        columns: menueCount / 2 + menueCount % 2
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: (buttonSize + spacing) * columns - spacing
        spacing: ESAA.spacing * 2
        rowSpacing: ESAA.spacing * 2
        topPadding: ESAA.spacing * 3
        Repeater
        {
            id: theRepeater
            model: buttonTexts
            CircleButton
            {
                id: aButton
                smallTopText: buttonSmallTopTexts[index]
                text: buttonTexts[index]
                width: theGrid.buttonSize
                font.pixelSize: theGrid.buttonFontPixelSize
                onClicked: theMenue.clicked(text)
                alertAniRunning: alertAniRunnings[index]
                repeatAlertAni: repeatAlertAnis[index]
                visible: visibles[index]
                function show()
                {
                    opacity = 0
                    showAni.start()
                }
                SequentialAnimation
                {
                    id: showAni

                    PauseAnimation {
                        duration: (index % theGrid.columns * 2 + Math.floor(index / theGrid.columns)) * 100 + 300
                    }
                    NumberAnimation
                    {
                        target: aButton
                        property: "opacity"
                        to: 1
                        duration: JW78Utils.shortAniDuration
                    }
                }
            }
        }
    }
}
