import QtQuick 2.15
import QtCharts 2.15

ESAAPage
{
    caption: "Meine Besuche"
    signal close
    //    ChartView
    //    {
    //        anchors.margins: 0
    //        plotArea: Qt.rect(0, ESAA.spacing / 2, width, height - ESAA.spacing)
    //        anchors.top: parent.top
    //        anchors.left: parent.left
    //        anchors.right: parent.right
    //        height: parent.height / 5
    //        id: chart
    //        legend.visible: false
    ////        theme: ChartView.ChartThemeDark
    //        antialiasing: true
    //        margins.top: 0
    //        margins.left: 0
    //        margins.right: 0
    //        margins.bottom: 0
    //        animationOptions: ChartView.AllAnimations

    //        BarSeries {
    //            id: mySeries
    //            axisX: BarCategoryAxis { categories: ["Jan", "Feb", "Mrz", "Apr", "Mai", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Dez" ] }
    //            BarSet {
    //                color: ESAA.buttonColor
    //                borderWidth: 0
    //                borderColor: color
    //                values: [2, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13] }
    //            labelsVisible: false
    //        }
    //    }
    ListView
    {
        id: view
        anchors.top: parent.top
        anchors.topMargin: ESAA.spacing
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: backbutton.top
        anchors.bottomMargin: ESAA.spacing
        spacing: 1
        model: AllVisits
        clip: true
        delegate: Item {
            width: view.width
            height: view.height / 8
            Item
            {
                id: logoItem
                height: parent.height
                width: height
                anchors.left: parent.left
                Image {
                    id: logo
                    source: Visit.logoUrl
                    anchors.centerIn: parent
                    height: parent.height - ESAA.spacing / 2
                    width: height
                    fillMode: Image.PreserveAspectFit
                }
                Rectangle
                {
                    anchors.centerIn: parent
                    height: parent.height - ESAA.spacing / 2
                    width: height
                    radius: width / 2
                    color: ESAA.buttonColor
                    visible: logo.source == ""
                }
            }
            ESAAText
            {
                anchors.top: parent.top
                anchors.topMargin: ESAA.spacing / 2
                anchors.left: logoItem.right
                anchors.leftMargin: ESAA.spacing
                text: Visit.facilityName
                font.pixelSize: ESAA.fontTextPixelsize * 1.3
            }
            ESAAText
            {
                anchors.left: logoItem.right
                anchors.leftMargin: ESAA.spacing
                anchors.bottom: parent.bottom
                anchors.bottomMargin: ESAA.spacing / 2
                text: ESAA.formatDate(Visit.begin) + " " + ESAA.formatTime(Visit.begin)
            }

            Rectangle
            {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: "black"
            }
        }
    }

    BackButton
    {
        id: backbutton
        onClicked: close()
    }
    onBackPressed:
    {
        close()
    }
}
