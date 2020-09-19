import QtQuick 2.15
import QtCharts 2.15

ESAAPage
{
    caption: "Deine Besuche"
    signal close
    ChartView
    {
        anchors.margins: 0
        plotArea: Qt.rect(0, ESAA.spacing / 2, width, height - ESAA.spacing)
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height / 5
        id: chart
        legend.visible: false
//        theme: ChartView.ChartThemeDark
        antialiasing: true
        margins.top: 0
        margins.left: 0
        margins.right: 0
        margins.bottom: 0
        animationOptions: ChartView.AllAnimations

        BarSeries {
            id: mySeries
            axisX: BarCategoryAxis { categories: ["Jan", "Feb", "Mrz", "Apr", "Mai", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Dez" ] }
            BarSet {
                color: ESAA.buttonColor
                borderWidth: 0
                borderColor: color
                values: [2, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13] }
            labelsVisible: false
//            BarSet { label: "Susan"; values: [5, 1, 2, 4, 1, 7] }
//            BarSet { label: "James"; values: [3, 5, 8, 13, 5, 8] }
        }
    }
    ListView
    {
        id: view
        anchors.top: chart.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: backbutton.top
        spacing: 1
        model: AllVisits
        clip: true
        delegate: Rectangle {
            width: view.width
            height: view.height / 10
            color: "red"
            ESAAText
            {
                anchors.centerIn: parent
                text: Visit.facilityName
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
