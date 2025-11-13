/*
 * Copyright (C) 2025  Sander Klootwijk
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * intouch is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

LomiriShape {
    id: userPictureShape
    
    // Size can be small, medium or large
    property string size
    property string userPicture
    property string userColor

    height: {
        if (size == "small") {
            units.gu(3.5)
        } else if (size == "medium") {
            units.gu(5.25)
        } else if (size == "large") {
            units.gu(7)
        }
    }
    width: height

    source: Image {
        id: userPicture
        
        source: userPictureShape.userPicture
    }

    Label {
        visible: userPicture.status != Image.Ready
        anchors.centerIn: parent

        color: "#FFFFFF"
        text: usernameText
        textSize: {
            if (size == "small") {
                Label.Medium
            } else if (size == "medium") {
                Label.Large
            } else if (size == "large") {
                Label.XLarge
            }
        }
    }

    backgroundColor: userPicture.status != Image.Ready ? userColor : "transparent"
    aspect: LomiriShape.Flat
    radius: "medium"
}