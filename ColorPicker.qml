import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Window {
    id: root
    width: 140
    height: 80
    readonly property real r:redSlider.value
    readonly property real g:greSlider.value
    readonly property real b:bluSlider.value
    readonly property real a:alpSlider.value
    function setColor(r_,g_,b_,a_){
        redSlider.x = Math.max(0,r_*(redPicker.width-redSlider.width))
        greSlider.x = Math.max(0,g_*(redPicker.width-redSlider.width))
        bluSlider.x = Math.max(0,b_*(redPicker.width-redSlider.width))
        alpSlider.x = Math.max(0,a_*(redPicker.width-redSlider.width))
    }

    flags: Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
    onActiveFocusItemChanged: {//失去焦点时隐藏
        if(!activeFocusItem)
            visible=false
    }
    signal accepted();
    signal rejected();

    Rectangle {
        anchors.fill: parent
        color: "#f6f6f6"
    }


    Item {
        property point startPos: Qt.point(0, 0)
        property point offsetPos: Qt.point(0, 0)

        Item{
            x:102
            Item {
                id: previewItem
                width: 38
                height: 15

                Grid {
                    id: previwBackground
                    anchors.fill: parent
                    rows: 11
                    columns: 11
                    clip: true

                    property real cellWidth: width / columns
                    property real cellHeight: height / rows

                    Repeater {
                        model: parent.columns * parent.rows

                        Rectangle {
                            width: previwBackground.cellWidth
                            height: width
                            color: (index % 2 == 0) ? "gray" : "transparent"
                        }
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    color: Qt.rgba(redSlider.value,greSlider.value,bluSlider.value,alpSlider.value)
                    border.color: "#e6e6e6"
                    border.width: 1
                }
            }
            Rectangle{
                x:0
                y:15
                width: 38
                height: 15
                color:Qt.rgba(0.8,0.8,0.8)
                Text{
                    anchors.fill: parent
                    id:vr
                    text:"R:"+(redSlider.value * 255).toFixed(0);
                    font.pixelSize: 14
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Rectangle{
                x:0
                y:30
                width: 38
                height: 15
                color:Qt.rgba(0.8,0.8,0.8)
                Text{
                    anchors.fill: parent
                    id:vg
                    text:"G:"+(greSlider.value * 255).toFixed(0);
                    font.pixelSize: 14
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Rectangle{
                x:0
                y:45
                width: 38
                height: 15
                color:Qt.rgba(0.8,0.8,0.8)
                Text{
                    anchors.fill: parent
                    id:vb
                    text:"B:"+(bluSlider.value * 255).toFixed(0);
                    font.pixelSize: 14
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Rectangle{
                x:0
                y:60
                width: 38
                height: 15
                color:Qt.rgba(0.8,0.8,0.8)
                Text{
                    anchors.fill: parent
                    id:va
                    text:"A:"+(alpSlider.value * 255).toFixed(0);
                    font.pixelSize: 14
                    horizontalAlignment:Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Rectangle {
            id: redPicker
            width: 100
            height: 15
            x:0
            y:0
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0;  color: Qt.rgba(0,greSlider.value,bluSlider.value) }
                GradientStop { position: 1.0;  color: Qt.rgba(1,greSlider.value,bluSlider.value) }
            }

            Rectangle {
                id: redSlider
                width: height
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                border.color: "#e6e6e6"
                border.width: 2
                scale: 0.9
                color: Qt.rgba(redSlider.value,greSlider.value,bluSlider.value)

                property real value: x / (parent.width - width)
            }

            MouseArea {
                anchors.fill: parent

                function handleCursorPos(x) {
                    let halfWidth = redSlider.width * 0.5;
                    redSlider.x = Math.max(0, Math.min(width, x + halfWidth) - redSlider.width);
                }
                onPressed: (mouse) => {
                    handleCursorPos(mouse.x, mouse.y);
                }
                onPositionChanged: (mouse) => handleCursorPos(mouse.x);
            }
        }
        Rectangle {
            id: grePicker
            width: 100
            height: 15
            x:0
            y:20
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0;  color: Qt.rgba(redSlider.value,0,bluSlider.value) }
                GradientStop { position: 1.0;  color: Qt.rgba(redSlider.value,1,bluSlider.value) }
            }

            Rectangle {
                id: greSlider
                width: height
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                border.color: "#e6e6e6"
                border.width: 2
                scale: 0.9
                color: Qt.rgba(redSlider.value,greSlider.value,bluSlider.value)

                property real value: x / (parent.width - width)
            }

            MouseArea {
                anchors.fill: parent

                function handleCursorPos(x) {
                    let halfWidth = greSlider.width * 0.5;
                    greSlider.x = Math.max(0, Math.min(width, x + halfWidth) - greSlider.width);
                }
                onPressed: (mouse) => {
                    handleCursorPos(mouse.x, mouse.y);
                }
                onPositionChanged: (mouse) => handleCursorPos(mouse.x);
            }
        }

        Rectangle {
            id: bluPicker
            width: 100
            height: 15
            x:0
            y:40
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0;  color: Qt.rgba(redSlider.value,greSlider.value,0) }
                GradientStop { position: 1.0;  color: Qt.rgba(redSlider.value,greSlider.value,1) }
            }

            Rectangle {
                id: bluSlider
                width: height
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                border.color: "#e6e6e6"
                border.width: 2
                scale: 0.9
                color: Qt.rgba(redSlider.value,greSlider.value,bluSlider.value)

                property real value: x / (parent.width - width)
            }

            MouseArea {
                anchors.fill: parent

                function handleCursorPos(x) {
                    let halfWidth = bluSlider.width * 0.5;
                    bluSlider.x = Math.max(0, Math.min(width, x + halfWidth) - bluSlider.width);
                }
                onPressed: (mouse) => {
                    handleCursorPos(mouse.x, mouse.y);
                }
                onPositionChanged: (mouse) => handleCursorPos(mouse.x);
            }
        }
        Item {
            id: alpPickerItem
            width: 100
            height: 15
            x:0
            y:60

            Grid {
                id: alphaPicker
                anchors.fill: parent
                rows: 4
                columns: 29
                clip: true

                property real cellWidth: width / columns
                property real cellHeight: height / rows

                Repeater {
                    model: parent.columns * parent.rows

                    Rectangle {
                        width: alphaPicker.cellWidth
                        height: width
                        color: (index % 2 == 0) ? "gray" : "transparent"
                    }
                }
            }

            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 1.0; color: "#ff000000" }
                    GradientStop { position: 0.0; color: "#00ffffff" }
                }
            }

            Rectangle {
                id: alpSlider
                x: parent.width - width
                width: height
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                color: Qt.rgba(0.1, 0.1, 0.1, (value + 1.0) / 2.0)
                border.color: "#e6e6e6"
                border.width: 2
                scale: 0.9


                property real value: x / (parent.width - width)

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 1
                    color: "transparent"
                    border.color: "white"
                    border.width: 1
                }
            }

            MouseArea {
                anchors.fill: parent

                function handleCursorPos(x) {
                    let halfWidth = alpSlider.width * 0.5;
                    alpSlider.x = Math.max(0, Math.min(width, x + halfWidth) - alpSlider.width);
                }
                onPressed: (mouse) => {
                    handleCursorPos(mouse.x, mouse.y);
                }

                onPositionChanged: (mouse) => handleCursorPos(mouse.x);
            }
        }
    }
}
