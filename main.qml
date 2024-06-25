import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import Qt.labs.platform 1.1

Window {
    id: main
    width: 640
    height: 480
    visible: true
    title: qsTr("GMTII")

    ListModel {id: searchModel}

    property alias searchEnable: searchLay.visible

    //-- Get the list of search from Qt --//
    Connections {
        target: ThreadRunner

        function onResultList(list)
        {
            for(var i=0; i<list.length; i++){
                searchModel.append({
                                       "url": list[i]
                                   })
            }
        }
    }

    //-- browse and search files Animation --//
    ParallelAnimation{
        id: browseAnim
        PropertyAnimation { target: searchLay ; properties: "visible"; to: true ; duration: 0}
        PropertyAnimation { target: browseText ; properties: "Layout.preferredWidth"; from:0; to: browesLay.width * 0.8 ; duration: 300 }
        PropertyAnimation { target: lView ; properties: "Layout.preferredHeight"; to: main.height * 0.7 ; duration: 300 }
    }

    //-- Home --//
    Rectangle{
        anchors.fill: parent
        color: "steelblue"
        ColumnLayout{
            anchors.fill: parent
            spacing: 0

            RowLayout{
                id: browesLay
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height * 0.15
                Layout.margins: 10
                spacing: 10
                TextField{
                    id: browseText
                    Layout.fillHeight: true
                    Layout.preferredWidth: (searchEnable) ? parent.width * 0.8:0
                    font.pixelSize: Qt.application.font.pixelSize * 1.2
                    verticalAlignment: Qt.AlignVCenter
                    horizontalAlignment: Qt.AlignHCenter
                    selectByMouse: true
                    readOnly: true
                    text: ""
                }

                Button{
                    id: browseButton
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    text: "Browse"
                    background: Rectangle {

                        border.width: browseButton.activeFocus ? 2 : 1
                        border.color: "#888"
                        radius: 4
                        color: "#808080"
                    }
                    MouseArea{
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            folderDialog.open()
                        }
                    }
                }
            }


            RowLayout{
                id: searchLay
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height * 0.15
                Layout.margins: 10
                spacing: 10
                visible: false
                TextField{
                    id: searchText
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.8
                    font.pixelSize: Qt.application.font.pixelSize * 1.2
                    verticalAlignment: Qt.AlignVCenter
                    horizontalAlignment: Qt.AlignHCenter
                    selectByMouse: true
                    text: ""
                    Label{
                        id: searchplaceholder

                        visible: (searchText.length >= 1) ? false : true

                        text: "Enter file or folder name for searching"

                        anchors.leftMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter


                        font.pixelSize: Qt.application.font.pixelSize * 1.2

                        color: "darkgray"

                        background: Rectangle{
                            color: "transparent"
                        }

                    }
                }

                Button{
                    id: searchButton
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    text: "Search"
                    background: Rectangle {

                        border.width: searchButton.activeFocus ? 2 : 1
                        border.color: "#888"
                        radius: 4
                        color: "#808080"
                    }
                    MouseArea{
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            ThreadRunner.start(browseText.text, searchText.text)
                            searchModel.clear()
                        }
                    }
                }
            }

            ListView{
                id: lView
                Layout.fillWidth: true
                Layout.preferredHeight: (searchEnable) ? parent.height * 0.7:parent.height * 0.85
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                spacing: 0
                clip: true
                model: searchModel
                ScrollBar.vertical: ScrollBar {

                }
                delegate: Rectangle {
                    width: lView.width
                    height: 50
                    color: (index%2==0) ? "#dcdcdc":"#808080"
                    Label{
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: url
                    }

                }
            }
        }
    }

    //-- Folder dialog --//
    FolderDialog {
        id: folderDialog
        visible: false
        title: "Please choose a folder"

        onAccepted: {
            var path = folderDialog.folder.toString()
            path = path.replace(/^(file:\/{3})/,"")
            browseText.text = path
            if (!searchEnable){
                browseAnim.restart()
            }
        }
        onRejected: {
            console.log("Canceled")
        }
    }
}
