/********************************************************************
 KWin - the KDE window manager
 This file is part of the KDE project.

Copyright (C) 2011 Martin Gräßlin <mgraesslin@kde.org>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*********************************************************************/
import QtQuick 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.kquickcontrolsaddons 2.0
import org.kde.kwin 2.0 as KWin

KWin.Switcher {
    id: tabBox
    currentIndex: icons.currentIndex

    PlasmaCore.Dialog {
        id: dialog
        location: PlasmaCore.Types.Floating
        visible: tabBox.visible
        flags: Qt.X11BypassWindowManagerHint
        x: tabBox.screenGeometry.x + tabBox.screenGeometry.width * 0.5 - dialogMainItem.width * 0.5
        y: tabBox.screenGeometry.y + tabBox.screenGeometry.height * 0.5 - dialogMainItem.height * 0.5

        mainItem: Item {
            id: dialogMainItem
            property int optimalWidth: (icons.iconSize + icons.margins.left + icons.margins.right) * icons.count
            property int optimalHeight: icons.iconSize + icons.margins.top + icons.margins.bottom + units.gridUnit * 2
            property bool canStretchX: false
            property bool canStretchY: false
            width: Math.min(Math.max(tabBox.screenGeometry.width * 0.1, optimalWidth), tabBox.screenGeometry.width * 0.9)
            height: Math.min(Math.max(tabBox.screenGeometry.height * 0.05, optimalHeight), tabBox.screenGeometry.height * 0.5)

            IconTabBox {
                id: icons
                model: tabBox.model
                iconSize: units.iconSizes.small
                height: iconSize + icons.margins.top + icons.margins.bottom
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                Connections {
                    target: tabBox
                    onCurrentIndexChanged: {icons.currentIndex = tabBox.currentIndex;}
                }
            }
            Item {
                anchors {
                    top: icons.bottom
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                PlasmaComponents3.Label {
                    id: textItem
                    text: icons.currentItem ? icons.currentItem.caption : ""
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideMiddle
                    font.weight: Font.Bold
                    anchors {
                        right: parent.right
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                }
            }
            /*
            * Key navigation on outer item for two reasons:
            * @li we have to emit the change signal
            * @li on multiple invocation it does not work on the list view. Focus seems to be lost.
            **/
            Keys.onPressed: {
                if (event.key == Qt.Key_Left) {
                    icons.decrementCurrentIndex();
                } else if (event.key == Qt.Key_Right) {
                    icons.incrementCurrentIndex();
                }
            }
        }
    }
}
