import QtQuick 2.5
import QtQuick.Controls 1.5

ApplicationWindow {
    id:widgetsWindow
    visible: false
    width: 60
    height: 130
    color: "transparent"
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.X11BypassWindowManagerHint
    opacity: 0
    property bool isVisible: false
    Rectangle {
        id:w1
        visible: widgetsWindow.visible
        smooth: true
        width: parent.width
        height: w1.width
        radius: w1.width / 8
        antialiasing: true
        color: "orange"
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        Text {
            id:w1Text
            anchors.centerIn: parent
            text: "Widget 1"
            font.bold: true
            font.pointSize: 7
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color:"#ffffff"
        }

    }

    Rectangle {
        id:w2
        visible: widgetsWindow.visible
        smooth: true
        width: parent.width
        height: w2.width
        radius: w2.width / 8
        antialiasing: true
        color: "orange"
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        Text {
            id:w2Text
            anchors.centerIn: parent
            text: "Widget 2"
            font.bold: true
            font.pointSize: 7
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color:"#ffffff"
        }

    }

    onIsVisibleChanged: {
        if(isVisible) {
            makeVisible.start()
        } else {
            makeInvisible.start()
        }
    }

    NumberAnimation {
        id:makeVisible
        target: widgetsWindow
        property: "opacity"
        from: 0
        to: 1
        duration: 200
        onStarted: {
            widgetsWindow.visible = true
        }
    }

    NumberAnimation {
        id:makeInvisible
        target: widgetsWindow
        property: "opacity"
        from: 1
        to: 0
        duration: 200
        onStopped: {
            widgetsWindow.visible = false
        }
    }
}
