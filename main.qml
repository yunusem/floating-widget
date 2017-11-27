import QtQuick 2.5
import QtQuick.Controls 1.5
import QtQuick.Window 2.0

ApplicationWindow {
    id:appWindow
    visible: true
    width: 60
    height: 60
    opacity: 1.0
    x: Screen.width - 120
    y: Screen.height - 270
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.X11BypassWindowManagerHint
    color: "transparent"
    property bool widgetsOn: false
    property bool animationRunning: rotateCW.running | rotateCCW.running | shrinkAnimation.running | blowAnimation.running
    property bool rightButtonPressed: false

    RotationAnimation {
        id: rotateCW
        target: btn
        from: 0
        to: 90
        duration: 100
        onStopped: {
            blowAnimation.start()
        }
    }

    RotationAnimation {
        id: rotateCCW
        target: btn
        from: 90
        to: 0
        duration: 100
        onStopped: {
            blowAnimation.start()
        }
    }

    NumberAnimation {
        id: shrinkAnimation
        target: btn
        easing.type: Easing.OutExpo
        properties: "width, height"
        from: btn.width
        to: btn.width - 20
        duration: 100
        onStopped: {
            if(btn.checked) {
                rotateCCW.start()
            } else {
                rotateCW.start()
            }
        }
        onStarted: {
            if(btn.checked) {
                widgetsOn = false
            }
        }
    }

    NumberAnimation {
        id: blowAnimation
        target: btn
        properties: "width, height"
        from: btn.width
        to: btn.width + 20
        duration: 100
        easing.type: Easing.InExpo
        onStopped: {
            btn.checked = !btn.checked
            if(btn.checked) {
                widgetsOn = true
            }
        }
    }

    Widgets {
        id:widgetsWindow
        x: appWindow.x
        y: appWindow.y - 10 - widgetsWindow.height
        isVisible: widgetsOn
    }


    Rectangle {
        id: btn
        visible: true
        width: parent.width
        height: btn.width
        radius: btn.width / 8
        smooth: true
        rotation: 0

        color: "#2e82d1"
        anchors.centerIn: parent
        property bool dragging : false
        property bool checked : false

        onDraggingChanged: {
            if(btn.dragging && widgetsOn) {
                shrinkAnimation.start()
            }
        }

        MouseArea {
            id:btnMouseArea

            property var cpos
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: {
                if(mouse.button & Qt.RightButton) {

                } else if(mouse.button & Qt.LeftButton) {
                    if(!animationRunning) {
                        if (btn.checked) {
                            btn.color = "#2e82d1"
                            btnText.color = "#ffffff"
                        } else {
                            btn.color = "#14426d"
                            btnText.color = "#dfdfdf"
                        }
                        shrinkAnimation.start()
                    }
                }
            }

            onPressed: {
                if(mouse.button & Qt.RightButton) {
                    btn.color = "#d12e2e"
                    btnText.color = "#ffffff"
                    rightButtonPressed = true
                } else if(mouse.button & Qt.LeftButton) {
                    cpos = Qt.point(mouse.x,mouse.y);
                    btn.color = "#14426d"
                    btnText.color = "#dfdfdf"
                }
            }
            onPressAndHold: {
                if(mouse.button & Qt.RightButton) {
                    btn.color = "#d12e2e"
                    btnText.color = "#ffffff"
                    rightButtonPressed = true
                } else if(mouse.button & Qt.LeftButton) {
                    cursorShape = Qt.DragMoveCursor
                    btn.dragging = true
                    btn.color =  "#14426d"
                    btnText.color = "#dfdfdf"
                }
            }
            onReleased: {
                    cursorShape = Qt.ArrowCursor
                    rightButtonPressed = false
                    btn.dragging = false
                    if(!btn.checked) {
                        btn.color = "#2e82d1"
                        btnText.color = "#ffffff"
                    } else {
                        btn.color = "#14426d"
                        btnText.color = "#dfdfdf"
                    }


            }
            onPositionChanged: {
                if(btnMouseArea.pressed && btn.dragging) {
                    var delta = Qt.point(mouse.x - cpos.x, mouse.y - cpos.y);
                    appWindow.x += delta.x;
                    appWindow.y += delta.y;
                }
            }
        }
    }
    Text {
        id: btnText
        anchors.centerIn: parent
        text: btn.dragging ? "On the\nMove" : "What is\nthis ?" |
                             btn.checked ? "I Don't\nKnow" : "What is\nthis ?" |
                             rightButtonPressed ? "I Really\nDo Not\nKnow" : "What is\nthis ?"
        font.bold: true
        font.pointSize: 7
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color:"#ffffff"
    }

}
