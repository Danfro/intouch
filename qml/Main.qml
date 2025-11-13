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
import Qt.labs.settings 1.0
import "components"
import "pages"

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'intouch.sanderklootwijk'
    automaticOrientation: true
    
    width: units.gu(45)
    height: units.gu(75)

    // Version
    property string version: "1.0.0"

    theme.name: {
        switch (settings.theme) {
            case 0: return "";
            case 1: return "Lomiri.Components.Themes.Ambiance";
            case 2: return "Lomiri.Components.Themes.SuruDark";
            default: return "";
        }
    }

    Settings {
        id: settings

        property int theme: 0
        property int defaultTab: 0
    }
    
    PageStack {
        id: pageStack

        anchors.fill: parent

        Component.onCompleted: push(mainPage);
    }

    // Pages
    MainPage {
        id: mainPage

        anchors.fill: parent
        
        visible: false
    }

    SearchPage {
        id: searchPage

        anchors.fill: parent
        
        visible: false
    }

    SettingsPage {
        id: settingsPage

        anchors.fill: parent
        
        visible: false
    }

    AboutPage {
        id: aboutPage

        anchors.fill: parent
        
        visible: false
    }

    // Convert an ISO data/time string into a readable localized string
    function formatDateTime(isoString) {
        var date = new Date(isoString);
        var now = new Date();
        var diffMs = now - date;
        var diffDays = diffMs / (1000 * 60 * 60 * 24);
        
        if (diffDays > 30) {
            return Qt.formatDate(date, "dd MMM yyyy") + ", " + Qt.formatTime(date, Qt.DefaultLocaleShortDate);
        }

        var diffSec = Math.round(diffMs / 1000);
        var diffMin = Math.round(diffSec / 60);
        var diffHrs = Math.round(diffMin / 60);
        var days = Math.round(diffHrs / 24);

        if (diffSec < 60) {
            return i18n.tr("%1 seconds ago").arg(diffSec);
        }
        if (diffMin == 1) {
            return i18n.tr("one minute ago");
        }
        if (diffMin < 60) {
            return i18n.tr("%1 minutes ago").arg(diffMin);
        }
        if (diffHrs == 1) {
            return i18n.tr("about one hour ago");
        }
        if (diffHrs < 24) {
            return i18n.tr("about %1 hours ago").arg(diffHrs);
        }
        if (days == 1) {
            return i18n.tr("one day ago");
        }

        return i18n.tr("%1 days ago").arg(days);
    }
}