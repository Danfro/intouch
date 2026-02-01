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
import Lomiri.Components.Popups 1.3
import QtQuick.Layouts 1.3
import QtWebEngine 1.11

Page {
    id: webEngineViewPage

    property alias topicWebView: topicWebView
    property alias accountWebView: accountWebView
    property bool accountMode: false
    property string topicSlug
    property string replyPid
    property string replyMode
    property bool replyTriggered: false

    header: PageHeader {
        id: webEngineViewPageHeader

        leadingActionBar.actions: [
            Action {
                visible: !accountMode
                iconName: "close"
                text: i18n.tr("Close")
                onTriggered: {
                    triggerReplyTimer.stop();
                    topicWebView.url = "about:blank";
                    pageStack.pop();
                }
            },
            Action {
                visible: accountMode
                iconName: "back"
                text: i18n.tr("Back")
                onTriggered: {
                    webEngineViewPage.accountWebView.url = "https://forums.ubports.com/login";
                    accountMode = false;
                    pageStack.pop();
                }
            }
        ]
        
        title: {
            if (accountMode) {
                if (accountWebView.url.toString().startsWith("https://forums.ubports.com/login")) {
                    i18n.tr("Login")
                }
                else {
                    i18n.tr("Account")
                }
            }
            else {
                i18n.tr("Reply")
            }
        }
    }

    WebEngineView {
        id: accountWebView

        visible: accountMode

        property bool ignoreUrlChanged: false

        anchors {
            fill: parent
            topMargin: webEngineViewPageHeader.height
        }

        opacity: loadProgress == 100 ? 1 : 0

        url: "https://forums.ubports.com/login"

        profile: forumProfile
        zoomFactor: units.gu(1) / 8

        userScripts: [
            WebEngineScript {
                injectionPoint: WebEngineScript.DocumentReady
                sourceUrl: theme.name == "Lomiri.Components.Themes.SuruDark" ? "../js/account-dark.js" : "../js/account.js"
                worldId: WebEngineScript.UserWorld
            }
        ]

        onLoadingChanged: fetchLoginStatus();

        onUrlChanged: {
            if (ignoreUrlChanged) {
                ignoreUrlChanged = false;
                return;
            }

            const urlStr = url.toString();

            if (urlStr.startsWith("https://forums.ubports.com/login") || urlStr.startsWith("https://forums.ubports.com/user")) {
                return;
            }

            if (urlStr === "about:blank") {
                return;
            }

            else {
                if (urlStr.startsWith("https://forums.ubports.com/register")) {
                    Qt.openUrlExternally(urlStr);
                }

                ignoreUrlChanged = true;
                accountWebView.url = "https://forums.ubports.com/login";
                return;
            }
        }

        onJavaScriptConsoleMessage: function(level, msg, line, source) {
            if (level == 1) {
                if (msg.includes("{\"notifications\"")) {
                    notificationsPage.parseNotifications(msg);
                }
                if (msg.includes("loggedInUser")) {
                    parseLoginStatus(msg);
                }
                if (msg.includes("not-authorised")) {
                    parseLoginStatus(msg);
                }
            }
        }
    }

    WebEngineView {
        id: topicWebView

        visible: !accountMode

        property string lastAllowedUrl: ""
        property bool ignoreUrlChanged: false

        anchors {
            fill: parent
            topMargin: webEngineViewPageHeader.height
        }
        
        opacity: loadProgress == 100 ? 1 : 0

        url: ""

        profile: forumProfile
        zoomFactor: units.gu(1) / 8

        onLoadingChanged: {
            if (accountMode) {
                return;
            }
            if (topicWebView.url == "about:blank") {
                return;
            }
            if (loadRequest.status === WebEngineLoadRequest.LoadSucceededStatus && !replyTriggered) {
                triggerReplyTimer.start();
            }

            fetchLoginStatus();
        }

        Timer {
            id: triggerReplyTimer
            interval: 300
            repeat: false

            onTriggered: {
                topicWebView.runJavaScript(`
                    (function () {
                        if ("${replyMode}" === "topicreply") {
                            const div = document.querySelector(
                                'div[component="topic/reply/container"]'
                            );
                            if (!div) {
                                return "not-found";
                            }
                            if (div.classList.contains("hidden")) {
                                return "hidden";
                            }

                            const replybtn = div.querySelector(
                                'a[component="topic/reply"]'
                            );
                            if (!replybtn) {
                                return "not-found";
                            }

                            return "ready";
                        }

                        const post = document.querySelector(
                            'li[data-pid="${replyPid}"]'
                        );
                        if (!post) {
                            return "not-found";
                        }

                        const btn = post.querySelector(
                            'a[component="${replyMode === "reply" ? "post/reply" : replyMode === "quote" ? "post/quote" : "post/reply" }"]'
                        );

                        if (!btn) {
                            return "not-found";
                        }

                        if (btn.classList.contains("hidden")) {
                            return "hidden";
                        }

                        return "ready";
                    })();
                `, function(result) {

                    if (result === "not-found") {
                        console.log("Post or reply button not found yet");
                        triggerReplyTimer.start();
                        return;
                    }

                    if (result === "hidden") {
                        console.log("Reply button is hidden, aborting trigger");
                        PopupUtils.open(accountDialogComponent)
                        triggerReplyTimer.stop();
                        return;
                    }

                    if (result === "ready") {
                        console.log("Reply button ready");
                        triggerReplyTimer.stop();
                        replyTriggered = true;
                        topicWebView.triggerReply(replyPid, replyMode);
                    }
                });
            }
        }

        userScripts: [
            WebEngineScript {
                injectionPoint: WebEngineScript.DocumentReady
                sourceUrl: theme.name == "Lomiri.Components.Themes.SuruDark" ? "../js/topic-dark.js" : "../js/topic.js"
                worldId: WebEngineScript.UserWorld
            }
        ]

        onUrlChanged: {
            if (ignoreUrlChanged) {
                ignoreUrlChanged = false;
                return;
            }

            const urlStr = url.toString();

            if (urlStr === "about:blank") {
                return;
            }

            if (urlStr.startsWith("https://forums.ubports.com/topic/" + topicSlug)) {
                lastAllowedUrl = urlStr;
                return;
            }

            ignoreUrlChanged = true;

            if (!urlStr.startsWith("https://forums.ubports.com/login")) {
                Qt.openUrlExternally(urlStr);
            }

            if (lastAllowedUrl !== "") {
                topicWebView.url = lastAllowedUrl;
            }
        }

        function triggerReply(pid, mode) {
            topicWebView.runJavaScript(`
                (function clickReply(startTime = Date.now()) {
                    if ("${mode}" === "topicreply") {
                        const div = document.querySelector(
                            'div[component="topic/reply/container"]'
                        );
                        if (div) {
                            const replybtn = div.querySelector(
                                'a[component="topic/reply"]'
                            );
                            replybtn.click();
                        }
                    }
                    const post = document.querySelector('li[data-pid="${pid}"]');
                    if (post) {
                        const btn = post.querySelector('a[component="post/${mode}"]');
                        if (btn && !btn.classList.contains('hidden')) {
                            btn.click();
                        }
                    }
                })();
            `);
        }
    }

    ProgressBar {
        visible: accountMode ? accountWebView.loadProgress < 100 : topicWebView.loadProgress < 100

        anchors {
            top: webEngineViewPageHeader.bottom
            left: parent.left
            right: parent.right
        }

        minimumValue: 0
        maximumValue: 100
        value: accountMode ? accountWebView.loadProgress : topicWebView.loadProgress
    }

    Component {
        id: accountDialogComponent

        Dialog {
            id: accountDialog

            title: i18n.tr("Are you logged in?")
            text: i18n.tr("To reply to this topic, please make sure you are logged in to your account. You can do this through the app settings or by using the login button below.")

            Button {
                text: i18n.tr("Login")
                color: theme.palette.normal.positive

                onClicked: {
                    triggerReplyTimer.stop();
                    webEngineViewPage.replyTriggered = false;
                    topicWebView.url = "about:blank";
                    webEngineViewPage.accountMode = true;
                    webEngineViewPage.accountWebView.url = "https://forums.ubports.com/login";
                    PopupUtils.close(accountDialog);
                }
            }

            Button {
                text: i18n.tr("Cancel")

                onClicked: PopupUtils.close(accountDialog)
            }
        }
    }
}

